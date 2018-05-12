pragma solidity ^0.4.18;


import {TemplatesDb} from "../models/TemplatesDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";
import "../../doug/interfaces/ContractProvider.sol";


contract ActionAddTemplates is Action("owner") {

    function execute(bytes32[] _names, address[] _addrs, bool[] _overwrite) public  {

        require(isActionManager(), "Permission denied.");
        require(_names.length == _addrs.length && _names.length == _overwrite.length, "Invalid Params");

        address _tdba = getContractAddress("TemplatesDb"); //ContractProvider(DOUG).contracts("TemplatesDb");
        require(_tdba != 0x0);

        TemplatesDb _tdb = TemplatesDb(_tdba);

        for (uint256 i = 0; i < _names.length; i++) {
            _tdb.addTemplate(_names[i], _addrs[i], _overwrite[i]);
        }

    }
}
