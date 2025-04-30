## I. Introduction

The Neighbours-DAO aims to significantly increase community involvement by enabling transparent, decentralized decision-making through blockchain technology. Recognizing that urban planning and local governance often engage only a small fraction of city residents, this DAO fosters active community participation by rewarding voters and providing clear visibility into municipal fund allocation. Through specialized ERC-20 tokens for governance (NGT) and rewards (NRT), residents are encouraged to engage actively and meaningfully in their community.

---

## II. Technical Specifications

### A. Overview of Contracts and Interactions

Our DAO implementation consists of five primary contracts that interact seamlessly to manage governance, token distribution, and incentives. The **NGT (Governance Token)** contract implements an ERC-20 governance token with capabilities for delegation, voting, and maintaining historical checkpoints to track voting power over time. The **NRT (Reward Token)** contract is another ERC-20 token, distributed as a reward for participation in governance activities, and can be utilized within local services.

The **NeighborGovernor** contract serves as the central governance mechanism, managing the full proposal lifecycle, executing votes, and coordinating proposal execution. It implements sophisticated voting strategies to ensure equitable community decision-making. The **RepresentativeCouncil** contract is a multi-signature wallet responsible for controlling the submission of proposals and enforces varying signature thresholds depending on proposal significance. Finally, the **StreakDistributor** contract manages incentive logic and reward distributions, employing a dynamic strategy to reward early voter participation more generously.

![Users (Residents and Representatives)](https://github.com/user-attachments/assets/ca0144b1-4d99-4ab9-952c-4ff806f29686)

### B. Chosen Token Standards

The governance token (NGT) was selected based on the ERC-20 standard for its reliability, broad ecosystem support, and compatibility with delegation and historical voting checkpoint features. The reward token (NRT) also adopts the ERC-20 standard to ensure simplicity in minting, transferring, and integrating the token across different community services and smart contracts.

### C. Chosen Governance Process Model

Proposal submission is restricted to official city representatives (e.g., the Mayor, syndicate leaders, and neighborhood heads) and is managed by the **RepresentativeCouncil** multisig wallet. Depending on the level of importance, proposals require different quorum thresholds: 2-of-5 signatures for minor proposals and 4-of-5 for major ones. Voting is executed through the **NeighborGovernor** contract, where voting power is weighted based on NGT token holdings. The **StreakDistributor** calculates dynamic rewards that favor early voters to encourage timely civic participation.

### D. Testing Strategy

Comprehensive testing was consolidated in the test file `neighborContractsTest.T.sol`. This includes unit tests for core functionality, integration tests across contracts (e.g., delegation and reward claim flows), and fuzz/invariance testing to ensure robustness. All tests were conducted using the **Forge** testing framework from Foundry.

---

## III. Reflection

### A. Motivation for Token and Governance Model

The decision to adopt ERC-20 for both tokens was influenced by the need for well-supported and extensible standards. ERC-20's support for features such as delegation and balance history enables robust governance mechanisms like vote tracking and power calculation. NRT tokens provide a practical way to incentivize participation, and their use in local services strengthens community engagement. The use of a multisig wallet reflects real-world governance constraints and adds accountability to the proposal process.

### B. Technical Difficulties Encountered

To manage development efficiently and prevent conflicts, the team decided to split the repository into five branches: three feature branches (`documentation`, `contracts`, `tests`), one `dev` branch, and the `main` branch. Each team member worked from their own forked repository and pushed changes to the relevant feature branch. DevOps managers merged verified contributions into the `dev` branch after validation. Once tested and stable, the code was pushed to the `main` branch for deployment.

Despite these strategies, we occasionally encountered technical challenges, especially with merge conflicts and integration of contract dependencies. These issues were addressed through strict naming conventions, continuous integration via test pipelines, and regular team syncs.

### C. Team Organisation

Team organization was structured around clear roles and deliverables. By defining responsibilities early and maintaining open communication channels, we were able to minimize interpersonal friction. The use of a shared calendar, Discord check-ins, and a Kanban board helped us stay aligned on milestones and deliverables. Challenges were mostly technical rather than interpersonal, though coordinating across parallel workstreams required careful planning and flexibility.
