# Neighbours-DAO

This DAO uses a ERC20 token with a vote extension. The vote extension allows delegation, vote history and quorum functionalities. A time lock is not used in this example for simplicity sake and there is no fine grains control of time locking, only hard set periods fo voting and execution.

### Project Description
#### *Governance Model*
Proposals can only be submitted by official city representatives, such as:

The Mayor

Syndicate leaders

Neighborhood representatives

Proposal submission is managed through a multi-signature wallet, where the required number of signatures varies depending on the importance or impact level of the proposal. For example:

Minor proposals (e.g., local event funding): 2 of 5 signatures

Major infrastructure changes: 4 of 5 signatures

This ensures that more critical decisions require broader consensus among city leadership.

#### *Voting System*
Only registered city residents are eligible to vote. This registration process verifies identity and residence, ensuring that voting power stays within the community.

Key characteristics of the voting system:

Residents vote on-chain for or against active proposals.

Voters receive a reward token for participating.

#### *Reward Mechanism*
The reward token functions as a local utility token. It can be used in:

Local shops and restaurants (discounts, loyalty bonuses)

Public services and infrastructure (e.g., subsidized transport or facility access)

To promote early and informed participation, the reward system is inversely proportional to total votes:

The earlier a resident votes, the more tokens they receive.

As more people vote on a proposal, the reward for new voters decreases.

This design incentivizes voters to engage promptly with community issues, rather than waiting until the outcome is clear.


**Installation and Execution** - How to download and install the project (at the very least need npm and hardhat)
Tests available (tiny 20 word description of each of the tests)

*Forge* is a state-of-the-art package for running tests, wrting codes and debugging it in Solidity environment.


#### 2.1 Download Forge
You can use *Forge* through a wider tool named *Foundry*. Here are the steps to install it into your computer. Open your terminal and follow these steps :

Create a new repository named Foundry:
```
mkdir foundry
```

Enter into this new repository:
```
cd foundry
```

Verify the connectivity of Foundry with our system:
```
curl -L https://foundry.paradigm.xyz | bash
```

Let Bash re-read the file:
```
source ~/.bashrc 
```

Install Foundry :
```
foundryup
```

More information about how to install Foundry are available [here](https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/14-foundry-setup/).


#### 2.2 Make tests with Forge

Here are some examples of how to run tests with *Forge* :

Run the tests:
```
forge test
```

Open a test in the debugger:
```
forge test --debug testSomething
```

Generate a gas report:
```
forge test --gas-report
```

Only run tests in `test/Contract.t.sol in the BigTest contract that start with testFail:
```
forge test --match-path test/Contract.t.sol --match-contract BigTest \ --match-test "testFail*"
```

List tests in desired format
```
forge test --list
forge test --list --json
forge test --list --json --match-test "testFail*" | tail -n 1 | json_pp
```

More information on the tests with Foundry are available [here](https://book.getfoundry.sh/reference/forge/forge-test)

#### 2.3 Summary of tests
While a list of basic tests have been provided for both contract, they do not test all required potential vulnerabilities, hence we do not recommend relying on them.


**Address of contracts on Sepolia** - jhigigig

**Extra** - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

