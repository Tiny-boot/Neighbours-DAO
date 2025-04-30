# Design.md

## I. Introduction

The Neighbours-DAO aims to significantly increase community involvement by enabling transparent, decentralized decision-making through blockchain technology. Recognizing that urban planning and local governance often engage only a small fraction of city residents, this DAO fosters active community participation by rewarding voters and providing clear visibility into municipal fund allocation. Through specialized ERC-20 tokens for governance (NGT) and rewards (NRT), residents are encouraged to engage actively and meaningfully in their community.

---

## II. Technical Specifications

### A. Overview of Contracts and Interactions

Neighbours-DAO is built around five core smart contracts that interact cohesively:

- **NGT (NeighborGovToken)**: This is the main governance token, an ERC-20 standard that supports minting, transfer blocking under specific conditions, and voting delegation. It tracks historical balances for vote weighting and supports rage quit functionality.
- **NRT (NeighborRewardToken)**: Also an ERC-20 token, the NRT serves as the reward mechanism. It enforces mint caps, supports burning by merchant roles only, and has a logic to reset caps annually.
- **NeighborGovernor**: This contract orchestrates the proposal lifecycle, vote execution, and coordination of the reward distribution logic.
- **RepresentativeCouncil**: A multi-signature wallet contract that regulates proposal submissions. It enforces a 2-of-5 signature requirement for minor proposals and 4-of-5 for major proposals, ensuring greater consensus for higher-impact decisions.
- **StreakDistributor**: Manages the distribution of NRT tokens based on voter participation streaks and voting promptness. Rewards decrease as more users vote, incentivizing early engagement.

These contracts collectively create a seamless governance and incentivization flow, from proposal submission to reward issuance.

![Users (Residents and Representatives)](https://github.com/user-attachments/assets/ca0144b1-4d99-4ab9-952c-4ff806f29686)

---

### B. Chosen Token Standards

Both tokens in this system—NGT and NRT—follow the ERC-20 standard. This decision was made to benefit from the standard's broad compatibility with wallets, exchanges, and tooling. The ERC-20 standard also provides a familiar structure for implementing voting power tracking and transfer logic, which are critical for governance and reward utility in the DAO.

---

### C. Chosen Governance Process Model

Governance begins with proposals submitted by official city representatives. This includes mayors, neighborhood delegates, or syndicate heads, through a multisig-controlled process. Minor proposals require 2-of-5 signatures, while major ones demand 4-of-5. 

Registered residents, once verified for identity and location, vote on-chain using the NGT token. Voting power is weighted by token holdings and subject to delegation rules. To promote swift and informed participation, rewards are distributed dynamically by the StreakDistributor—early voters earn higher NRT rewards than those who vote later.

---

### D. Testing Strategy

Testing has been consolidated into the `neighborContractsTest.T.sol` file, which includes:

- **Unit Tests** for verifying isolated contract logic such as NGT minting and NRT burning.
- **Integration Tests** for testing cross-contract workflows, e.g., from delegation to reward issuance.
- **Fuzz Tests** for edge-case detection and invariant checking, especially around reward caps and rage quit logic.

All tests were conducted using the Forge testing framework from the Foundry toolchain.

---

## III. Reflection

### A. Motivation for Token and Governance Model

We chose ERC-20 standards for both the governance and reward tokens due to their reliability, modularity, and community support. The delegation and checkpoint features of ERC-20 were key for building the voting model. NRT, as a utility token, adds value to participation by granting access to real-world benefits such as local discounts and services. The multisig submission process ensures that decision-making remains community-rooted but responsibly filtered.

---

### B. Technical Difficulties Encountered

To manage complexity and parallel workstreams, we organized our GitHub repository into five branches: three feature branches (`documentation`, `contracts`, `tests`), a `dev` branch for integration, and the `main` branch for deployment. Contributors worked from forked repositories and merged into their relevant feature branches. The DevOps team oversaw integration and final testing in the `dev` branch before deploying to `main`.

Despite this structure, we encountered merge conflicts and test inconsistencies. These were mitigated through small, regular commits, agreed naming conventions, and test-based integration practices. Coordination between contract interfaces was critical to avoid regressions during integration.

---

### C. Team Organisation

Team roles were assigned based on strengths: contract development, documentation, and DevOps responsibilities were clearly distributed. Communication was facilitated through daily updates and weekly check-ins. We maintained a shared Kanban board and calendar to stay aligned with milestones. Overall, the team dynamic remained positive and productive, and most of our challenges were technical rather than interpersonal.
