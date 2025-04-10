# Class-DAO

This DAO uses a ERC20 token with a vote extension. The vote extension allows delegation, vote history and quorum functionalities. A time lock is not used in this example for simplicity sake and there is no fine grains control of time locking, only hard set periods fo voting and execution.

### Project Description
Descrition of the DAO and the token and governance model

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

