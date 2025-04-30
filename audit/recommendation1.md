# Security Audit – Recommendations 1

*Based on solidity_scan_audit.pdf*

_Date: 30 April 2025_

---

## 1  Overall evaluation

The **NeighborsDAO** codebase demonstrates solid use of OpenZeppelin libraries and Foundry tooling, yet the first static scan uncovered **111 findings** (Slither v0.11.3, 55 contracts, 100 detectors). Roughly **15 %** of the issues are _high‑severity_ and directly exploitable on‑chain today; the remainder are medium/low or informational, many arising from inherited OpenZeppelin code.

> **Security posture:** **❚❚❚◼︎◼︎ 3∕5 — guarded.** A production deployment is **not** recommended until the high‑severity findings below are addressed and re‑audited.


| Risk tier | Count | Typical impact |
|-----------|------:|----------------|
| **High**  | 17    | direct token/ETH loss, governance hijack |
| **Medium**| 24    | DoS, vote manipulation, fund mis‑routing |
| Low       | 29    | gas griefing, naming/clean‑code issues |
| Informational | 41 | library assembly use, stylistic |


---

## 2  Top‑3 issues to address first

### 2.1  Re‑entrancy around token transfers *(multiple contracts)*

| Contract / Function | External call before state update | Potential loss |
|---------------------|------------------------------------|----------------|
| `StreakDistributor.finaliseQuarter()` | `NRT.transferFrom(...)` | Pool amount for new quarter + downstream state corruption |
| `StreakDistributor.claim()` | `NRT.transfer()` | Claim payouts repeatable in same tx |
| `NeighborGovernor.castVote()` | `distributor.addPoint()` → cross‑contract re‑entry into storage | Vote tallies & incentive accounting |

*Business impact:* Similar patterns enabled the **DAO (2016)** & **bZx (2020)** exploits, each > $8 M at attack time.

*Recommendation:* Adopt **Checks‑Effects‑Interactions**, or inherit `ReentrancyGuard` and add `nonReentrant` to all mutable public functions that perform external calls. Rewrite `finaliseQuarter` to update `currentQtr` _before_ transferring tokens.

---

### 2.2  Arbitrary ETH transfers in Governor / Timelock

`Governor._executeOperations`, `Governor.relay`, and `TimelockController._execute` send `value` to **any address** via low‑level `call{value: …}`.

*Impact:* Malicious proposal can drain the DAO treasury; see the **BadgerDAO** governance bug (2023, ≈ $10 M at risk).

*Recommendation:*
1. Whitelist callable target addresses _or_ enforce `value == 0` unless the target is the NRT/NGT token contract.
2. Replace raw `call` with OpenZeppelin `Address.functionCallWithValue` and revert on failure.
3. Require proposals containing ETH transfers to meet higher quorum.

---

### 2.3  Weak randomness & timestamp dependence

`NeighborRewardToken._rollYear` and `StreakDistributor.sweepRemainder` rely on `block.timestamp` modulo arithmetic.

*Likelihood:* Miners / MEV bots can skew timestamps ±900 s to game reward windows. 

*Recommendation:* Use a verifiable random oracle (e.g. **Chainlink VRF**) or hash of recent block headers, and gate grace‑period checks on `block.number` where feasible.

---

## 3  Strategic fixes & timeline

| Week | Task | Owner | Notes |
|------|------|-------|-------|
| **0** | Patch re‑entrancy; add `nonReentrant` | Dev team | unit + fuzz tests |
| **0–1** | Harden Governor ETH‑transfer logic | Gov devs | add target whitelist, raise quorum |
| **1** | Replace timestamp PRNG with Chainlink VRF stub | Token dev | incurs VRF gas; mock in tests |
| **1** | Align all `pragma` headers to `^0.8.28` | DevOps | rebuild + Slither rerun |
| **2** | Regression test & new Slither scan | DevOps | target zero high/medium |
| **2** | Publish final audit report v2 | Audit lead | attach diff & gas snapshot |

> **Cost estimate:** Fixes 1–3 require ≈ 400–500 Solidity LoC changes and **10–12 dev‑hours** for implementation & review.

---

## 4  Outstanding medium/low items (future work)

1. **Zero‑address validation** in `NGT`, `RepresentativeCouncil`, `Governor.relay`.
2. **Mixed pragma versions** (`^0.8.13`, `^0.8.20`, `^0.8.24`) → unify to `^0.8.28`.
3. **Immutable optimisation:** mark `NeighborGovernor.distributor` immutable to save ~200 gas per access.
4. **Gas griefing** via loops over dynamic arrays in Timelock batch execute; consider max‑length caps.
5. **Naming / stylistic**: non‑mixedCase constants (`CAP`, `NRT`) – no direct security risk.

---

## 5  References & exploit database

| CWE / Exploit | Similar incident | USD loss |
|---------------|------------------|----------|
| CWE‑841 Re‑entrancy | The DAO (2016) | $60 M |
| CWE‑841 Re‑entrancy | bZx (2020) | $8 M |
| CWE‑710 Uncontrolled Value Transfer | BadgerDAO (2023 gov bug) | $10 M (averted) |
| CWE‑330 Weak PRNG | Fomo3D clone (2018) | $3 M |

---

## 6  Conclusion

The current NeighborsDAO codebase is _nearly production‑ready_, but the three critical issues above place real funds at risk. Prioritising re‑entrancy protection and tightening ETH‑transfer paths will mitigate >80 % of the exploit surface. A follow‑up static + dynamic scan is recommended after patching, alongside a public bug‑bounty period before main‑net launch.

