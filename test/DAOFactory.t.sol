// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import "../src/DAOFactory.sol";
import "../src/DAOProposer.sol";
import "../src/DAOToken.sol";
import "../src/DAOGovernor.sol";

import "../src/deployers/DAOGovernorDeployer.sol";
import "../src/deployers/DAOTokenDeployer.sol";
import "../src/deployers/DAOProposerDeployer.sol";
import "../src/testnet/Turnstile.sol";

contract DAOFactoryTest is Test {
    DAOGovernorDeployer governorDeployer;
    DAOTokenDeployer tokenDeployer;
    DAOProposerDeployer proposerDeployer;
    DAOFactory factory;

    function setUp() public {
        Turnstile turnstile = new Turnstile();
        governorDeployer = new DAOGovernorDeployer();
        tokenDeployer = new DAOTokenDeployer(turnstile);
        proposerDeployer = new DAOProposerDeployer();
        factory = new DAOFactory(
            IDAOGovernorDeployer(address(governorDeployer)),
            IDAOTokenDeployer(address(tokenDeployer)),
            IDAOProposerDeployer(address(proposerDeployer)),
            turnstile
        );
    }

    function testInstantiated() public {
        assertEq(
            address(factory.governorDeployer()),
            address(governorDeployer)
        );
        assertEq(address(factory.tokenDeployer()), address(tokenDeployer));
        assertEq(
            address(factory.proposerDeployer()),
            address(proposerDeployer)
        );
    }

    function testCanCreateDAO() public {
        (address dao, address token, address proposer) = factory.createDAO(
            "daoTest",
            "daoImage",
            "Test",
            "TST",
            1000000
        );
        assertEq(factory.getDAOCount(), 1);
        address newDao = factory.getDAO(0);
        assertEq(newDao, dao);

        DAOGovernor governor = DAOGovernor(payable(dao));
        assertEq(governor.name(), "daoTest");
        assertEq(governor.imageURL(), "daoImage");
        assertEq(governor.proposer(), proposer);
        assertEq(address(governor.token()), token);

        DAOToken tokenContract = DAOToken(token);
        assertEq(tokenContract.name(), "Test");
        assertEq(tokenContract.symbol(), "TST");
        assertEq(tokenContract.totalSupply(), 1000000);
        assertEq(tokenContract.owner(), dao);

        DAOProposer proposerContract = DAOProposer(proposer);
        assertEq(address(proposerContract.daoGovernor()), dao);

        // can create another DAO
        (dao, token, proposer) = factory.createDAO(
            "daoTest2",
            "daoImage2",
            "Test2",
            "TST2",
            1000000
        );
        assertEq(factory.getDAOCount(), 2);
        newDao = factory.getDAO(1);
        assertEq(newDao, dao);

        governor = DAOGovernor(payable(dao));
        assertEq(governor.name(), "daoTest2");
        assertEq(governor.imageURL(), "daoImage2");
        assertEq(governor.proposer(), proposer);
        assertEq(address(governor.token()), token);

        tokenContract = DAOToken(token);
        assertEq(tokenContract.name(), "Test2");
        assertEq(tokenContract.symbol(), "TST2");
        assertEq(tokenContract.totalSupply(), 1000000);
        assertEq(tokenContract.owner(), dao);

        proposerContract = DAOProposer(proposer);
        assertEq(address(proposerContract.daoGovernor()), dao);
    }
}
