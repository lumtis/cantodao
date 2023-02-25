// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/deployers/DAOGovernorDeployer.sol";
import "../src/deployers/DAOTokenDeployer.sol";
import "../src/deployers/DAOProposerDeployer.sol";
import "../src/DAOFactory.sol";

// DAOFactory script
contract DAOFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy deployers
        DAOGovernorDeployer governorDeployer = new DAOGovernorDeployer();
        DAOTokenDeployer tokenDeployer = new DAOTokenDeployer();
        DAOProposerDeployer proposerDeployer = new DAOProposerDeployer();

        // Deploy DAOFactory
        DAOFactory daoFactory = new DAOFactory(
            IDAOGovernorDeployer(address(governorDeployer)),
            IDAOTokenDeployer(address(tokenDeployer)),
            IDAOProposerDeployer(address(proposerDeployer))
        );
        // Remove warning
        daoFactory = daoFactory;

        vm.stopBroadcast();
    }
}