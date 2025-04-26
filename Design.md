## I. Introduction

The Neighbours-DAO has been designed with the goal of increasing the involvement of individuals within their local communities. Inspired by the realization that, in both large and small cities, only a fraction of inhabitants actively participate in urban planning and regulatory decisions, our DAO aims to foster increased participation and transparency. Neighbours-DAO leverages blockchain technology for decentralized, transparent decision-making, and employs an incentivization mechanism where community members are rewarded for active participation. This approach not only promotes greater voter turnout but also ensures transparent accountability for the utilization of community funds. For this purpose, we are using extended versions of ERC-20 tokens both for governance (NGT) and rewards (NRT).

## II. Technical specification and diagram

### A. Overview of contracts and interactions

Our DAO implementation consists of five primary contracts that interact seamlessly to manage governance, token distribution, and incentives. The NGT (Governance Token) contract implements an ERC-20 governance token with capabilities for delegation, voting, and maintaining historical checkpoints to track voting power over time. The NRT (Reward Token) contract is another ERC-20 token, distributed as a reward for participation in governance activities, and can be utilized within local services.

The NeighborGovernor contract serves as the central governance mechanism, managing proposal lifecycle, voting processes, and proposal execution. It implements sophisticated voting strategies and maintains overall proposal management. The RepresentativeCouncil is a multi-signature wallet contract responsible for controlling the submission of proposals, enforcing varying signature requirements based on proposal significance. Lastly, the StreakDistributor manages incentives and reward distributions, employing a dynamic strategy to encourage early voter participation.


![Users ( Residents Representatives)](https://github.com/user-attachments/assets/2db904ea-2b76-4b99-9266-195357989389)
### B. Chosen token standards

The governance token (NGT) was selected as an ERC-20 standard due to its widespread acceptance, standardized delegation, and voting checkpoint capabilities, which facilitate historical voting power queries. Similarly, the reward token (NRT) also follows the ERC-20 standard to ensure straightforward reward distribution and seamless integration into community services.

### C. Chosen governance process model

Proposals can be submitted exclusively by official representatives through the RepresentativeCouncil multisig wallet. Voting is conducted through the NeighborGovernor contract, with voting power determined by the NGT token holdings. Incentives for voters are dynamically calculated by the StreakDistributor, promoting timely engagement and participation.

### D. Testing strategy

Comprehensive testing has been consolidated into a single test file, neighborContractsTest.T.sol, which includes unit tests, integration tests involving cross-contract interactions, and fuzz or invariance testing. These tests are executed using Forge to ensure robustness and security of the contracts.
 
## III. Reflection 

### A. Motivation for token and governance model

The choice of ERC-20 governance token standard was driven by the need for advanced governance functionalities such as historical vote tracking and delegation. The reward token (NRT) was implemented to encourage active community involvement and foster enhanced local economic interactions. Additionally, multisig governance via RepresentativeCouncil ensures responsible and secure proposal management, reflecting real-world governance practices.

### B. Technical difficulties encountered

We decided to split the repository into five branches: three feature branches (documentation, contracts, and tests), a dev branch, and the main branch. Each member of the project works on their own forked repositories and pushes their contributions to the feature branch that matches their tasks. Subsequently, the DevOps managers merge these changes into the dev branch to verify that all elements function smoothly together. Once the dev branch is stable and thoroughly tested, the updates are then merged into the main branch for final deployment.

Did you encounter any technical difficulties like merge conflicts?

### C. Team organisation

Did you encounter any interpersonal difficulties while managing the two development streams?