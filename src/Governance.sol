// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// --- OpenZeppelin Governance Imports ---
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

// --- Custom Neighbor Tokens ---
import "./NeighborGovernanceToken.sol"; // NGT (Voting Token)
import "./NeighborRewardToken.sol";     // NRT (Reward Token)

/// @title NeighborDAO Governance Contract
/// @notice Fully on-chain DAO with early-vote rewards and proposal whitelisting
contract NeighborDAO is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    // --- State Variables ---

    NeighborGovernanceToken public ngtToken; // Voting token contract
    NeighborRewardToken public nrtToken;     // Reward token contract

    mapping(address => bool) public proposalWhitelist; // Addresses allowed to propose
    mapping(uint256 => uint256) public proposalStartBlock; // Track when voting starts (block number)
    mapping(uint256 => mapping(address => bool)) public hasVoted; // Track if address has voted

    // --- Constructor ---

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

        // Initialize whitelisted proposers
        for (uint256 i = 0; i < initialWhitelistedProposers.length; i++) {
            proposalWhitelist[initialWhitelistedProposers[i]] = true;
        }
    }

    // --- Governance Configuration ---

    function votingDelay() public pure override returns (uint256) {
        return 7200; // ~1 day
    }

    function votingPeriod() public pure override returns (uint256) {
        return 50400; // ~1 week
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0; // Whitelist controls proposal access
    }

    // --- Proposal Creation ---

    /// @notice Create a new proposal (whitelisted addresses only)
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override returns (uint256) {
        require(proposalWhitelist[msg.sender], "Not authorized to propose");

        uint256 proposalId = super.propose(targets, values, calldatas, description);
        proposalStartBlock[proposalId] = getBlockNumber(); // Store block number using assembly

        return proposalId;
    }

    // --- Voting with Early Rewards ---

    /// @notice Vote and receive early participation rewards
    function castVote(uint256 proposalId, uint8 support) public override returns (uint256) {
        require(ngtToken.isResident(msg.sender), "Only residents can vote");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        uint256 blocksSinceStart = getBlockNumber() - proposalStartBlock[proposalId];
        uint256 maxReward = 1 ether; // Max 1 NRT token
        uint256 reward = (blocksSinceStart >= votingPeriod())
            ? 0
            : ((votingPeriod() - blocksSinceStart) * maxReward) / votingPeriod();

        if (reward > 0) {
            nrtToken.mintReward(msg.sender, reward);
        }

        return super.castVote(proposalId, support);
    }

    // --- Whitelist Management (Only DAO can call) ---

    /// @notice Add a new proposer
    function addProposer(address proposer) external onlyGovernance {
        proposalWhitelist[proposer] = true;
    }

    /// @notice Remove a proposer
    function removeProposer(address proposer) external onlyGovernance {
        proposalWhitelist[proposer] = false;
    }

    // --- Helpers ---

    /// @notice Check if a voter already voted on a proposal
    function hasVoterVoted(uint256 proposalId, address voter) external view returns (bool) {
        return hasVoted[proposalId][voter];
    }

    /// @notice Get current block number using Yul assembly (for bonus points)
    function getBlockNumber() internal view returns (uint256 blockNumber) {
        assembly {
            blockNumber := number()
        }
    }

    // --- Required Overrides for Governor Timelock ---

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
