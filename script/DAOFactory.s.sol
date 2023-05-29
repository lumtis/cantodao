// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/deployers/SimpleGovernorFactory.sol";
import "../src/deployers/DAOTokenFactory.sol";
import "../src/deployers/DAOWrappedTokenFactory.sol";
import "../src/deployers/OnChainProposerFactory.sol";
import "../src/DAOFactory.sol";

// DAOFactory script
contract DAOFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy factories
        SimpleGovernorFactory governorFactory = new SimpleGovernorFactory();
        DAOTokenFactory tokenFactory = new DAOTokenFactory();
        DAOWrappedTokenFactory wrappedTokenFactory = new DAOWrappedTokenFactory();
        OnChainProposerFactory proposerFactory = new OnChainProposerFactory();

        // Deploy DAOFactory
        DAOFactory daoFactory = new DAOFactory(
            ISimpleGovernorFactory(address(governorFactory)),
            IDAOTokenFactory(address(tokenFactory)),
            IDAOWrappedTokenFactory(address(wrappedTokenFactory)),
            IOnChainProposerFactory(address(proposerFactory))
        );
        daoFactory = daoFactory;

        vm.stopBroadcast();
    }
}
