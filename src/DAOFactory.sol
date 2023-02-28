// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

import "./deployers/DAOGovernorDeployer.sol";
import "./deployers/DAOTokenDeployer.sol";
import "./deployers/DAOProposerDeployer.sol";
import "./DAOGovernor.sol";

// Define constant for quorum fraction, voting delay, and voting period
uint256 constant DEFAULT_QUORUM_FRACTION = 40;
uint256 constant DEFAULT_VOTING_DELAY = 0;
uint256 constant DEFAULT_VOTING_PERIOD = 360; // around 30 minutes

contract DAOFactory {
    // Deployer contracts
    IDAOGovernorDeployer public governorDeployer;
    IDAOTokenDeployer public tokenDeployer;
    IDAOProposerDeployer public proposerDeployer;

    address[] public daos;

    event DAOCreated(
        address indexed deployer,
        address dao,
        address token,
        address proposer
    );

    constructor(
        IDAOGovernorDeployer _governorDeployer,
        IDAOTokenDeployer _tokenDeployer,
        IDAOProposerDeployer _proposerDeployer
    ) {
        governorDeployer = _governorDeployer;
        tokenDeployer = _tokenDeployer;
        proposerDeployer = _proposerDeployer;
    }

    function createDAO(
        string memory _daoName,
        string memory _daoImage,
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _tokenInitialSupply
    ) external returns (address, address, address) {
        // Deploy proposer
        address proposer = proposerDeployer.deployDAOProposer();

        // Deploy governance token
        address token = tokenDeployer.deployDAOToken(
            _tokenName,
            _tokenSymbol,
            msg.sender,
            _tokenInitialSupply
        );

        // Deploy the DAO governor
        DAOGovernor dao = governorDeployer.deployDAOGovernor(
            _daoName,
            _daoImage,
            IVotes(token),
            proposer,
            DEFAULT_QUORUM_FRACTION,
            DEFAULT_VOTING_DELAY,
            DEFAULT_VOTING_PERIOD
        );

        // Set the governor to the proposer
        IDAOProposer(proposer).setGovernor(dao);

        // Transfer ownership of the token to the DAO
        Ownable(token).transferOwnership(address(dao));

        // Add the DAO to the array of DAOs
        daos.push(address(dao));

        emit DAOCreated(
            msg.sender,
            address(dao),
            address(token),
            address(proposer)
        );

        return (address(dao), address(token), address(proposer));
    }

    // Get a DAO from its index
    function getDAO(uint256 _index) external view returns (address) {
        return daos[_index];
    }

    // Get the number of DAOs
    function getDAOCount() external view returns (uint256) {
        return daos.length;
    }
}
