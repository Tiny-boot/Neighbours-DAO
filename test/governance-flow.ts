const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture, mine, time } =
  require("@nomicfoundation/hardhat-network-helpers");

const mineBlocks = async (n) => { for (let i = 0; i < n; i++) await mine(); };
const warp = async (s) => { await time.increase(s); };

describe("Neighbor DAO – happy path", function () {
  async function deployFixture() {
    // Actors
    const [deployer, registrar, alice, bob, carol] = await ethers.getSigners();

    // ─── Deploy token ───────────────────────────────────────────────────────────
    const NGT = await ethers.getContractFactory("NeighborGovToken");
    const ngt = await NGT.deploy(0, ethers.parseEther("1000000"), registrar.address);
    await ngt.waitForDeployment();

    // Mint 100 NGT to each voter and self-delegate
    for (const s of [alice, bob, carol]) {
      await ngt.connect(registrar).whitelist(s.address, true);
      await ngt.connect(registrar).mint(s.address, ethers.parseEther("100"));
      await ngt.connect(s).delegate(s.address);
    }

    // ─── Deploy timelock & governor ────────────────────────────────────────────
    const delay = 2 * 24 * 60 * 60; // 2 days
    const Timelock = await ethers.getContractFactory("TimelockController");
    const timelock = await Timelock.deploy(delay, [], []); // admin will be Governor later

    const Governor = await ethers.getContractFactory("NeighborGovernor");
    const governor = await Governor.deploy(
      await ngt.getAddress(),
      await timelock.getAddress(),
      ethers.ZeroAddress // Distributor (stub for test)
    );

    // Grant proposer / executor roles
    const proposerRole = await timelock.PROPOSER_ROLE();
    const executorRole = await timelock.EXECUTOR_ROLE();
    await timelock.grantRole(proposerRole, await governor.getAddress());
    await timelock.grantRole(executorRole, ethers.ZeroAddress); // anyone

    return { governor, timelock, ngt, alice, bob, carol };
  }

  it("goes through propose → vote → queue → execute", async function () {
    const { governor, timelock, ngt, alice, bob, carol } = await loadFixture(deployFixture);

    // ── Build a proposal: whitelist Dave in the token ──────────────────────────
    const dave = ethers.Wallet.createRandom().address;
    const calldata = ngt.interface.encodeFunctionData("whitelist", [dave, true]);

    const tx = await governor
      .connect(alice)
      .propose([await ngt.getAddress()], [0], [calldata], "Whitelist Dave");
    const receipt = await tx.wait();
    const proposalId = receipt.logs![0].args![0]; // emitted by Governor::ProposalCreated

    // Governor settings (taken from contract or constants in your code):
    const votingDelay = await governor.votingDelay();   // blocks
    const votingPeriod = await governor.votingPeriod(); // blocks

    // wait votingDelay blocks
    await mineBlocks(Number(votingDelay));

    // ── Cast votes ─────────────────────────────────────────────────────────────
    await governor.connect(alice).castVoteWithReason(proposalId, 1, "Yea");
    await governor.connect(bob).castVote(proposalId, 1);
    await governor.connect(carol).castVote(proposalId, 0); // Nay

    // wait until votingPeriod ends
    await mineBlocks(Number(votingPeriod));

    // queue
    await governor.queue(proposalId);

    // warp 2 days (timelock)
    const delaySecs = (await timelock.getMinDelay()).toNumber();
    await warp(delaySecs + 1);

    // execute
    await governor.execute(proposalId);

    // ── Check effects ──────────────────────────────────────────────────────────
    expect(await ngt.whitelist(dave)).to.equal(true);
  });
});
