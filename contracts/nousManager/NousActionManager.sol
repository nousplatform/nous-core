pragma solidity ^0.4.18;
//pragma experimental ABIEncoderV2;


import {ActionManager} from "../doug/ActionManager.sol";
import {TemplatesDbInterface as TemplatesDb} from "./models/TemplatesDb.sol";
import {PermissionDb} from "../doug/models/PermissionDb.sol";


contract NousActionManager is ActionManager {

    event TemplateLogs(address indexed caller, bytes32 indexed tmpName, address tmpAddress, uint blockNumber);

    function deployTemplates(
        bytes32 _tplNames,
        bytes data
    )
    public
    returns (bool)
    {
        require(activeAction == 0x0, "Process busy at the moment.");
        // Permissions stuff
        address pAddr = getContractAddress("PermissionDb");

        // First we check the permissions of the account that's trying to execute the action.
        bytes32 _userRole;
        bool _owned;
        ( , _userRole, _owned) = PermissionDb(pAddr).getUser(msg.sender);
        require(_userRole == "owner");

        address _tdb = getContractAddress("TemplatesDb");
        address _template = TemplatesDb(_tdb).template(_tplNames, 0);
        require(_template != 0x0);

        activeAction = _template;

        require(_template.call(data));
        emit TemplateLogs(msg.sender, _tplNames, _template, block.number);

        activeAction = 0x0;
        return true;
    }
}
