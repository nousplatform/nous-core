pragma solidity ^0.4.18;


import {TemplatesDb} from "../models/TemplatesDb.sol";
import {Action} from "../../doug/actions/Mainactions.sol";
import "../../doug/interfaces/ContractProvider.sol";


contract ActionAddTemplates is Action {

    function execute(bytes32[] _names, address[] _addrs, bool[] _overwrite) public returns (bool) {
        require(isActionManager(), "Permission denied.");
        require(_names.length == _addrs.length && _names.length == _overwrite.length, "Invalid Params");

        address tdba = ContractProvider(DOUG).contracts("TemplatesDb");
        require(tdba != 0x0);

        TemplatesDb tdb = TemplatesDb(tdba);

        for (uint256 i = 0; i < _names.length; i++) {
            tdb.addTemplate(_names[i], _addrs[i], _overwrite[i]);
        }

    }
}
