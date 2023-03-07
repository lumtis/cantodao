// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../DAOWrappedToken.sol";
import "../ITurnstile.sol";

interface IDAOWrappedTokenDeployer {
    function deployDAOWrappedToken(
        ERC20 _assetToken,
        address _turnstileOwner
    ) external returns (address, uint256);
}

contract DAOWrappedTokenDeployer {
    ITurnstile immutable turnstile;

    constructor(ITurnstile _turnstile) {
        turnstile = _turnstile;
    }

    function deployDAOWrappedToken(
        ERC20 _assetToken,
        address _turnstileOwner
    ) external returns (address, uint256) {
        DAOWrappedToken daoWrappedToken = new DAOWrappedToken(
            _assetToken,
            turnstile,
            _turnstileOwner
        );

        return (address(daoWrappedToken), daoWrappedToken.turnstileTokenId());
    }
}
