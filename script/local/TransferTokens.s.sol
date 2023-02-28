// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

// Make various transfers from localnet accounts

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TransferTokens is Script {
    IERC20 public note = IERC20(0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9);
    IERC20 public croco = IERC20(0xCafac3dD18aC6c6e92c921884f9E4176737C052c);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Send tokens to DAO
        note.transfer(
            0xa16E02E87b7454126E5E10d957A927A7F5B5d2be,
            5000 * (10 ** 16)
        );
        croco.transfer(
            0xa16E02E87b7454126E5E10d957A927A7F5B5d2be,
            200000 * (10 ** 16)
        );

        // Send tokens to other accounts for testing
        croco.transfer(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            300000 * (10 ** 16)
        );

        vm.stopBroadcast();
    }
}
