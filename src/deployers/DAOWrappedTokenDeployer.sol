// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../DAOWrappedToken.sol";

interface IDAOWrappedTokenDeployer {
    function deployDAOWrappedToken(
        ERC20 _assetToken
    ) external returns (address);
}

contract DAOWrappedTokenDeployer {
    function deployDAOWrappedToken(
        ERC20 _assetToken
    ) external returns (address) {
        DAOWrappedToken daoWrappedToken = new DAOWrappedToken(_assetToken);

        return (address(daoWrappedToken));
    }
}
