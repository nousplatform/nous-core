pragma solidity ^0.4.18;


import {BaseTemplate} from "./BaseTemplate.sol";
import {OpenEndedToken} from "../../openEndFund/token/OpenEndedToken.sol"; // ---


contract TPLOpenEndedToken is BaseTemplate { // ----

    bytes32 constant TYPE_PROJECT = "OpenEnded";
    bytes32 constant CONTRACT_NAME = "OpenEndedToken"; // -----

    function create(
        address _projectOwner,
        address _nousToken,
        string _name,
        string _symbol
    )
    external
    validate_
    returns (address)
    {
        address newContract = new OpenEndedToken(
            _projectOwner,
            _nousToken,
            _name,
            _symbol
        );
        uint _id = ids[_projectOwner]++;
        addProjectContract(_projectOwner, TYPE_PROJECT, CONTRACT_NAME, newContract, _id);
    }
}
