// test/helpers.ts
import { ethers } from "hardhat";
import { loadFixture, mine, time } from "@nomicfoundation/hardhat-network-helpers";

// mines N empty blocks – Governor needs elapsed blocks between propose & vote
export const mineBlocks = async (n: number) => {
  for (let i = 0; i < n; i++) await mine();
};

// moves the clock forward (Timelock delay, voting period, …)
export const warp = async (secs: number) => {
  await time.increase(secs);
};
