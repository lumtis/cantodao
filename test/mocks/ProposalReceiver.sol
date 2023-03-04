// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract ProposalReceiverMock {
    uint256 counter = 0;
    uint256 proposalId = 0;
    address[] targets;
    uint256[] values;
    bytes[] calldatas;
    string description;
    IVotes voteToken;

    function setProposalId(uint256 _proposalId) external {
        proposalId = _proposalId;
    }

    function setVoteToken(IVotes _voteToken) external {
        voteToken = _voteToken;
    }

    function token() public view returns (IVotes) {
        return voteToken;
    }

    function propose(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        string memory _description
    ) external returns (uint256) {
        targets = _targets;
        values = _values;
        calldatas = _calldatas;
        description = _description;

        counter++;
        return proposalId;
    }

    function getCalledContent()
        public
        view
        returns (
            address[] memory,
            uint256[] memory,
            bytes[] memory,
            string memory
        )
    {
        return (targets, values, calldatas, description);
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }
}
