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
  // Governor
  const DAOGovernorDeployer = await ethers.getContractFactory(
    "DAOGovernorDeployer"
  );
  const daoGovernorDeployer = await DAOGovernorDeployer.deploy();
  await daoGovernorDeployer.deployed();

  // Turnstile
  const Turnstile = await ethers.getContractFactory("Turnstile");
  const turnstile = await Turnstile.deploy();
  await turnstile.deployed();

  // Token
  const DAOTokenDeployer = await ethers.getContractFactory("DAOTokenDeployer");
  const daoTokenDeployer = await DAOTokenDeployer.deploy(turnstile.address);
  await daoTokenDeployer.deployed();

  // Wrapped token
  const DAOWrappedTokenDeployer = await ethers.getContractFactory(
    "DAOWrappedTokenDeployer"
  );
  const daoWrappedTokenDeployer = await DAOTokenDeployer.deploy(
    turnstile.address
  );
  await daoTokenDeployer.deployed();

  // Proposer
  const DAOProposerDeployer = await ethers.getContractFactory(
    "DAOProposerDeployer"
  );
  const daoProposerDeployer = await DAOProposerDeployer.deploy();
  await daoProposerDeployer.deployed();

  // Factory new token
  const DAOFactoryNewToken = await ethers.getContractFactory(
    "DAOFactoryNewToken"
  );
  const daoFactoryNewToken = await DAOFactoryNewToken.deploy(
    daoGovernorDeployer.address,
    daoTokenDeployer.address,
    daoProposerDeployer.address,
    turnstile.address
  );
  await daoFactoryNewToken.deployed();

  // Factory existing token
  const DAOFactoryExistingToken = await ethers.getContractFactory(
    "DAOFactoryNewToken"
  );
  const daoFactoryExistingToken = await DAOFactoryExistingToken.deploy(
    daoGovernorDeployer.address,
    daoTokenDeployer.address,
    daoProposerDeployer.address,
    turnstile.address
  );
  await daoFactoryExistingToken.deployed();

  console.table([
    [
      "daoFactoryNewToken",
      daoFactoryNewToken.address,
      await getBytecodeSize(daoFactoryNewToken),
    ],
    [
      "daoFactoryExistingToken",
      daoFactoryExistingToken.address,
      await getBytecodeSize(daoFactoryExistingToken),
    ],
  ]);
};

const main = async () => {
  await DeployFactory();
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
