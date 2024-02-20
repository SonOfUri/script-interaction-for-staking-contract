import { ethers } from "hardhat";

async function main() {
  const stakeToken = await ethers.deployContract("Stake");
  await stakeToken.waitForDeployment();

  const staking = await ethers.deployContract("StakingContract", [stakeToken.target]);
  await staking.waitForDeployment();

  console.log(
    `Stake Token contract deployed to ${stakeToken.target}`
    + ` Staking contract deployed to ${staking.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// 0x707cF3136Ee229960017fF3461A296f703479535
// 0x9dd96C15cF1b0ab9783fc8179494079fEcAfa50C

