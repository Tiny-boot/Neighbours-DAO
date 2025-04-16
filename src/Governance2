// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Governor, IGovernor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {GovernorTimelockControl} from "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

import "./ResidentRegistry.sol";
import "./RewardToken.sol";

contract CityGovernor is
    Governor,
    GovernorCountingSimple,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    ResidentRegistry public registry;
    RewardToken public rewardToken;

    mapping(uint256 => uint256) public totalVotesOnProposal;

    constructor(
        IVotes _token,
        TimelockController _timelock,
        ResidentRegistry _registry,
        RewardToken _rewardToken
    )
        Governor("CityGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(_timelock)
    {
        registry = _registry;
        rewardToken = _rewardToken;
    }

    function votingDelay() public pure override returns (uint256) {
        return 7200; // ~1 day (in blocks)
    }

    function votingPeriod() public pure override returns (uint256) {
        return 50400; // ~1 week (in blocks)
    }

    function proposalThreshold() public pure override returns (uint256) {
        return 0; // open to all (multi-sig handles submission)
    }

    function castVote(uint256 proposalId, uint8 support) public override returns (uint256) {
        require(registry.isResident(msg.sender), "Only registered residents can vote");

        uint256 voteCount = totalVotesOnProposal[proposalId];
        uint256 reward = 1000 / (1 + voteCount); // diminishing reward
        rewardToken.mintReward(msg.sender, reward * 1e18);

        totalVotesOnProposal[proposalId]++;
        return super.castVote(proposalId, support);
    }

    // Required overrides
    function state(uint256 proposalId) public view override(Governor, GovernorTimelockControl) returns (ProposalState) {
        return super.state(proposalId);
    }

    function proposalNeedsQueuing(
        uint256 proposalId
    ) public view override(Governor, GovernorTimelockControl) returns (bool) {
        return super.proposalNeedsQueuing(proposalId);
    }

    function _queueOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint48) {
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
}
