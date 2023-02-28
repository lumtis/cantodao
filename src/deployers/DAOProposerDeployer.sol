// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "../DAOProposer.sol";

interface IDAOProposerDeployer {
    function deployDAOProposer() external returns (address);
}

contract DAOProposerDeployer {
    function deployDAOProposer() external returns (address) {
        DAOProposer daoProposer = new DAOProposer();
        return address(daoProposer);
    }
}
