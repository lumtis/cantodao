// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/DAOFactory.sol";

// DeployDao script
contract DeployDao is Script {
    DAOFactory public daoFactory =
        DAOFactory(0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy DAOs
        daoFactory.createDAO(
            "Crocodile DAO",
            "https://i.imgur.com/J2Awq0y.png",
            "Croco",
            "CROCO",
            1000000 * (10 ** 16)
        );
        daoFactory.createDAO(
            "Canto DAO",
            "https://i.imgur.com/5dCmheE.png",
            "Canto DAO",
            "CANTOX",
            6000000 * (10 ** 16)
        );

        vm.stopBroadcast();
    }
}
