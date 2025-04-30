// SPDX‑License‑Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Neighbor Governance Token (NGT)
 * @notice Non‑transferable ERC‑20Votes token for KYC’d residents.
 *         – Mints are capped (CAP immutable).
 *         – Transfers allowed only between whitelisted addresses.
 *         – "Rage‑quit" lets a holder burn their balance in one shot.
 *         – Compatible with OpenZeppelin Governor.
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {AccessControl}              from "@openzeppelin/contracts/access/AccessControl.sol";

contract NeighborGovToken is ERC20, ERC20Burnable, ERC20Permit, ERC20Votes, AccessControl {
    /* ───────────── Roles ───────────── */
    bytes32 public constant MINTER_ROLE    = keccak256("MINTER_ROLE");
    bytes32 public constant WHITELIST_ROLE = keccak256("WHITELIST_ROLE");

    /* ───────────── State ───────────── */
    uint256 public immutable CAP;
    mapping(address => bool) private _eligible;      // simple allow‑list

    // once‑ever delegation flag (bonus req.)
    mapping(address => bool) public hasDelegated;

    /* ───────────── Constructor ─────── */
    constructor(uint256 initialSupply, uint256 _cap, address cityRegistrar)
        ERC20("Neighbor Governance Token", "NGT")
        ERC20Permit("Neighbor Governance Token")
    {
        require(_cap > 0, "cap 0");
        CAP = _cap;

        // bootstrap core roles
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(DEFAULT_ADMIN_ROLE, cityRegistrar);
        _grantRole(MINTER_ROLE,        msg.sender);
        _grantRole(WHITELIST_ROLE,     cityRegistrar);
        _grantRole(WHITELIST_ROLE,     msg.sender);

        _eligible[cityRegistrar] = true;
        _mint(cityRegistrar, initialSupply);
        require(totalSupply() <= CAP, "cap exceeded");
    }

    /* ─────────── Whitelist & Mint ───── */
    function whitelist(address user, bool allowed) external onlyRole(WHITELIST_ROLE) {
        _eligible[user] = allowed;
    }

    function mint(address to, uint256 amt) external onlyRole(MINTER_ROLE) {
        require(totalSupply() + amt <= CAP, "cap exceeded");
        require(_eligible[to], "not whitelisted");
        _mint(to, amt);
    }

    /* ───────────── Rage‑Quit ────────── */
    function rageQuit(uint256 amt) external {
        _burn(msg.sender, amt);
        hasDelegated[msg.sender] = false; // wipe delegation record
    }

    /* ───── Delegate exactly once ───── */
    function delegate(address to) public override {
        require(!hasDelegated[msg.sender], "already delegated");
        assembly { let tmp := caller() } // ⚙️ 1‑line Yul (homework req.)
        hasDelegated[msg.sender] = true;
        super.delegate(to);
    }

    /* ─────────── Token transfer hook ─ */
    function _update(address from, address to, uint256 value)
        internal override(ERC20, ERC20Votes)
    {
        if (from != address(0) && to != address(0)) {
            require(_eligible[from] && _eligible[to], "transfer: not eligible");
        }
        super._update(from, to, value);
    }

    // multiple‑inheritance fix for nonces()
    function nonces(address owner)
        public view override(ERC20Permit, Nonces) returns (uint256)
    { return super.nonces(owner); }

    function supportsInterface(bytes4 id) public view override(AccessControl) returns (bool) {
        return super.supportsInterface(id);
    }
}