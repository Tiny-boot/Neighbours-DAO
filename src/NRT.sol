// SPDX‑License‑Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Neighbor Reward Token (NRT)
 * @notice Year‑budget‑capped coupon token minted by the city treasury and
 *         burned by merchants on redemption.
 */

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {AccessControl}        from "@openzeppelin/contracts/access/AccessControl.sol";

contract NeighborRewardToken is ERC20Burnable, AccessControl {
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
    bytes32 public constant MERCHANT_ROLE = keccak256("MERCHANT_ROLE");

    uint256 public immutable CAP;     // annual cap
    uint256 public mintedThisYear;
    uint256 public yearStart;

    constructor(uint256 annualCap, address treasury)
        ERC20("Neighbor Reward Token", "NRT")
    {
        CAP       = annualCap;
        yearStart = _startOfYear(block.timestamp);

        _grantRole(DEFAULT_ADMIN_ROLE, treasury);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(TREASURY_ROLE,      treasury);
        _grantRole(TREASURY_ROLE,      msg.sender);
    }

    /* ───────────── Mint under annual budget ─────── */
    function mint(address to, uint256 amt) external onlyRole(TREASURY_ROLE) {
        _rollYear();
        require(mintedThisYear + amt <= CAP, "annual cap exceeded");
        mintedThisYear += amt;
        _mint(to, amt);
    }

    /* ───────────── Merchant burn w/ memo ───────── */
    event Redeemed(address indexed merchant, uint256 amt, string memo);

    function merchantBurn(uint256 amt, string calldata memo) external onlyRole(MERCHANT_ROLE) {
        _burn(msg.sender, amt);
        emit Redeemed(msg.sender, amt, memo);
    }

    /* ───────────── Year rollover helpers ───────── */
    function _rollYear() internal {
        if (block.timestamp >= yearStart + 365 days) {
            uint256 yearsPassed = (block.timestamp - yearStart) / 365 days;
            yearStart          += yearsPassed * 365 days;
            mintedThisYear      = 0;
        }
    }

    function _startOfYear(uint256 ts) private pure returns (uint256) {
        return ts - (ts % 365 days);
    }
}