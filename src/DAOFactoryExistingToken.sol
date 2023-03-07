// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./deployers/DAOGovernorDeployer.sol";
import "./deployers/DAOWrappedTokenDeployer.sol";
import "./deployers/DAOProposerDeployer.sol";
import "./DAOGovernor.sol";
import "./DAOFactoryNewToken.sol";

struct DaoWrappedToken {
    string name;
    string symbol;
    IERC20 assetToken;
}

contract DAOFactoryExistingToken {
    // Deployer contracts
    IDAOGovernorDeployer public governorDeployer;
    IDAOWrappedTokenDeployer public tokenDeployer;
    IDAOProposerDeployer public proposerDeployer;
    IERC721 immutable turnstile;

    address[] public daos;

    event DAOCreated(
        address indexed deployer,
        address dao,
        address token,
        address proposer
    );

    constructor(
        IDAOGovernorDeployer _governorDeployer,
        IDAOWrappedTokenDeployer _tokenDeployer,
        IDAOProposerDeployer _proposerDeployer,
        IERC721 _turnstile
    ) {
        governorDeployer = _governorDeployer;
        tokenDeployer = _tokenDeployer;
        proposerDeployer = _proposerDeployer;
        turnstile = _turnstile;
    }

    // Get a DAO from its index
    function getDAO(uint256 _index) external view returns (address) {
        return daos[_index];
    }

    // Get the number of DAOs
    function getDAOCount() external view returns (uint256) {
        return daos.length;
    }

    function createDAO(
        DaoData memory _data,
        DaoWrappedToken memory _token,
        DaoParams memory _params,
        DaoProposer memory _proposer
    ) external returns (address, address, address) {
        // Deploy proposer
        address proposer = proposerDeployer.deployDAOProposer(
            _proposer.minimalVotingPower
        );

        // Deploy governance token based on existing token
        (address token, uint256 turnstileTokenId) = _deployToken(_token);

        // Deploy the DAO governor
        DAOGovernor dao = _deployDao(_data, _params, IVotes(token), proposer);

        // Set the governor to the proposer
        IDAOProposer(proposer).setGovernor(dao);

        // Transfer the token DAO turnstile to the DAO
        turnstile.transferFrom(address(this), address(dao), turnstileTokenId);

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

    function _deployToken(
        DaoWrappedToken memory _token
    ) internal returns (address, uint256) {
        return
            tokenDeployer.deployDAOWrappedToken(
                _token.name,
                _token.symbol,
                _token.assetToken,
                address(this)
            );
    }

    function _deployDao(
        DaoData memory _data,
        DaoParams memory _params,
        IVotes _token,
        address _proposer
    ) internal returns (DAOGovernor) {
        return
            governorDeployer.deployDAOGovernor(
                _data.name,
                _data.description,
                _data.image,
                _token,
                _proposer,
                _params.quorumFraction,
                _params.votingDelay,
                _params.votingPeriod
            );
    }
}
