pragma solidity ^0.4.18;


import {ActionDb} from "../../doug/models/ActionDb.sol";
import {ActionManager} from "../../doug/ActionManager.sol";
import {SnapshotDb} from "../../projects/commonFunctions/models/SnapshotDb.sol";
contract TPLComponentsOEFund1 {
    function create() public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](3);
        _addrs = new address[](3);

        _names[0] = "ActionManager";
        _addrs[0] = new ActionManager();

        _names[1] = "ActionDb";
        _addrs[1] = new ActionDb();

        _names[2] = "SnapshotDb";
        _addrs[2] = new SnapshotDb();

        return (_names, _addrs);
    }
}


import {ProjectPermissionDb} from "../../projects/commonFunctions/models/ProjectPermissionDb.sol";
import {WalletDb} from "../../projects/commonFunctions/models/WalletDb.sol";
contract TPLComponentsOEFund2 {
    function create(address _nousManager, address _owner) public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](2);
        _addrs = new address[](2);

        _names[0] = "ProjectPermissionDb";
        _addrs[0] = new ProjectPermissionDb(_nousManager, _owner);

        _names[1] = "WalletDb";
        _addrs[1] = new WalletDb();
        return (_names, _addrs);

    }
}


import {OpenEndedToken} from "../../projects/openEndedFund/token/OpenEndedToken.sol";
import {OpenEndedSaleDb} from "../../projects/openEndedFund/models/OpenEndedSaleDb.sol";
contract TPLComponentsOEFund3 {
    function create(address _nousToken, string _name, string _symbol) public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](2);
        _addrs = new address[](2);

        _names[0] = "OpenEndedToken";
        _addrs[0] = new OpenEndedToken(_nousToken, _name, _symbol);

        _names[1] = "OpenEndedSaleDb";
        _addrs[1] = new OpenEndedSaleDb();
        return (_names, _addrs);
    }
}


import {ActionLockActions, ActionUnlockActions, ActionSetUserRole, ActionAddUser} from "../../doug/actions/Mainactions.sol";
import {ActionSetActionPermission} from "../../doug/actions/Mainactions.sol";
import {ProjectActionAddAction} from "../../projects/commonFunctions/actions/ProjectActions.sol";
contract TPLActionsOEFund {
    function create() public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](6);
        _addrs = new address[](6);

        _names[0] = "ProjectActionAddAction";
        _addrs[0] = new ProjectActionAddAction();

        _names[1] = "ActionLockActions";
        _addrs[1] = new ActionLockActions();

        _names[2] = "ActionUnlockActions";
        _addrs[2] = new ActionUnlockActions();

        _names[3] = "ActionSetUserRole";
        _addrs[3] = new ActionSetUserRole();

        _names[4] = "ActionAddUser";
        _addrs[4] = new ActionAddUser();

        _names[5] = "ActionSetActionPermission";
        _addrs[5] = new ActionSetActionPermission();
        return (_names, _addrs);
    }
}
