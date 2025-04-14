// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CityToken.sol"; // Your reward token contract

contract CityGovernance is AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant MAYOR_ROLE = keccak256("MAYOR");
    bytes32 public constant SYNDICATE_ROLE = keccak256("SYNDICATE");
    bytes32 public constant NEIGHBORHOOD_ROLE = keccak256("NEIGHBORHOOD");
    bytes32 public constant RESIDENT_ROLE = keccak256("RESIDENT");

    enum ProposalLevel { Low, Medium, High }

    struct Proposal {
        string title;
        string summary;
        ProposalLevel level;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 createdAt;
        bool executed;
        uint256 votingEnd;
        uint256 quorum; // required %
    }

    Counters.Counter private _proposalIds;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => uint256) public totalVoters;

    CityToken public rewardToken;
    uint256 public votingDuration = 3 days;

    event ProposalCreated(uint256 id, string title, ProposalLevel level, uint256 quorum);
    event Voted(uint256 proposalId, address voter, bool support);
    event RewardMinted(address voter, uint256 amount);

    constructor(address tokenAddress) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        rewardToken = CityToken(tokenAddress);
    }

    modifier onlyCityAuthority() {
        require(
            hasRole(MAYOR_ROLE, msg.sender) || 
            hasRole(SYNDICATE_ROLE, msg.sender) || 
            hasRole(NEIGHBORHOOD_ROLE, msg.sender),
            "Not authorized to create proposals"
        );
        _;
    }

    function submitProposal(
        string calldata title,
        string calldata summary,
        ProposalLevel level
    ) external onlyCityAuthority {
        _proposalIds.increment();
        uint256 proposalId = _proposalIds.current();

        uint256 quorum = _getQuorumByLevel(level);

        proposals[proposalId] = Proposal({
            title: title,
            summary: summary,
            level: level,
            votesFor: 0,
            votesAgainst: 0,
            createdAt: block.timestamp,
            executed: false,
            votingEnd: block.timestamp + votingDuration,
            quorum: quorum
        });

        emit ProposalCreated(proposalId, title, level, quorum);
    }

    function vote(uint256 proposalId, bool support) external {
        require(hasRole(RESIDENT_ROLE, msg.sender), "Only registered residents can vote");
        Proposal storage prop = proposals[proposalId];
        require(block.timestamp < prop.votingEnd, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;
        totalVoters[proposalId] += 1;

        if (support) {
            prop.votesFor += 1;
        } else {
            prop.votesAgainst += 1;
        }

        emit Voted(proposalId, msg.sender, support);

        _rewardVoter(msg.sender, proposalId);
    }

    function _rewardVoter(address voter, uint256 proposalId) internal {
        Proposal storage prop = proposals[proposalId];
        uint256 elapsedTime = block.timestamp - prop.createdAt;
        uint256 totalDuration = votingDuration;

        // Earlier vote → higher reward
        uint256 reward = (1 ether * (totalDuration - elapsedTime)) / totalDuration;
        rewardToken.mintReward(voter, reward);

        emit RewardMinted(voter, reward);
    }

    function getProposalOutcome(uint256 proposalId) external view returns (bool passed) {
        Proposal storage prop = proposals[proposalId];
        uint256 totalVotes = prop.votesFor + prop.votesAgainst;
        if (totalVotes == 0) return false;
        uint256 approvalRate = (prop.votesFor * 100) / totalVotes;
        return approvalRate >= prop.quorum;
    }

    function _getQuorumByLevel(ProposalLevel level) internal pure returns (uint256) {
        if (level == ProposalLevel.Low) return 50;
        if (level == ProposalLevel.Medium) return 60;
        if (level == ProposalLevel.High) return 75;
        return 50;
    }
}

