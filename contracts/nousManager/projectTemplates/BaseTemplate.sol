pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract BaseTemplate is Validee {

    uint public version;

    // owner => projectType
    mapping (address => mapping(bytes32 => uint256)) public ids;

    function addProjectContract(
        address _owner,
        bytes32 _typeProject,
        bytes32 _contractName,
        address _contractAddr,
        uint _id
    )
    internal
    {
        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).addProject(_owner, _typeProject, _contractName, _contractAddr, _id);
    }

    function getId(address _projectOwner, bytes32 projectType)
    internal
    returns (uint)
    {
        return ids[_projectOwner][projectType]++;
    }

}
