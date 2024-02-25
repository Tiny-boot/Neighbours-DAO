// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {VoteToken} from "../src/VotingToken.sol";

contract TokenTest is Test {
	VoteToken private vote;

    function setUp() public {
		vote = new VoteToken();
    }

	function test_MintAndDelegate() public {
		vm.startPrank(address(1));	
		vote.mintAndDelegate(address(1), 1000);

		// Assert that member has 1000 tokens minted to them
		assertEq(vote.balanceOf(address(1)), 1000);
		// Assert that all 1000 tokens is self delegated and counting towards a vote
		assertEq(vote.getVotes(address(1)), 1000);
	}

	function test_CheckNonce() public {
		vm.startPrank(address(1));
		vote.mintAndDelegate(address(1), 1000);
		
		// Assert that the nonce is 0 as there has been no actions performed by address 1 yet
		assertEq(vote.nonces(msg.sender), 0);
	}

	function test_Delegation() public {
		vm.startPrank(address(1));
		vote.mintAndDelegate(address(1), 1000);

		vote.update(address(1), address(2),500);
		
		//Assert that address 1 and 2 now each have 500 voting tokens
		assertEq(vote.getVotes(address(1)), 500);
		//Address 2 still needs to delegate these tokens to itself to use it as a vote!
		assertEq(vote.getVotes(address(2)), 0);

		// The nonce should still be 0. Why?
		assertEq(vote.nonces(address(1)), 0);
	}

	function test_Unstake() public {
		vm.startPrank(address(1));
		vote.mintAndDelegate(address(1), 1000);
		assertEq(vote.getVotes(address(1)), 1000);

		vote.unstakeVotingUnits();
		assertEq(vote.getVotes(address(1)), 0);
	}

	function testFuzz_MintAndDelegate(uint x) public{
		vm.assume(x<10000000000);
		vm.startPrank(address(1));	
		vote.mintAndDelegate(address(1), x);

		// Assert that member has x tokens minted to them
		assertEq(vote.balanceOf(address(1)), x);
		// Assert that all x tokens is self delegated and counting towards a vote
		assertEq(vote.getVotes(address(1)), x);
	}
}