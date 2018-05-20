pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {ProjectConstructor} from "../../openEndFund/ProjectConstructor.sol";


contract TPLProjectConstructor is BaseTemplate {

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "ProjectConstructor";

    function create(
        address _projectOwner,
        bytes32[] _names,
        address[] _addrs
    )
    external
    validate_
    returns (address)
    {
        address newContract = new ProjectConstructor(_names, _addrs);
        uint _id = ids[_projectOwner]++;
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }

}
