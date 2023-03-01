// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

interface ITurnstile {
    function balances(uint256) external view returns (uint256);

    function register(address) external returns (uint256);

    function withdraw(
        uint256,
        address payable,
        uint256
    ) external returns (uint256);
}
