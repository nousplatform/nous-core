pragma solidity ^0.4.18;


import {TemplatesDbInterface as TemplatesDb} from "../models/TemplatesDb.sol";
import {ProjectDbInterface as ProjectDb} from "../models/ProjectDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";


contract ActionAddTemplates is Action("owner") {

    function execute(
        bytes32[] _names,
        address[] _addrs
    )
    isActionManager_
    public
    {
        require(_names.length == _addrs.length, "Invalid Params");

        address _tdba = getContractAddress("TemplatesDb");
        TemplatesDb _tdb = TemplatesDb(_tdba);

        for (uint256 i = 0; i < _names.length; i++) {
            require(_names[i] != bytes32(0));
            require(_addrs[i] != address(0));
            _tdb.addTemplate(_names[i], _addrs[i]);
        }
    }
}

