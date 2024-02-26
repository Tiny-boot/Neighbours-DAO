# Class-DAO

This DAO uses a ERC20 token with a vote extension. The vote extension allows delegation, vote history and quorum functionalities. A time lock is not used in this example for simplicity sake and there is no fine grains control of time locking, only hard set periods fo voting and execution.

### Votes.sol
This extension can be added to a token format ERC20 or ERC721 to give the token functionalities related to voting.

**Delegation** - the global *_delegatee* mapping only allows tokens to be delegated to one delegatee. However, it is possible to track the history of delegatees that the original delegator may have. Delegation is done automatically from the msg.sender or by specifying the signature (v,r,s) of a delegator to the delegatee.

**Votes** - track the balance of votes through Checkpoints. Can use getVotes for current amount of voting tokens or getPastVotes to get voting units at a specific point in time. Note: *Votes* and *VotingUnits* are NOT the same thing! Units are the token with no power. In the Openzeppelin setup, it is an all or nothing, 1-to-1, type of delegation.

**Clock** - used to have a snapshot of votes by block time or specified time. ERC6372.

### GovernorVotes.sol
Extracts the Vote count from the checkpoint in the token contract.

### GovernorCountingSimple.sol & & GovernorVotesQuorumFraction.sol
Hardcoded voting strategy. The *VoteType* enum allows for against/for/abstain as choices for each proposal.

**_countVotes** - counts the vote in accordance o the weighted voting power scheme.
**Quorum** - The quorum is calculated based on a *quorum numerator* which can be adjusted. This represents a percentage of the total supply. Both numerator and denominator can be adjusted and the history of the adjustment is kept. The QuorumFraction contract takes in a numerator in its constructor.
**COUNT_MODE** - In this governance model, both for and abstain votes count towards the percentage required to reach quorum.

### Governor.sol
The control center of the governance process. If a time lock is applied, the time lock contract gains control of the governor contract but in this example, there is none.

The proposal struct is set up in a way to enable onchain execution.

**propose** - function which allows the creation of proposals. onchain execution is possible with fields for constructing transactions with executable code. ProposalId can also be calculated from hashing.
**castVote** - there are multiple ways to cast votes. From simple vote, vote with reason, additional parameters, etc.
**execute** - onchain execution after proposal is queued.

The general Openzeppelin setup is create proposal - voting delay for discussion time - voting period - queueing - execution.