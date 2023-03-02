// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "../DAOToken.sol";
import "../ITurnstile.sol";

interface IDAOTokenDeployer {
    function deployDAOToken(
        string memory _name,
        string memory _symbol,
        address _fundedAddress,
        uint256 _initialSupply,
        address _turnstileOwner
    ) external returns (address, uint256);
}

// A regular ERC20 token with voting power and mintable by the owner
contract DAOTokenDeployer {
    ITurnstile immutable turnstile;

    constructor(ITurnstile _turnstile) {
        turnstile = _turnstile;
    }

    function deployDAOToken(
        string memory _name,
        string memory _symbol,
        address _fundedAddress,
        uint256 _initialSupply,
        address _turnstileOwner
    ) external returns (address, uint256) {
        DAOToken daoToken = new DAOToken(
            _name,
            _symbol,
            _fundedAddress,
            _initialSupply,
            turnstile,
            _turnstileOwner
        );

        // Transfer ownership of the token to the sender
        daoToken.transferOwnership(msg.sender);

        return (address(daoToken), daoToken.turnstileTokenId());
    }
}
