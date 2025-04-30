# Design.md

## I. Introduction

Neighbours-DAO is an on-chain governance system designed to significantly increase community involvement in urban decision-making. The project was inspired by the realization that in both large and small cities, only a small fraction of residents actively engage in local governance, urban design, or fund allocation processes. Our objective is to create a transparent platform that incentivizes participation through token-based rewards and provides clarity on how public funds are used. To achieve this, the DAO uses extended ERC-20 tokens for both governance (NGT) and community rewards (NRT), leveraging the security and transparency of blockchain.

---

## II. Technical Specifications

### A. Overview of Contracts and Interactions

Neighbours-DAO is built on five main smart contracts that interact to manage governance, reward systems, and proposal flow:

- **NGT (NeighborGovToken)**: A custom ERC20Votes token designed for governance, implementing checkpointing and non-transferability (except to the registrar). It enforces a one-time delegation policy and features a built-in `rageQuit()` function for token burning. An optimized `_delegate()` function uses Yul (assembly) for gas efficiency.

- **NRT (NeighborRewardToken)**: A capped ERC-20 utility token for community rewards. Merchants can burn NRT for refunds. It has an annual mint cap enforced using `block.timestamp`.

- **NeighborGovernor**: Central contract managing the proposal lifecycle. It handles voting and execution using conviction voting. It also integrates time-based locking and post-vote queuing.

- **RepresentativeCouncil**: A multi-signature wallet for proposal submission. Depending on the proposal's impact, either 2 (minor) or 4 (major) of 5 members must sign. Proposals are routed to the Governor after approval.

- **StreakDistributor**: Manages reward distribution using dynamic incentives tied to participation streaks and voting timing. Rewards decrease as more people vote, rewarding early participation.

These contracts together facilitate an end-to-end decentralized governance flow, ensuring accountability and inclusive decision-making.

![Users (Residents and Representatives)](https://github.com/user-attachments/assets/ca0144b1-4d99-4ab9-952c-4ff806f29686)

---

### B. Chosen Token Standards

- **NGT**: A custom, checkpointed ERC20Votes token with several key restrictions:
  - Non-transferable except to a designated registrar (to allow KYC or similar processes).
  - Allows delegation only once per token holder.
  - Contains a rage quit function to burn delegated tokens and reset voting status.
  - Includes assembly code in `_delegate()` for optimized gas usage.
  - Capped total supply to prevent centralization.

- **NRT**: A capped ERC-20 reward token:
  - Minting is restricted annually using `block.timestamp`.
  - Only whitelisted merchants can burn tokens.
  - Used for public services, discounts, and rewards.

---

### C. Chosen Governance Process Model

#### Proposal Lifecycle
1. Proposals are created by official representatives via the RepresentativeCouncil.
2. Minor proposals require 2-of-5 multisig approval; major ones require 4-of-5.
3. Approved proposals are routed to NeighborGovernor and locked before voting begins.
4. Voting is carried out on-chain using **conviction voting**:
   - Voting power grows with both token stake and the time tokens are held.
   - Formula: `conviction += stake * time^2`.
5. After a successful vote, proposals are queued and executed.

#### Voting Rules
- Only NGT holders can vote.
- Voters can delegate their tokens only once.
- Rage quit resets their voting state.
- Early participation is incentivized with higher NRT rewards.

This mechanism ensures both long-term engagement and fair participation without enabling vote hoarding or late-stage manipulation.

---

### D. Testing Strategy

Testing is consolidated in `neighborContractsTest.T.sol` and includes:

- **Unit Tests**:
  - For NGT: minting logic, one-time delegation, transfer blocking.
  - For NRT: merchant burn rights, mint cap enforcement.
  - For StreakDistributor: role access and reward point handling.

- **Integration Tests**:
  - Delegation and voting across NGT and NeighborGovernor.
  - Reward issuance flow from voting to claim via StreakDistributor.

- **Fuzz Tests**:
  - Conviction voting logic and rageQuit invariants.
  - Annual cap logic in NRT.

All tests were written and executed using the **Forge** testing suite from the Foundry toolchain.

---

## III. Reflection

### A. Motivation for Token and Governance Model

The core motivation behind Neighbours-DAO was to create a governance framework that meaningfully reflects the needs of real communities. Traditional urban decision-making processes often lack transparency and exclude the broader population. By decentralizing governance and introducing financial incentives, we hoped to address voter apathy and foster civic engagement.

We chose the ERC-20 standard due to its strong compatibility with the Ethereum ecosystem and its adaptability for governance. The **NGT** token, modeled after `ERC20Votes`, supports delegation, vote weighting, and historical balance tracking — all critical for building trust in an on-chain voting system. We enhanced this model with restrictions like non-transferability and one-time delegation to prevent vote buying or farming, which are common challenges in decentralized governance.

The **NRT** reward token was designed to bridge the digital and real-world economies. By allowing NRT to be redeemed at local businesses or for public services, we connected blockchain participation to tangible benefits. This design ensures that civic participation is not only ideological but also economically motivating.

The conviction voting model was selected to emphasize long-term commitment over short-term speculation. It rewards voters who engage early and remain involved, aligning perfectly with our aim to build consistent community engagement rather than flash mobilization.

---

### B. Technical Difficulties Encountered

The technical architecture of the DAO involved multiple interacting contracts and complex state dependencies. Here are the key challenges we faced:

#### 1. **Conviction Voting Logic**
Implementing time-weighted voting was one of the most complex aspects. We had to:
- Design a custom `conviction` algorithm that accumulates voting power over time.
- Ensure that the time component (`time^2`) didn't overflow or produce gas-intensive operations.
- Test how it scaled across edge cases using fuzz testing.

#### 2. **Token Restrictions and Delegation**
- Standard delegation logic from `ERC20Votes` had to be rewritten to support a “one-time delegation only” policy.
- We added logic to enforce non-transferability while preserving governance functionality, allowing only KYC-verifiable transfers to a registrar.
- Implementing the `rageQuit()` mechanism required ensuring that all delegations and state-dependent votes were accurately rolled back and burned.

#### 3. **Inter-contract Dependency and Merge Conflicts**
- As contracts were designed and tested in parallel, managing access control and ensuring that function interfaces remained consistent led to frequent conflicts.
- Cross-contract calls (e.g., reward claims post-voting) introduced dependencies that made integration and sequencing more difficult.

#### 4. **Auditing and Safety**
- Static analysis (e.g., Slither) revealed edge-case vulnerabilities such as unchecked external calls and uninitialized states.
- Dynamic testing (e.g., Forge + manual test scenarios) exposed gas spikes and reentrancy patterns that had to be patched.

---

### C. Team Organisation

The DAO was developed collaboratively across three main teams: smart contracts, documentation, and DevOps. Each team operated semi-independently, but coordination was essential for aligning interfaces, timelines, and test coverage.

#### Git and Workflow Strategy
- We maintained five branches: `documentation`, `contracts`, `tests`, `dev`, and `main`.
- Each contributor worked on a fork and submitted pull requests to the relevant feature branch.
- The DevOps team reviewed and tested changes on `dev` before merging them into `main`.

This structure avoided last-minute code breaks and allowed for parallel development without excessive merge conflicts.

#### Communication and Planning
- We used Discord for day-to-day communication and weekly syncs for sprint planning.
- A shared Kanban board on GitHub Projects helped us track tasks, blockers, and releases.
- Code review and CI testing were mandatory before merging, reducing regressions.

#### Key Takeaways
- **Early definition of interfaces** (between Governor, Distributor, and Token contracts) was crucial to modular development.
- **Minimal but frequent commits** helped us catch bugs early and reduce conflicts.
- **Time buffers** before integration and deployment allowed us to run audits and fix edge cases without rushing.
- **Shared responsibility** on testing improved cross-team awareness of system behavior.

---

### D. Lessons Learned

- **On-chain governance is hard**: Even seemingly simple features like voting delegation or reward splitting required deep thought and extensive testing.
- **Security and simplicity often conflict**: Adding safeguards (like rage quit and KYC-controlled transfers) adds complexity, and balancing both is a constant challenge.
- **Community design matters**: Technical tools are only half the solution — designing incentives that feel fair, inclusive, and engaging is just as important.
- **DevOps discipline pays off**: Strict branch management, automated testing, and version control reviews significantly improved our delivery process.

This project taught us how to bridge smart contract development with social systems and showed us the true power — and complexity — of decentralizing governance in real communities.

