import { ethers } from "hardhat";

async function main() {
  const stakingContractAddress = "0x9dd96C15cF1b0ab9783fc8179494079fEcAfa50C"; // Address of your deployed StakingContract
  const stakeAddress = "0x707cF3136Ee229960017fF3461A296f703479535"; // Address of your deployed Stake token
  // const stakeAmount = 100; // Amount of tokens to stake
  const stakeAmount = ethers.parseUnits("100", 18); // Staking 100 units of your token


  const StakingContract = await ethers.getContractAt("StakingContract", stakingContractAddress);
  const stakeContract = await ethers.getContractAt("Stake", stakeAddress);

  const accounts = await ethers.getSigners();
  const signer = accounts[0];

  // Approve the StakingContract to spend tokens on your behalf
  await stakeContract.connect(signer).approve(stakingContractAddress, stakeAmount);

  // Stake tokens in the StakingContract
  await StakingContract.connect(signer).stake(stakeAmount);

  console.log("Staked", stakeAmount.toString(), "tokens successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
