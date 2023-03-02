// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

// Deploy a simple ERC20 token that represents Canto Note

import "forge-std/Script.sol";
import "../src/DAOToken.sol";
import "../src/testnet/Turnstile.sol";

contract DeployNote is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Turnstile turnstile = new Turnstile();

        new DAOToken(
            "Canto Note",
            "NOTE",
            0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            1000000 * (10 ** 16),
            turnstile,
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
        );
        vm.stopBroadcast();
    }
}
