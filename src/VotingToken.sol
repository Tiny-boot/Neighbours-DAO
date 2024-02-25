// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract VoteToken is ERC20Permit, ERC20Votes {
    constructor() ERC20("VoteToken", "VOTE") ERC20Permit("VoteToken") {}

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
    internal    
    virtual
    override(ERC20, ERC20Votes)
    {
        super._update(from, to, value);
    }

    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }

    function mint(address to, uint amount) public {
        _mint(to, amount);
    }

    //Create a function which allows anyone to mint the ERC20token 
    //and delegate the entire minted quantity as voting tokens immediately
    //Delegation to self is necessary due to gas saving decisions taken in the ERC20Votes contract
    function mintAndDelegate(address to, uint amount) public {
        _mint(to, amount);
        delegate(to);
    }

    //Unstaking is similar to setting the delegatee field back to zero
    function unstakeVotingUnits() public {
        delegate(address(0));
    }

    function update(address from, address to, uint256 value)
        public
    {
        return _update(from, to, value);
    }
}
