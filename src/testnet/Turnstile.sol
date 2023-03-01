// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../ITurnstile.sol";

// Implement a mock for Turnstile contract (CSR) for testnet purposes

contract Turnstile is ITurnstile, ERC721Enumerable {
    mapping(address => uint256) public contractTokenId;
    mapping(uint256 => uint256) public balances;

    uint256 _tokenIdTracker = 0;

    event Register(address smartContract, address recipient, uint256 tokenId);
    event Withdraw(uint256 tokenId, address recipient, uint256 feeAmount);
    event DistributeFees(uint256 tokenId, uint256 feeAmount);

    constructor() ERC721("Turnstile", "Turnstile") {}

    function register(address _recipient) public returns (uint256) {
        address smartContract = msg.sender;

        uint256 tokenId = _tokenIdTracker;
        _mint(_recipient, tokenId);
        _tokenIdTracker++;

        contractTokenId[smartContract] = tokenId;

        emit Register(smartContract, _recipient, tokenId);

        return tokenId;
    }

    function withdraw(
        uint256 _tokenId,
        address payable _recipient,
        uint256 _amount
    ) public returns (uint256) {
        uint256 earnedFees = balances[_tokenId];
        require(earnedFees > 0, "Turnstile: No fees to withdraw");

        if (_amount > earnedFees) _amount = earnedFees;

        balances[_tokenId] = earnedFees - _amount;

        emit Withdraw(_tokenId, _recipient, _amount);

        Address.sendValue(_recipient, _amount);
        return _amount;
    }

    function distributeFees(uint256 _tokenId) public payable {
        balances[_tokenId] += msg.value;
        emit DistributeFees(_tokenId, msg.value);
    }
}
