// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ITurnstile.sol";

// A regular ERC20 token with voting power and mintable by the owner
contract DAOToken is ERC20, ERC20Permit, ERC20Votes, Ownable {
    ITurnstile immutable turnstile;
    uint256 public immutable turnstileTokenId;

    constructor(
        string memory _name,
        string memory _symbol,
        address _fundedAddress,
        uint256 _initialSupply,
        ITurnstile _turnstile,
        address _turnstileOwner
    ) ERC20(_name, _symbol) ERC20Permit(_name) {
        _mint(_fundedAddress, _initialSupply);
        turnstile = _turnstile;
        turnstileTokenId = turnstile.register(_turnstileOwner);
    }

    function mint(uint256 amount) public onlyOwner {
        _mint(owner(), amount);
    }

    // The functions below are overrides required by Solidity
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(
        address account,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
