// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin Governance Modules
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

// Token Interfaces (custom)
import "./NeighborGovernanceToken.sol"; // NGT - Voting token
import "./NeighborRewardToken.sol";     // NRT - Reward token

import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

contract NeighborDAO is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    NeighborGovernanceToken public ngtToken;
    NeighborRewardToken public nrtToken;

    mapping(address => bool) public proposalWhitelist;
    mapping(uint256 => uint256) public voteStartTime;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // === Constructor ===
    constructor(
        NeighborGovernanceToken _ngtToken,
        NeighborRewardToken _nrtToken,
        TimelockController _timelock,
        address[] memory _proposalWhitelist
    )
        Governor("NeighborDAO")
        GovernorVotes(_ngtToken)
        GovernorVotesQuorumFraction(4) // 4% quorum
        GovernorTimelockControl(_timelock)
    {
        ngtToken = _ngtToken;
        nrtToken = _nrtToken;

        for (uint256 i = 0; i < _proposalWhitelist.length; i++) {
            proposalWhitelist[_proposalWhitelist[i]] = true;
        }
    }

    // === Voting Config ===
    function votingDelay() public pure override returns (uint256) {
        return 7200; // ~1 day in blocks
    }

    function votingPeriod() public pure override returns (uint256) {
        return 50400; // ~1 week in blocks
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0; // No token threshold (submission is role-gated)
    }

    // === Custom Proposal Control ===
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override returns (uint256) {
        require(proposalWhitelist[msg.sender], "Not allowed to propose");
        uint256 proposalId = super.propose(targets, values, calldatas, description);
        voteStartTime[proposalId] = block.number;
        return proposalId;
    }

    // === Vote Casting with Reward Logic ===
    function castVote(uint256 proposalId, uint8 support) public override returns (uint256) {
        require(ngtToken.isResident(msg.sender), "Only residents can vote");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        // Reward logic: earlier votes earn more
        uint256 elapsed = block.number - voteStartTime[proposalId];
        uint256 maxReward = 1 ether; // 1 NRT (scaled by 1e18)
        uint256 reward = (elapsed >= votingPeriod())
            ? 0
            : ((votingPeriod() - elapsed) * maxReward) / votingPeriod();

        nrtToken.mintReward(msg.sender, reward);

        return super.castVote(proposalId, support);
    }

    // === Required Overrides ===
    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function proposalNeedsQueuing(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
    }

    function _queueOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint48)
    {
        return super._queueOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _executeOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override(Governor, GovernorTimelockControl) returns (address) {
        return super._executor();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // === Admin ===
    function addToWhitelist(address proposer) external onlyGovernance {
        proposalWhitelist[proposer] = true;
    }

    function removeFromWhitelist(address proposer) external onlyGovernance {
        proposalWhitelist[proposer] = false;
    }
}

