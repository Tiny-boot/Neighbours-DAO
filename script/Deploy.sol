// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";
import {VoteToken} from "../src/VotingToken.sol";
import {GovernanceLogic} from "../src/GovernanceLogic.sol";

contract DeployScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        VoteToken vote = new VoteToken();  // 0x83DF40B0e7375CEa9261cE226ffaA679B9d33707
        GovernanceLogic governance = new GovernanceLogic(vote);  //0x8E67F57AF638b3Fe2ad5fE55EAb407bF36351bc1

        vm.stopBroadcast();
    }
}