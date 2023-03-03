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

// Define constant for quorum fraction, voting delay, and voting period
uint256 constant quorumFraction = 40;
uint256 constant votingDelay = 0;
uint256 constant votingPeriod = 360; // around 30 minutes

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
        DaoData memory data = DaoData({
            name: "daoTest",
            description: "daoDescription",
            image: "daoImage"
        });
        DaoToken memory tokenInfo = DaoToken({
            name: "Test",
            symbol: "TST",
            initialSupply: 1000000
        });
        DaoParams memory params = DaoParams({
            quorumFraction: quorumFraction,
            votingDelay: votingDelay,
            votingPeriod: votingPeriod
        });
        (address dao, address token, address proposer) = factory.createDAO(
            data,
            tokenInfo,
            params
        );
        assertEq(factory.getDAOCount(), 1);
        address newDao = factory.getDAO(0);
        assertEq(newDao, dao);

        DAOGovernor governor = DAOGovernor(payable(dao));
        assertEq(governor.name(), "daoTest");
        assertEq(governor.description(), "daoDescription");
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

        DaoData memory data2 = DaoData({
            name: "daoTest2",
            description: "daoDescription2",
            image: "daoImage2"
        });
        DaoToken memory tokenInfo2 = DaoToken({
            name: "Test2",
            symbol: "TST2",
            initialSupply: 1000000
        });
        DaoParams memory params2 = DaoParams({
            quorumFraction: quorumFraction,
            votingDelay: votingDelay,
            votingPeriod: votingPeriod
        });

        // can create another DAO
        (dao, token, proposer) = factory.createDAO(data2, tokenInfo2, params2);
        assertEq(factory.getDAOCount(), 2);
        newDao = factory.getDAO(1);
        assertEq(newDao, dao);

        governor = DAOGovernor(payable(dao));
        assertEq(governor.name(), "daoTest2");
        assertEq(governor.description(), "daoDescription2");
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
