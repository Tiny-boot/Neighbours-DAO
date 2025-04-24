// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin Governance
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

// Custom Tokens
import "./NeighborGovernanceToken.sol"; // NGT (Voting Token)
import "./NeighborRewardToken.sol";     // NRT (Reward Token)

contract NeighborDAO is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    NeighborGovernanceToken public ngtToken; // Voting token (residency check)
    NeighborRewardToken public nrtToken;     // Reward token

    // Proposal access control
    mapping(address => bool) public proposalWhitelist;

    // Track voting start time for reward calculation
    mapping(uint256 => uint256) public proposalStartBlock;

    // Track whether a voter has voted on a specific proposal
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    constructor(
        NeighborGovernanceToken _ngtToken,
        NeighborRewardToken _nrtToken,
        TimelockController _timelock,
        address[] memory initialWhitelistedProposers
    )
        Governor("NeighborDAO")
        GovernorVotes(_ngtToken)
        GovernorVotesQuorumFraction(4) // 4% quorum
        GovernorTimelockControl(_timelock)
    {
        ngtToken = _ngtToken;
        nrtToken = _nrtToken;

        // Add initial proposers to whitelist
        for (uint256 i = 0; i < initialWhitelistedProposers.length; i++) {
            proposalWhitelist[initialWhitelistedProposers[i]] = true;
        }
    }

    // --- Governance Configuration ---

    function votingDelay() public pure override returns (uint256) {
        return 7200; // ~1 day in blocks
    }

    function votingPeriod() public pure override returns (uint256) {
        return 50400; // ~1 week in blocks
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0; // Proposal control is based on whitelist
    }

    // --- Proposal Submission ---

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override returns (uint256) {
        require(proposalWhitelist[msg.sender], "Not authorized to propose");

        uint256 proposalId = super.propose(targets, values, calldatas, description);
        proposalStartBlock[proposalId] = block.number;

        return proposalId;
    }

    // --- Vote Casting with Rewarding ---

    function castVote(uint256 proposalId, uint8 support) public override returns (uint256) {
        require(ngtToken.isResident(msg.sender), "Only residents can vote");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        // Reward logic based on early voting
        uint256 blocksSinceStart = block.number - proposalStartBlock[proposalId];
        uint256 maxReward = 1 ether; // Max 1 NRT
        uint256 reward = (blocksSinceStart >= votingPeriod())
            ? 0
            : ((votingPeriod() - blocksSinceStart) * maxReward) / votingPeriod();

        nrtToken.mintReward(msg.sender, reward);

        return super.castVote(proposalId, support);
    }

    // --- Proposal Outcome ---

    function hasVoterVoted(uint256 proposalId, address voter) external view returns (bool) {
        return hasVoted[proposalId][voter];
    }

    // --- Whitelist Admin ---

    function addProposer(address proposer) external onlyGovernance {
        proposalWhitelist[proposer] = true;
    }

    function removeProposer(address proposer) external onlyGovernance {
        proposalWhitelist[proposer] = false;
    }

    // --- Required Overrides ---

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
    )
        internal
        override(Governor, GovernorTimelockControl)
    {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
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
}
