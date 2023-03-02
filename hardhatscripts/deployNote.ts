import { BigNumber } from 'ethers';
import { ethers } from 'hardhat';

const main = async () => {
  const [owner] = await ethers.getSigners();

  // Deploy turnstile
  // We don't need to use the same contract as the factory one for test purpose
  const Turnstile = await ethers.getContractFactory("Turnstile");
  const turnstile = await Turnstile.deploy();
  await turnstile.deployed();

  // Deploy the contract
  const DAOToken = await ethers.getContractFactory("DAOToken");
  const daoToken = await DAOToken.deploy(
    "Note",
    "NOTE",
    owner.address,
    BigNumber.from("100000000000000000000000"),
    turnstile.address,
    owner.address
  );
  await daoToken.deployed();

  console.log("Note deployed to:", daoToken.address);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
