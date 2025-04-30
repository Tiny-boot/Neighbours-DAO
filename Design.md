## I. Introduction

This DAO, called Neighbours-DAO, has been designed with the goal of increasing the involvement of people in their communities. The idea first came from the realisation that in big cities and smaller ones, only a fraction of the inhabitants are really involved in the decision process of urban design and rullings. Our objective is to create a platform that would incite more people to vote because they would be rewarded, but also to have a more transparent process on how the funds were spent by governing instances. The Neighbours-DAO is a on-chain governance system that enables decentralised decision-making. For this purpose we are using an extended version of an ERC20 both for voting token and reward. 

## II. Technical specification and diagram


### A. Contract and function interaction 
![Users ( Residents Representatives)](https://github.com/user-attachments/assets/ca0144b1-4d99-4ab9-952c-4ff806f29686)
### B. Chosen token standards

- **NGT**: Custom ERC20Votes (non-transferable + checkpointed)
  - Non-transferable unless to registrar (KYC backdoor)
  - Enforces *one-time* delegation
  - Built-in `rageQuit()` for simplified exit
  - Cap on total supply
  - Assembly used in `_delegate()` for gas optimization (Yul)

- **NRT**: Standard capped ERC20 token for community rewards
  - Annual mint cap enforced using `block.timestamp`
  - Merchants can burn for order refunds
### C. Chosen governance process model

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

Our goal was to build a neighborhood governance tool that rewards active participation while preventing vote centralization. We focused on:

- Trust-based KYC eligibility
- One-time voting to prevent vote farming
- Incentivized rewards tied to proposal voting
- Community-first design with exit options

### Technical Challenges

- Conviction voting implementation and time weighting were non-trivial.
- Needed to refactor delegation logic to fit voting restrictions.
- Merge conflicts around access control were a recurring issue across NGT + Governance + StreakDistributor.

### Management Lessons

- Integrating multiple teams required clear function contracts and deadlines.
- Git discipline (branches, small commits) was critical to avoid last-minute fire drills.
- Static and dynamic auditing caught subtle transfer bugs early.

