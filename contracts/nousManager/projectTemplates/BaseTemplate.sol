pragma solidity ^0.4.18;


import {ActionManagerEnabled} from "../../doug/safety/ActionManagerEnabled.sol";
import {ProjectDb} from "../models/ProjectDb.sol";


contract BaseTemplate is ActionManagerEnabled {

    event ContractCreator(bytes32 indexed name, address indexed contractAddr, address indexed owner);

    uint public version;

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
        ProjectDb(_pdb).addContract(_owner, _typeProject, _contractName, _contractAddr, _id);

        emit ContractCreator(_contractName, _contractAddr, _owner);
    }

    function getId(address _projectOwner, bytes32 projectType)
    internal
    view
    returns (uint)
    {
        address _pdb = getContractAddress("ProjectDb");
        ProjectDb(_pdb).getLasId(_projectOwner, projectType);
    }

}
