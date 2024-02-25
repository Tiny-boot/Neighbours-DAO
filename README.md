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
Hardcoded voting strategy. The *VoteType* enum allows for yes/no/abstain as choices for each proposal.

**_countVotes** - counts the vote in accordance o the weighted voting power scheme.
**Quorum** - The quorum is calculated based on a *quorum numerator* which can be adjusted. This represents a percentage of the total supply. Both numerator and denominator can be adjusted and the history of the adjustment is kept. The QuorumFraction contract takes in a numerator in its constructor.

### Governor.sol
The control center of the governance process. If a timelock 
