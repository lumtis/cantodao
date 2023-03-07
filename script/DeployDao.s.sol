// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/DAOFactoryNewToken.sol";

// DeployDao script
contract DeployDao is Script {
    DAOFactoryNewToken public daoFactory =
        DAOFactoryNewToken(0x5FC8d32690cc91D4c39d9d3abcBD16989F875707);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        DaoData memory data = DaoData({
            name: "Crocodile DAO",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            image: "https://i.imgur.com/J2Awq0y.png"
        });
        DaoToken memory tokenInfo = DaoToken({
            name: "Croco",
            symbol: "CROCO",
            initialSupply: 1000000 * (10 ** 16)
        });
        DaoParams memory params = DaoParams({
            quorumFraction: 40,
            votingDelay: 0,
            votingPeriod: 360
        });
        DaoProposer memory proposerInfo = DaoProposer({minimalVotingPower: 0});

        daoFactory.createDAO(data, tokenInfo, params, proposerInfo);

        DaoData memory data2 = DaoData({
            name: "Canto DAO",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            image: "https://i.imgur.com/5dCmheE.png"
        });
        DaoToken memory tokenInfo2 = DaoToken({
            name: "Canto DAO",
            symbol: "CANTOX",
            initialSupply: 6000000 * (10 ** 16)
        });

        daoFactory.createDAO(data2, tokenInfo2, params, proposerInfo);

        vm.stopBroadcast();
    }
}
