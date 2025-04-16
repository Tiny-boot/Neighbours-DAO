// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResidentRegistry {
    address public admin;
    mapping(address => bool) public isResident;

    event ResidentAdded(address resident);
    event ResidentRemoved(address resident);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function addResident(address resident) external onlyAdmin {
        isResident[resident] = true;
        emit ResidentAdded(resident);
    }

    function removeResident(address resident) external onlyAdmin {
        isResident[resident] = false;
        emit ResidentRemoved(resident);
    }

    function verifyResident(address resident) external view returns (bool) {
        return isResident[resident];
    }
}

