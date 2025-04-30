
![images](https://github.com/user-attachments/assets/a11ec211-dc67-40be-9d88-42ec8a70a4c1)

# 🏘️ Neighbours-DAO

## 📅 Chronology of Work

- **30/03 – 12/04**: Conceptualization and research around DAO models  
- **13/04 – 19/04**: Token and governance contract development  
- **20/04 – 26/04**: Finalization of code and specifications  
- **27/04 – 30/04**: Testing and audit phase  

---

## 📜 Project Description

### 🏛️ Governance Model

Only official city representatives can submit proposals. These include:
- The Mayor  
- Syndicate leaders  
- Neighborhood representatives  

Proposal submission is managed through a **multi-signature wallet**, with variable signature requirements based on the impact level:
- **Minor proposals** (e.g., local event funding): 2-of-5 signatures  
- **Major proposals** (e.g., infrastructure upgrades): 4-of-5 signatures  

This ensures critical decisions require broader consensus.

---

### 🗳️ Voting System

Only **registered city residents** can vote. Registration verifies both identity and residence to prevent sybil attacks.

**Voting features**:
- Votes are cast **on-chain** (for or against).
- Residents earn **reward tokens** for participating.
- Earlier voters receive **higher rewards** (see reward section below).

---

### 🎁 Reward Mechanism

Residents receive `NRT` tokens as a reward for voting.

**Utility of Reward Token**:
- Discounts at local shops and restaurants  
- Loyalty bonuses for frequent use  
- Access to public services (e.g., transport, facilities)


**Installation and Execution** - 
Clone the repo and install dependencies:

```bash
git clone https://github.com/Tiny-boot/Neighbours-DAO.git
cd Neighbours-DAO
forge install
```


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

#### **2.3 Summary of tests**

This is a basic list of tests that have been provided for all contracts:

| Contract           | Test Type   | Description                                                  |
|--------------------|-------------|--------------------------------------------------------------|
| `NGT`              | Unit        | Test for minting eligibility, delegation, and transfer blocking |
| `NGT`              | Integration | Tests cross-contract delegation and voting rights            |
| `NGT`              | Fuzz        | Fuzz test for `rageQuit()` and supply invariants              |
| `NRT`              | Unit        | Ensures merchant-only burning and mint cap enforcement       |
| `NRT`              | Integration | Validates cap resets yearly                                  |
| `NRT`              | Fuzz        | Random minting scenarios, asserting cap invariants           |
| `StreakDistributor`| Unit        | Checks role-based access to points and finalization logic    |
| `StreakDistributor`| Integration | Simulates reward claims across multiple users                |
| `StreakDistributor`| Fuzz        | Tests dynamic point-based reward splits                      |

To run the tests, use the command:
```bash
forge test -vv
```


**Address of contracts on Sepolia** 

NeighborGovToken (NGT): 0xF72F0Ce7fE5C64B5Da1f1934aB0aFC219E8F4a31

NeighborRewardToken (NRT): 0x12b0bb67f5564282fb12da7f60974d54c019af01

StreakDistributor: 0x409478f7ac808344f0cee25da235f7c86dd93684

RepresentativeCouncil: 0x...

NeighborGovernor: 0x4c5c95c3105459cab26b168f54ddb6b167cbd58d

Timelock: 0xc8d4c5218b66cde02e74741cee32f899da95063d

**Contributions**

| Students           | Contributions   |
|--------------------|-------------|
| Sami Kader-Yettefti              | Tokens, Audit, Tests        | 
| César Denost        | Design and Team Management, Audit | 
| Jean-Baptiste Astruc   | Tests, Governance contract, Music      | 
| Kathleen Rogan              | Governance contract, Audit, Readme.md,Design.md        | 
| Joséphine Laguardia            | Design and Team Management,Design.md | 

