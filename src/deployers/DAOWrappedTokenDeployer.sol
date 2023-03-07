// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../DAOWrappedToken.sol";
import "../ITurnstile.sol";

interface IDAOWrappedTokenDeployer {
    function deployDAOWrappedToken(
        string memory _name,
        string memory _symbol,
        IERC20 _assetToken,
        address _turnstileOwner
    ) external returns (address, uint256);
}

contract DAOWrappedTokenDeployer {
    ITurnstile immutable turnstile;

    constructor(ITurnstile _turnstile) {
        turnstile = _turnstile;
    }

    function deployDAOWrappedToken(
        string memory _name,
        string memory _symbol,
        IERC20 _assetToken,
        address _turnstileOwner
    ) external returns (address, uint256) {
        DAOWrappedToken daoWrappedToken = new DAOWrappedToken(
            _name,
            _symbol,
            _assetToken,
            turnstile,
            _turnstileOwner
        );

        return (address(daoWrappedToken), daoWrappedToken.turnstileTokenId());
    }
}
