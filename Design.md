## I. Introduction

This DAO, called Neighbours-DAO, has been designed with the goal of increasing the involvement of people in their communities. The idea first came from the realisation that in big cities and smaller ones, only a fraction of the inhabitants are really involved in the decision process of urban design and rullings. Our objective is to create a platform that would incite more people to vote because they would be rewarded, but also to have a more transparent process on how the funds were spent by governing instances. The Neighbours-DAO is a on-chain governance system that enables decentralised decision-making. For this purpose we are using an extended version of an ERC20 both for voting token and reward. 

## II. Technical specification and diagram


### Contract and function interaction 
![Users ( Residents Representatives)](https://github.com/user-attachments/assets/ca0144b1-4d99-4ab9-952c-4ff806f29686)
### Chosen token standards

- **NGT**: Custom ERC20Votes (non-transferable + checkpointed)
  - Non-transferable unless to registrar (KYC backdoor)
  - Enforces *one-time* delegation
  - Built-in `rageQuit()` for simplified exit
  - Cap on total supply
  - Assembly used in `_delegate()` for gas optimization (Yul)

- **NRT**: Standard capped ERC20 token for community rewards
  - Annual mint cap enforced using `block.timestamp`
  - Merchants can burn for order refunds
### Chosen governance process model

- **Proposal Lifecycle:**
  1. Proposal created via RepresentativeCouncil
  2. Must meet multi-sig threshold (2 for minor, 4 for major)
  3. Routed to `NeighborGovernor`
  4. Enters timelock before votes start
  5. Voting uses **conviction voting**
     - Votes accrue based on stake *and* duration
     - Longer-held tokens = higher impact
  6. On success: proposal queued and executed via Governor
     
- **Voting Strategy:**
  - Conviction formula: `conviction += stake * time^2`
  - Users cannot delegate more than once
  - Only NGT holders eligible
  - Rage quit resets voting state
 
## III. Reflection 
### Motivation

The core motivation behind Neighbours-DAO was to create a governance framework that meaningfully reflects the needs of real communities. Traditional urban decision-making processes often lack transparency and exclude the broader population. By decentralizing governance and introducing financial incentives, we hoped to address voter apathy and foster civic engagement.

We chose the ERC-20 standard due to its strong compatibility with the Ethereum ecosystem and its adaptability for governance. The NGT token, modeled after ERC20Votes, supports delegation, vote weighting, and historical balance tracking — all critical for building trust in an on-chain voting system. We enhanced this model with restrictions like non-transferability and one-time delegation to prevent vote buying or farming, which are common challenges in decentralized governance.

The NRT reward token was designed to bridge the digital and real-world economies. By allowing NRT to be redeemed at local businesses or for public services, we connected blockchain participation to tangible benefits. This design ensures that civic participation is not only ideological but also economically motivating.

The conviction voting model was selected to emphasize long-term commitment over short-term speculation. It rewards voters who engage early and remain involved, aligning perfectly with our aim to build consistent community engagement rather than flash mobilization.

### Technical Challenges

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


### Team Organisation

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

### Lessons Learned

- **On-chain governance is hard**: Even seemingly simple features like voting delegation or reward splitting required deep thought and extensive testing.
- **Security and simplicity often conflict**: Adding safeguards (like rage quit and KYC-controlled transfers) adds complexity, and balancing both is a constant challenge.
- **Community design matters**: Technical tools are only half the solution — designing incentives that feel fair, inclusive, and engaging is just as important.
- **DevOps discipline pays off**: Strict branch management, automated testing, and version control reviews significantly improved our delivery process.

This project taught us how to bridge smart contract development with social systems and showed us the true power — and complexity — of decentralizing governance in real communities.
