// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import "../src/DAOFactoryExistingToken.sol";
import "../src/DAOProposer.sol";
import "../src/DAOWrappedToken.sol";
import "../src/DAOGovernor.sol";

import "../src/deployers/DAOGovernorDeployer.sol";
import "../src/deployers/DAOWrappedTokenDeployer.sol";
import "../src/deployers/DAOProposerDeployer.sol";
import "../src/testnet/Turnstile.sol";

import "./mocks/Token.sol";

// Define constant for quorum fraction, voting delay, and voting period
uint256 constant quorumFraction = 40;
uint256 constant votingDelay = 0;
uint256 constant votingPeriod = 360; // around 30 minutes
uint constant minimalVotingPower = 1000;

contract DAOFactoryExistingTokenTest is Test {
    TokenMock assetToken;
    DAOGovernorDeployer governorDeployer;
    DAOWrappedTokenDeployer tokenDeployer;
    DAOProposerDeployer proposerDeployer;
    DAOFactoryExistingToken factory;

    function setUp() public {
        assetToken = new TokenMock("Asset", "AST");
        assetToken.mint(address(0x123), 1000);

        Turnstile turnstile = new Turnstile();
        governorDeployer = new DAOGovernorDeployer();
        tokenDeployer = new DAOWrappedTokenDeployer(turnstile);
        proposerDeployer = new DAOProposerDeployer();
        factory = new DAOFactoryExistingToken(
            IDAOGovernorDeployer(address(governorDeployer)),
            IDAOWrappedTokenDeployer(address(tokenDeployer)),
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

    function testCanCreateDAOWithExistingToken() public {
        DaoData memory data = DaoData({
            name: "daoTest",
            description: "daoDescription",
            image: "daoImage"
        });
        DaoWrappedToken memory tokenInfo = DaoWrappedToken({
            name: "Test",
            symbol: "TST",
            assetToken: IERC20(address(assetToken))
        });
        DaoParams memory params = DaoParams({
            quorumFraction: quorumFraction,
            votingDelay: votingDelay,
            votingPeriod: votingPeriod
        });
        DaoProposer memory proposerInfo = DaoProposer({
            minimalVotingPower: minimalVotingPower
        });
        (address dao, address token, address proposer) = factory.createDAO(
            data,
            tokenInfo,
            params,
            proposerInfo
        );
        assertEq(factory.getDAOCount(), 1);
        address newDao = factory.getDAO(0);
        assertEq(newDao, dao);

        DAOGovernor governor = DAOGovernor(payable(dao));
        assertEq(governor.name(), "daoTest");
        assertEq(governor.description(), "daoDescription");
        assertEq(governor.imageURL(), "daoImage");
        assertEq(governor.proposer(), proposer);
        assertEq(address(governor.votingModule()), token);

        DAOWrappedToken tokenContract = DAOWrappedToken(token);
        assertEq(tokenContract.name(), "Test");
        assertEq(tokenContract.symbol(), "TST");
        assertEq(tokenContract.asset(), address(assetToken));

        DAOProposer proposerContract = DAOProposer(proposer);
        assertEq(address(proposerContract.daoGovernor()), dao);
        assertEq(proposerContract.minimalVotingPower(), minimalVotingPower);

        DaoData memory data2 = DaoData({
            name: "daoTest2",
            description: "daoDescription2",
            image: "daoImage2"
        });
        DaoWrappedToken memory tokenInfo2 = DaoWrappedToken({
            name: "Test2",
            symbol: "TST2",
            assetToken: IERC20(address(assetToken))
        });
        DaoParams memory params2 = DaoParams({
            quorumFraction: quorumFraction,
            votingDelay: votingDelay,
            votingPeriod: votingPeriod
        });
        DaoProposer memory proposerInfo2 = DaoProposer({
            minimalVotingPower: minimalVotingPower
        });

        // can create another DAO
        (dao, token, proposer) = factory.createDAO(
            data2,
            tokenInfo2,
            params2,
            proposerInfo2
        );
        assertEq(factory.getDAOCount(), 2);
        newDao = factory.getDAO(1);
        assertEq(newDao, dao);

        governor = DAOGovernor(payable(dao));
        assertEq(governor.name(), "daoTest2");
        assertEq(governor.description(), "daoDescription2");
        assertEq(governor.imageURL(), "daoImage2");
        assertEq(governor.proposer(), proposer);
        assertEq(address(governor.votingModule()), token);

        tokenContract = DAOWrappedToken(token);
        assertEq(tokenContract.name(), "Test2");
        assertEq(tokenContract.symbol(), "TST2");
        assertEq(tokenContract.asset(), address(assetToken));

        proposerContract = DAOProposer(proposer);
        assertEq(address(proposerContract.daoGovernor()), dao);
        assertEq(proposerContract.minimalVotingPower(), minimalVotingPower);
    }
}
