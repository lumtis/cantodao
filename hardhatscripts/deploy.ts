import { ethers } from 'hardhat';

/**
 *
 * Hardhat script to deploy the DAOFactory contract
 * We keep using Hardhat since Foundry is unstable for deployment
 *
 */

const getBytecodeSize = async (contract: any) => {
  const contractCode = await ethers.provider.getCode(contract.address);
  return contractCode.length / 2;
};

export const DeployFactory = async () => {
  const turnstileAddress = "0xEcf044C5B4b867CFda001101c617eCd347095B44";

  // Governor
  const DAOGovernorDeployer = await ethers.getContractFactory(
    "DAOGovernorDeployer"
  );
  const daoGovernorDeployer = await DAOGovernorDeployer.deploy();
  await daoGovernorDeployer.deployed();

  // Token
  const DAOTokenDeployer = await ethers.getContractFactory("DAOTokenDeployer");
  const daoTokenDeployer = await DAOTokenDeployer.deploy(turnstileAddress);
  await daoTokenDeployer.deployed();

  // Wrapped token
  const DAOWrappedTokenDeployer = await ethers.getContractFactory(
    "DAOWrappedTokenDeployer"
  );
  const daoWrappedTokenDeployer = await DAOWrappedTokenDeployer.deploy(
    turnstileAddress
  );
  await daoTokenDeployer.deployed();

  // Proposer
  const DAOProposerDeployer = await ethers.getContractFactory(
    "DAOProposerDeployer"
  );
  const daoProposerDeployer = await DAOProposerDeployer.deploy();
  await daoProposerDeployer.deployed();

  // Factory
  const DAOFactory = await ethers.getContractFactory("DAOFactory");
  const daoFactory = await DAOFactory.deploy(
    daoGovernorDeployer.address,
    daoTokenDeployer.address,
    daoWrappedTokenDeployer.address,
    daoProposerDeployer.address,
    turnstileAddress
  );
  await daoFactory.deployed();

  console.table([
    ["daoFactory", daoFactory.address, await getBytecodeSize(daoFactory)],
  ]);
};

const main = async () => {
  await DeployFactory();
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
