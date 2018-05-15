pragma solidity ^0.4.18;


//import {ActionDb} from "../../doug/models/ActionDb.sol";
import {ProjectManager as ActionManager} from "../../projects/commonFunctions/ProjectManager.sol";
import {SnapshotDb} from "../../projects/commonFunctions/models/SnapshotDb.sol";
import {ProjectActionDb} from "../../projects/commonFunctions/models/ProjectActionDb.sol";

contract TPLComponentsOEFund1 {
    function create(bytes32[] _paramSale, uint256[] _valSale) public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](4);
        _addrs = new address[](4);

        _names[0] = "ActionManager";
        _addrs[0] = new ActionManager();

        _names[1] = "ActionDb";
        _addrs[1] = new ProjectActionDb();

        _names[2] = "SnapshotDb";
        _addrs[2] = new SnapshotDb();

        _names[3] = "OpenEndedSaleDb";
        _addrs[3] = new OpenEndedSaleDb(_paramSale, _valSale);
        return (_names, _addrs);
    }
}


import {ProjectPermissionDb} from "../../projects/commonFunctions/models/ProjectPermissionDb.sol";
import {WalletDb} from "../../projects/commonFunctions/models/WalletDb.sol";
contract TPLComponentsOEFund2 {
    function create(address _nousManager, address _owner) public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](2);
        _addrs = new address[](2);

        _names[0] = "PermissionDb";
        _addrs[0] = new ProjectPermissionDb(_nousManager, _owner);

        _names[1] = "WalletDb";
        _addrs[1] = new WalletDb();
        return (_names, _addrs);

    }
}


import {OpenEndedToken} from "../../projects/openEndedFund/token/OpenEndedToken.sol";
import {OpenEndedSaleDb} from "../../projects/openEndedFund/models/OpenEndedSaleDb.sol";
contract TPLComponentsOEFund3 {
    function create(address _owner, address _nousToken, string _name, string _symbol)
    public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](1);
        _addrs = new address[](1);

        _names[0] = "OpenEndedToken";
        _addrs[0] = new OpenEndedToken(_owner, _nousToken, _name, _symbol);


        return (_names, _addrs);
    }
}


import {ActionLockActions, ActionUnlockActions, ActionSetUserRole, ActionAddUser} from "../../doug/actions/Mainactions.sol";
import {ActionSetActionPermission} from "../../doug/actions/Mainactions.sol";
//import {ActionAddWallet, ActionConfirmWallet, ActionAddSnapshot} from "../../projects/commonFunctions/actions/ProjectActions.sol";
contract TPLActionsOEFundStep1 {
    function create() public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](5);
        _addrs = new address[](5);

        _names[0] = "ActionLockActions";
        _addrs[0] = new ActionLockActions();

        _names[1] = "ActionUnlockActions";
        _addrs[1] = new ActionUnlockActions();

        _names[2] = "ActionSetUserRole";
        _addrs[2] = new ActionSetUserRole();

        _names[3] = "ActionAddUser";
        _addrs[3] = new ActionAddUser();

        _names[4] = "ActionSetActionPermission";
        _addrs[4] = new ActionSetActionPermission();

    }
}

import {ActionAddWallet, ActionConfirmWallet, ActionAddSnapshot} from "../../projects/commonFunctions/actions/ProjectActions.sol";
contract TPLActionsOEFundStep2 {
    function create() public returns (bytes32[] memory _names, address[] memory _addrs) {
        _names = new bytes32[](3);
        _addrs = new address[](3);

        _names[0] = "ActionAddWallet";
        _addrs[0] = new ActionAddWallet();

        _names[1] = "ActionConfirmWallet";
        _addrs[1] = new ActionConfirmWallet();

        _names[2] = "ActionAddSnapshot";
        _addrs[2] = new ActionAddSnapshot();
        return (_names, _addrs);
    }
}
