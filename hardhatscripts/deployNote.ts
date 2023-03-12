import { BigNumber } from 'ethers';
import { ethers } from 'hardhat';

const main = async () => {
  const [owner] = await ethers.getSigners();
  const turnstileAddress = "0xEcf044C5B4b867CFda001101c617eCd347095B44";

  // Deploy the contract
  const DAOToken = await ethers.getContractFactory("DAOToken");
  const daoToken = await DAOToken.deploy(
    "Note",
    "NOTE",
    owner.address,
    BigNumber.from("100000000000000000000000"),
    turnstileAddress,
    owner.address
  );
  await daoToken.deployed();

  console.log("Note deployed to:", daoToken.address);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
