// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "../DAOProposer.sol";

interface IDAOProposerDeployer {
    function deployDAOProposer(uint256) external returns (address);
}

contract DAOProposerDeployer {
    function deployDAOProposer(
        uint256 _minimalVotingPower
    ) external returns (address) {
        DAOProposer daoProposer = new DAOProposer(_minimalVotingPower);
        return address(daoProposer);
    }
}
