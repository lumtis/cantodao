// SPDX-License-Identifier: APACHE-2.0
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";

// An implementation of governance for DAOs
contract DAOGovernor is
    Governor,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorCountingSimple
{
    // DAO parameters
    uint256 private daoVotingDelay;
    uint256 private daoVotingPeriod;
    address public proposer;

    // DAO data
    string public imageURL;
    string public description;

    constructor(
        string memory _name,
        string memory _description,
        string memory _imageURL,
        IVotes _token,
        address _proposer,
        uint256 _quorumFraction,
        uint256 _votingDelay,
        uint256 _votingPeriod
    )
        Governor(_name)
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(_quorumFraction)
    {
        daoVotingDelay = _votingDelay;
        daoVotingPeriod = _votingPeriod;
        description = _description;
        imageURL = _imageURL;
        proposer = _proposer;
    }

    modifier onlyProposer() {
        require(
            msg.sender == proposer,
            "Only the proposer contract can execute this method"
        );
        _;
    }

    modifier onlySelf() {
        require(
            msg.sender == address(this),
            "Only the DAO governor can execute this method"
        );
        _;
    }

    // Proposal condition is controlled by the proposer contract
    function proposalThreshold() public pure override returns (uint256) {
        return 0;
    }

    function votingDelay() public view override returns (uint256) {
        return daoVotingDelay;
    }

    function votingPeriod() public view override returns (uint256) {
        return daoVotingPeriod;
    }

    function quorumVotes(uint256 proposalId) public view returns (uint256) {
        return quorum(proposalSnapshot(proposalId));
    }

    // Parameters modification methods

    function updateVotingDelay(uint256 _votingDelay) public onlySelf {
        daoVotingDelay = _votingDelay;
    }

    function updateVotingPeriod(uint256 _votingPeriod) public onlySelf {
        daoVotingPeriod = _votingPeriod;
    }

    function updateProposer(address _proposer) public onlySelf {
        proposer = _proposer;
    }

    function updateQuorumFraction(uint256 _fraction) public onlySelf {
        _updateQuorumNumerator(_fraction);
    }

    // Data modification methods

    function updateImageURL(string memory _imageURL) public onlySelf {
        imageURL = _imageURL;
    }

    function updateDescription(string memory _description) public onlySelf {
        description = _description;
    }

    function propose(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        string memory _description
    ) public override(Governor) onlyProposer returns (uint256) {
        uint256 proposalID = super.propose(
            _targets,
            _values,
            _calldatas,
            _description
        );

        return proposalID;
    }

    // The functions below are overrides required by Solidity
    function state(
        uint256 _proposalId
    ) public view override(Governor) returns (ProposalState) {
        return super.state(_proposalId);
    }

    function _execute(
        uint256 _proposalId,
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        bytes32 _descriptionHash
    ) internal override(Governor) {
        super._execute(
            _proposalId,
            _targets,
            _values,
            _calldatas,
            _descriptionHash
        );
    }

    function _cancel(
        address[] memory _targets,
        uint256[] memory _values,
        bytes[] memory _calldatas,
        bytes32 _descriptionHash
    ) internal override(Governor) returns (uint256) {
        return super._cancel(_targets, _values, _calldatas, _descriptionHash);
    }

    function _executor() internal view override(Governor) returns (address) {
        return super._executor();
    }

    function supportsInterface(
        bytes4 _interfaceId
    ) public view override(Governor) returns (bool) {
        return super.supportsInterface(_interfaceId);
    }
}
