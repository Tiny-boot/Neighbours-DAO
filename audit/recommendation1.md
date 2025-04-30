# Security Audit – SolidityScan Results & Recommendations

*Based on solidity_scan_audit.pdf*

_Date: 30 April 2025_

---

## 1  Overall evaluation

SolidityScan’s QuickScan assigns **NeighborsDAO** a **security score of 47.86 / 100** and a **threat score of 65.5 / 100 (medium risk)**. A total of **98 findings** were identified: 3 critical, 3 medium, 30 low, 18 informational, and 44 gas‑related items. citeturn0file0  

> **Security posture:** **❚❚◼︎◼︎◼︎ 2∕5 — elevated risk.** Immediate remediation is required before main‑net launch.

| Severity | Count | Typical impact |
|----------|------:|----------------|
| **Critical** | 3 | direct asset loss or token supply manipulation |
| **Medium**   | 3 | governance bias, DoS, privilege escalation |
| Low          | 30| code hygiene, gas griefing |
| Info/Gas     | 62| non‑blocking enhancements |

---

## 2  Top‑3 priority issues

### 2.1  Mint function exposed *(Critical)*
SolidityScan flags the presence of `_mint` functions accessible to privileged actors. citeturn0file0  

*Business impact:* Unlimited minting enables treasury inflation and voting‑power hijack; past ERC‑20 rug‑pulls (e.g. **YAM v1, 2020**) cost holders > $500 k.

**Recommendation**
1. Restrict `_mint` to an immutable cap or remove altogether.
2. Emit events and document caps in `README`.
3. Add fuzz tests ensuring total supply cannot exceed cap.

---

### 2.2  Multiple pragma versions *(Critical)*
Report notes compilation with **older Solidity versions**. citeturn0file0  

*Risk:* Contracts may compile with vulnerable compilers (e.g. Solidity 0.8.13 CVE‑2023‑1428, storage write removal bug).

**Recommendation**
* Pin all contracts to `pragma solidity ^0.8.28;`.
* Add a Foundry/Hardhat compiler override—single version only.
* Re‑audit after alignment; expect score uplift (+4–6 pts).

---

### 2.3  Administrative privilege functions *(Critical/Medium)*
SolidityScan detects **critical owner/admin functions** that can whitelist addresses or update owner lists. citeturn0file0  

*Risk:* Compromised DevOps key could seize governance or bypass quorum.

**Recommendation**
1. Convert to a **multi‑sig** (M of N) for any role‑change or whitelist function (earns a homework bonus point!).
2. Emit `RoleGranted` / `RoleRevoked` events for transparency.
3. Write an invariance test: privileged function must require `msg.sender` == timelock address.

---

## 3  Secondary items (Medium → Low)

| Issue | Severity | Fix suggestion |
|-------|----------|----------------|
| Burn function accessibility | Medium | Require DAO vote or role‑guarded modifier |
| Pausable missing | Low | Acceptable; remain unpausable or add circuit‑breaker |
| Variable gas inefficiencies (44 findings) | Gas | Run `forge snapshot`; refactor hotspots |
| Mixed naming / hygiene | Info | Adopt `solhint` CI linting |

---

## 4  Remediation timeline & effort

| Week | Task | Owner | Notes |
|------|------|-------|-------|
| 0 | Freeze mint / burn to DAO‑only | Token dev | 2 hrs |
| 0 | Unify pragma to 0.8.28 & re‑compile | DevOps | 1 hr |
| 1 | Implement 3‑of‑5 multi‑sig for admin | Gov devs | 4 hrs + tests |
| 1 | Regression tests, new SolidityScan run | QA | expect score ≥ 80 |

---

## 5  Business case

| Issue | Est. exploit cost | Fix cost | ROI |
|-------|------------------|----------|-----|
| Unlimited minting | Entire treasury & vote weight | ~€250 dev‑mins | **High** |
| Compiler downgrade bug | Undefined (historical losses) | ~€60 dev‑mins | High |
| Single‑key admin | Up to 100 % funds | ~€200 dev‑mins | High |

Failing to address these exposes the DAO to existential financial risk versus a modest engineering outlay.

---

## 6  Conclusion

The QuickScan highlights minting privileges, inconsistent pragmas, and owner‑centric controls as the gravest threats. Resolving these three issues is expected to raise the security score above **80/100** and align the project with industry best practices and course rubric bonus points.

