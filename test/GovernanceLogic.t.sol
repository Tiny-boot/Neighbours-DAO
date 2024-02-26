// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {VoteToken} from "../src/VotingToken.sol";
import {GovernanceLogic} from "../src/GovernanceLogic.sol";

contract GovernanceTest is Test {
	VoteToken private vote;
	GovernanceLogic private governance;

    function setUp() public {
		vote = new VoteToken();
		governance = new GovernanceLogic(vote);

		//mint tokens to 3 addresses
		// Address 1 - 2000
		// Address 2 - 3000
		// Address 3 - 5000
		// Total token supply is 10,000 which implies quorum will be reached at 2500 votes. A prank must be used because the delegate function only works with msg.sender
		vm.prank(address(1));
		vote.mintAndDelegate(address(1), 2000);
		vm.prank(address(2));
		vote.mintAndDelegate(address(2), 3000);
		vm.prank(address(3));
		vote.mintAndDelegate(address(3), 5000);
    }

	function test_ProposalCreation() public {
		// Sanity check on the total supply
		assertEq(vote.totalSupply(), 10000);

		// Construct the dynamic arrays
		address[] memory target = new address[](1);
		uint[] memory value = new uint[](1);
		bytes[] memory calldatas = new bytes[](1);

		target[0] = address(vote);
		value[0] = 0;
		calldatas[0] = abi.encodeWithSignature("mintAndDelegate(address,uint)", address(5), 100);
		string memory description = "Proposal #1: Mint Address 5 one hundred more tokens";

		governance.propose(
			target,
			value,
			calldatas,
			description
		);

		// calculate the prposal ID through its hash
		uint proposalID = governance.hashProposal(target, value, calldatas, keccak256(bytes(description)));

		// Assert that after the creation of the proposal, the snapshot of when it begins is the time of creation + voting delay
		assertEq(governance.proposalSnapshot(proposalID), vote.clock()+governance.votingDelay());
	}

	function test_CastVote() public {
		// Construct the dynamic arrays
		address[] memory target = new address[](1);
		uint[] memory value = new uint[](1);
		bytes[] memory calldatas = new bytes[](1);

		target[0] = address(vote);
		value[0] = 0;
		calldatas[0] = abi.encodeWithSignature("mintAndDelegate(address,uint)", address(5), 100);
		string memory description = "Proposal #1: Mint Address 5 one hundred more tokens";

		governance.propose(
			target,
			value,
			calldatas,
			description
		);

		// calculate the prposal ID through its hash
		uint proposalID = governance.hashProposal(target, value, calldatas, keccak256(bytes(description)));


		// Address 1 casts a vote for the proposal.
		// Expecting to fail because a delay of 1 day has not passed yet
		vm.expectRevert();
		vm.prank(address(1));
		governance.castVote(proposalID, 1);

		// Mine 7200 + 1 new blocks to skip voting delay and then vote
		vm.roll(vote.clock() + governance.votingDelay()+1);

		(uint againstVotes, uint forVotes, uint abstainVotes) = governance.proposalVotes(proposalID);
		console2.log("against: %s, for: %s, abstain: %s", againstVotes, forVotes, abstainVotes);
		
		vm.startPrank(address(1));
		governance.castVote(proposalID, 1);
		assertEq(governance.hasVoted(proposalID, address(1)), true);

		(againstVotes, forVotes, abstainVotes) = governance.proposalVotes(proposalID);
		console2.log("against: %s, for: %s, abstain: %s", againstVotes, forVotes, abstainVotes);	
		assertEq(governance.quorumReached(proposalID), false);	
	}

	function test_ExecuteOnchain() public {
		// Construct the dynamic arrays
		address[] memory target = new address[](1);
		uint[] memory value = new uint[](1);
		bytes[] memory calldatas = new bytes[](1);

		target[0] = address(vote);
		value[0] = 0;
		calldatas[0] = abi.encodeWithSignature("mint(address,uint256)", address(5), 100);
		string memory description = "Proposal #1: Mint Address 5 one hundred more tokens";

		governance.propose(
			target,
			value,
			calldatas,
			description
		);

		// calculate the prposal ID through its hash
		uint proposalID = governance.hashProposal(target, value, calldatas, keccak256(bytes(description)));

		// Mine 7200 + 1 new blocks to skip voting delay and then vote
		vm.roll(vote.clock() + governance.votingDelay()+1);
		vm.prank(address(1));
		governance.castVote(proposalID, 1);
		assertEq(governance.hasVoted(proposalID, address(1)), true);
		
		// Reach quorum wih another vote
		vm.prank(address(3));
		governance.castVote(proposalID, 1);

		// Assert that quorum has been reached
		assertEq(governance.quorumReached(proposalID), true);

		// Fast forward to end of voting period
		vm.roll(vote.clock() + governance.votingPeriod() + 1);

		//Execute and check execution result
		governance.execute(
			target,
			value,
			calldatas,
			keccak256(bytes(description))
		);
		
		assertEq(vote.balanceOf(address(5)), 100);
	}
}