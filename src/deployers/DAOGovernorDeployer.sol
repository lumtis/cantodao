// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/governance/utils/IVotes.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

import "../DAOGovernor.sol";

interface IDAOGovernorDeployer {
    function deployDAOGovernor(
        string memory _daoName,
        string memory _daoDescription,
        string memory _daoImage,
        IVotes _token,
        address _proposer,
        uint256 _quorumFraction,
        uint256 _votingDelay,
        uint256 _votingPeriod
    ) external returns (DAOGovernor);
}

contract DAOGovernorDeployer {
    function deployDAOGovernor(
        string memory _daoName,
        string memory _daoDescription,
        string memory _daoImage,
        IVotes _token,
        address _proposer,
        uint256 _quorumFraction,
        uint256 _votingDelay,
        uint256 _votingPeriod
    ) external returns (DAOGovernor) {
        // Deploy the DAO governor
        DAOGovernor dao = new DAOGovernor(
            _daoName,
            _daoDescription,
            _daoImage,
            _token,
            _proposer,
            _quorumFraction,
            _votingDelay,
            _votingPeriod
        );

        return DAOGovernor(dao);
    }
}
