// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import "../src/deployers/DAOGovernorDeployer.sol";
import "../src/deployers/DAOExecutorDeployer.sol";
import "../src/deployers/DAOTokenDeployer.sol";
import "../src/deployers/DAOProposerDeployer.sol";
import "../src/interfaces/IDAOGovernorDeployer.sol";
import "../src/interfaces/IDAOExecutorDeployer.sol";
import "../src/interfaces/IDAOTokenDeployer.sol";
import "../src/interfaces/IDAOProposerDeployer.sol";
import "../src/DAOFactory.sol";

// DAOFactory script
contract DAOFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy deployers
        DAOGovernorDeployer governorDeployer = new DAOGovernorDeployer();
        DAOExecutorDeployer executorDeployer = new DAOExecutorDeployer();
        DAOTokenDeployer tokenDeployer = new DAOTokenDeployer();
        DAOProposerDeployer proposerDeployer = new DAOProposerDeployer();

        // Deploy DAOFactory
        DAOFactory daoFactory = new DAOFactory(
            IDAOGovernorDeployer(address(governorDeployer)),
            IDAOExecutorDeployer(address(executorDeployer)),
            IDAOTokenDeployer(address(tokenDeployer)),
            IDAOProposerDeployer(address(proposerDeployer))
        );
        // Remove warning
        daoFactory = daoFactory;

        vm.stopBroadcast();
    }
}