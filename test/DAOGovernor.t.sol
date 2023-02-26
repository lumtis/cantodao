// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/governance/IGovernor.sol";
import "openzeppelin-contracts/contracts/governance/Governor.sol";
import "forge-std/Test.sol";
import "./mocks/Vote.sol";
import "../src/DAOGovernor.sol";

contract DAOGovernorTest is Test {
    DAOGovernor dao;
    VoteMock voteMock;

    function setUp() public {
        voteMock = new VoteMock();

        dao = new DAOGovernor(
            "daoTest",
            "daoImage",
            IVotes(address(voteMock)),
            address(0x123),
            50,
            10,
            10
        );
    }

    function testInstantiated() public {
        assertEq(dao.name(), "daoTest");
        assertEq(dao.imageURL(), "daoImage");
        assertEq(dao.proposer(), address(0x123));
        assertEq(address(dao.token()), address(voteMock));
        assertEq(dao.votingDelay(), 10);
        assertEq(dao.votingPeriod(), 10);
        assertEq(dao.proposalThreshold(), 0);
    }

    function testAllowProposerPropose() public {
        // Prepare proposal
        address[] memory targets = new address[](1);
        targets[0] = address(0x123);
        uint256[] memory values = new uint256[](1);
        values[0] = 42;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("setProposalCount(uint256)", 1);
        string memory description = "test";

        vm.prank(address(0x123));
        uint256 proposalId = dao.propose(
            targets,
            values,
            calldatas,
            description
        );
        assertEq(
            uint(dao.state(proposalId)),
            uint(IGovernor.ProposalState.Pending)
        );
    }

    function testFailNonProposerPropose() public {
        // Prepare proposal
        address[] memory targets = new address[](1);
        targets[0] = address(0x123);
        uint256[] memory values = new uint256[](1);
        values[0] = 42;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("setProposalCount(uint256)", 1);
        string memory description = "test";

        vm.prank(address(0x456));
        dao.propose(targets, values, calldatas, description);
    }
}
