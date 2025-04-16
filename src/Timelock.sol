// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/governance/TimelockController.sol";

contract TimelockFactory {
    function deployTimelock(
        address[] memory proposers,
        address[] memory executors
    ) external returns (TimelockController) {
        return new TimelockController(
            1 days, // delay
            proposers,
            executors,
            msg.sender // admin
        );
    }
}
