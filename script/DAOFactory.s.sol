// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/deployers/SimpleGovernorFactory.sol";
import "../src/deployers/DAOTokenDeployer.sol";
import "../src/deployers/DAOWrappedTokenDeployer.sol";
import "../src/deployers/OnChainProposerFactory.sol";
import "../src/DAOFactory.sol";

// DAOFactory script
contract DAOFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy deployers
        SimpleGovernorFactory governorFactory = new SimpleGovernorFactory();
        DAOTokenDeployer tokenDeployer = new DAOTokenDeployer();
        DAOWrappedTokenDeployer wrappedTokenDeployer = new DAOWrappedTokenDeployer();
        OnChainProposerFactory proposerFactory = new OnChainProposerFactory();

        // Deploy DAOFactory
        DAOFactory daoFactory = new DAOFactory(
            ISimpleGovernorFactory(address(governorFactory)),
            IDAOTokenDeployer(address(tokenDeployer)),
            IDAOWrappedTokenDeployer(address(wrappedTokenDeployer)),
            IOnChainProposerFactory(address(proposerFactory))
        );
        daoFactory = daoFactory;

        vm.stopBroadcast();
    }
}
