// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title NeighborGovernor
 * @notice Quadratic-weighted Governor with Timelock execution and streak
 *         reward integration.
 */
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

import "./StreakDistributor.sol";

contract NeighborGovernor is
    Governor,
    GovernorSettings,
    GovernorVotes,
    GovernorCountingSimple,
    GovernorTimelockControl
{
    StreakDistributor public distributor;

    constructor(ERC20Votes token, TimelockController timelock, StreakDistributor dist)
        Governor("NeighborGovernor")
        GovernorSettings(1 days, 7 days, 0)
        GovernorVotes(token)
        GovernorTimelockControl(timelock)
    {
        distributor = dist;
    }

    /* ── Quadratic weight ── */
    function _getVotes(address voter, uint256 blockNumber, bytes memory)
        internal
        view
        override(Governor, GovernorVotes)
        returns (uint256)
    {
        uint256 raw = super._getVotes(voter, blockNumber, "");
        uint256 z = (raw + 1) / 2;
        uint256 y = raw;
        while (z < y) {
            y = z;
            z = (raw / z + z) / 2;
        }
        return y;
    }

    /* ── Reward hook ── */
    function castVote(uint256 proposalId, uint8 support) public override(Governor) returns (uint256) {
        distributor.addPoint(_msgSender());
        return super.castVote(proposalId, support);
    }

    /* ── Quorum 4% ── */
    function quorum(uint256 blockNumber) public view override(Governor) returns (uint256) {
        return (token().getPastTotalSupply(blockNumber) * 4) / 100;
    }

    function proposalThreshold() public pure override(Governor, GovernorSettings) returns (uint256) {
        return 0;
    }

    /* ── Required overrides ── */
    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
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

    function proposalNeedsQueuing(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
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
}
