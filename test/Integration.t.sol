// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

// Contains integration tests for the DAO contracts

import "forge-std/Test.sol";

import "@openzeppelin/contracts/governance/IGovernor.sol";

import "../src/DAOFactory.sol";
import "../src/DAOProposer.sol";
import "../src/DAOToken.sol";
import "../src/DAOGovernor.sol";

import "../src/deployers/DAOGovernorDeployer.sol";
import "../src/deployers/DAOTokenDeployer.sol";
import "../src/deployers/DAOProposerDeployer.sol";

contract IntegrationTest is Test {
    enum VoteType {
        Against,
        For,
        Abstain
    }

    DAOGovernorDeployer governorDeployer;
    DAOTokenDeployer tokenDeployer;
    DAOProposerDeployer proposerDeployer;
    DAOFactory factory;

    DAOGovernor dao;
    DAOToken token;
    DAOProposer proposer;

    address deployer;

    function setUp() public {
        deployer = address(0x123);
        vm.startPrank(deployer);

        // Create factory
        governorDeployer = new DAOGovernorDeployer();
        tokenDeployer = new DAOTokenDeployer();
        proposerDeployer = new DAOProposerDeployer();
        factory = new DAOFactory(
            IDAOGovernorDeployer(address(governorDeployer)),
            IDAOTokenDeployer(address(tokenDeployer)),
            IDAOProposerDeployer(address(proposerDeployer))
        );

        // Create a DAO
        (
            address daoAddress,
            address tokenAddress,
            address proposerAddress
        ) = factory.createDAO("daoTest", "daoImage", "Test", "TST", 1000000);
        dao = DAOGovernor(payable(daoAddress));
        token = DAOToken(tokenAddress);
        proposer = DAOProposer(proposerAddress);

        // Delegate voting power to the deployer
        token.delegate(deployer);

        vm.stopPrank();
    }

    function testVoteAndRejectProposal() public {
        vm.startPrank(deployer);
        vm.roll(10);

        // Create a proposal
        (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            string memory description
        ) = _transferProposal();
        uint256 proposalId = proposer.propose(
            targets,
            values,
            calldatas,
            description
        );
        assertEq(
            uint(dao.state(proposalId)),
            uint(IGovernor.ProposalState.Pending)
        );
        _mine(10);
        assertEq(
            uint(dao.state(proposalId)),
            uint(IGovernor.ProposalState.Active)
        );

        // Assert start and end date of the proposal
        assertEq(dao.proposalSnapshot(proposalId), 10);
        assertEq(dao.proposalDeadline(proposalId), 370);

        // Vote on the proposal
        assertFalse(dao.hasVoted(proposalId, deployer));
        dao.castVote(proposalId, uint8(VoteType.Against));
        assertTrue(dao.hasVoted(proposalId, deployer));

        // Check proposal is rejected after voting period
        _mine(1000);
        assertEq(
            uint(dao.state(proposalId)),
            uint(IGovernor.ProposalState.Defeated)
        );

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = dao
            .proposalVotes(proposalId);
        assertEq(againstVotes, 1000000);
        assertEq(forVotes, 0);
        assertEq(abstainVotes, 0);
    }

    function testVoteApproveAndExecuteProposal() public {
        vm.startPrank(deployer);

        // Send some tokens to the DAO
        token.transfer(address(dao), 50);

        // Create a proposal
        (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            string memory description
        ) = _transferTokensProposal(address(token));
        uint256 proposalId = proposer.propose(
            targets,
            values,
            calldatas,
            description
        );
        _mine(10);

        // Vote on the proposal
        assertFalse(dao.hasVoted(proposalId, deployer));
        dao.castVote(proposalId, uint8(VoteType.For));

        // Check proposal is approved after voting period
        _mine(1000);
        assertEq(
            uint(dao.state(proposalId)),
            uint(IGovernor.ProposalState.Succeeded)
        );

        // Check proposal can be executed
        assertEq(token.balanceOf(address(0x456)), 0);
        dao.execute(
            targets,
            values,
            calldatas,
            bytes32(keccak256(abi.encodePacked(description)))
        );
        assertEq(
            uint(dao.state(proposalId)),
            uint(IGovernor.ProposalState.Executed)
        );
        assertEq(token.balanceOf(address(0x456)), 42);
    }

    function _transferProposal()
        internal
        pure
        returns (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            string memory description
        )
    {
        targets = new address[](1);
        targets[0] = address(0x123);
        values = new uint256[](1);
        values[0] = 42;
        calldatas = new bytes[](1);
        calldatas[0] = "0x";
        description = "test";

        return (targets, values, calldatas, description);
    }

    function _transferTokensProposal(
        address _token
    )
        internal
        pure
        returns (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            string memory description
        )
    {
        targets = new address[](1);
        targets[0] = _token;
        values = new uint256[](1);
        values[0] = 0;
        calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature(
            "transfer(address,uint256)",
            address(0x456),
            42
        );
        description = "test";

        return (targets, values, calldatas, description);
    }

    function _mine(uint256 blocks) internal {
        vm.roll(block.number + blocks);
    }
}
