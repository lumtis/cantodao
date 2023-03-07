// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/deployers/DAOGovernorDeployer.sol";
import "../src/deployers/DAOTokenDeployer.sol";
import "../src/deployers/DAOWrappedTokenDeployer.sol";
import "../src/deployers/DAOProposerDeployer.sol";
import "../src/DAOFactoryNewToken.sol";
import "../src/DAOFactoryExistingToken.sol";
import "../src/testnet/Turnstile.sol";

// DAOFactory script
contract DAOFactoryScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy deployers
        Turnstile turnstile = new Turnstile();
        DAOGovernorDeployer governorDeployer = new DAOGovernorDeployer();
        DAOTokenDeployer tokenDeployer = new DAOTokenDeployer(turnstile);
        DAOWrappedTokenDeployer wrappedTokenDeployer = new DAOWrappedTokenDeployer(
                turnstile
            );
        DAOProposerDeployer proposerDeployer = new DAOProposerDeployer();

        // Deploy DAOFactory
        DAOFactoryNewToken daoFactory = new DAOFactoryNewToken(
            IDAOGovernorDeployer(address(governorDeployer)),
            IDAOTokenDeployer(address(tokenDeployer)),
            IDAOProposerDeployer(address(proposerDeployer)),
            turnstile
        );
        daoFactory = daoFactory;

        // Deploy DAOFactory with existing token
        DAOFactoryExistingToken daoFactoryExistingToken = new DAOFactoryExistingToken(
                IDAOGovernorDeployer(address(governorDeployer)),
                IDAOWrappedTokenDeployer(address(wrappedTokenDeployer)),
                IDAOProposerDeployer(address(proposerDeployer)),
                turnstile
            );
        daoFactoryExistingToken = daoFactoryExistingToken;

        vm.stopBroadcast();
    }
}
