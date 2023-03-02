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
    daoProposerDeployer.address,
    turnstile.address
  );
  await daoFactory.deployed();

  console.table([
    [
      "daoGovernorDeployer",
      daoGovernorDeployer.address,
      await getBytecodeSize(daoGovernorDeployer),
    ],
    [
      "daoTokenDeployer",
      daoTokenDeployer.address,
      await getBytecodeSize(daoTokenDeployer),
    ],
    [
      "daoProposerDeployer",
      daoProposerDeployer.address,
      await getBytecodeSize(daoProposerDeployer),
    ],
    ["daoFactory", daoFactory.address, await getBytecodeSize(daoFactory)],
  ]);

  return {
    daoFactory,
  };
};

const main = async () => {
  await DeployFactory();
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
