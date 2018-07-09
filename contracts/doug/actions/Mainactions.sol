pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import "../safety/Validee.sol";
import {ActionDbAbstract as ActionDb} from "../models/ActionDb.sol";
import {DougInterface as Doug} from "../Doug.sol";
import {ActionManagerInterface as ActionManager} from "../ActionManager.sol";
import {PermissionDbInterface as PermissionDb} from "../models/PermissionDb.sol";

interface ActionProvider {
    function setPermission(bytes32 _role, bool _permVal) external returns (bool);
}


contract Action is Validee, ActionManagerEnabled {

    // role => level Role permissions
    mapping(bytes32 => bool) public permission;

    constructor(bytes32 _role) public {
        permission[_role] = true;
    }

    function setPermission(bytes32 _role, bool _permVal)
    external
    validate_
    returns (bool) {
        permission[_role] = _permVal;
    }
}

// Add action. NOTE: Overwrites currently added actions with the same name.
contract ActionAddAction is Action("owner") {

    bool allowSetPermission = false;

    function execute(bytes32 _name, address _addr)
    public
    isActionManager_
    {
        address _adb = getContractAddress("ActionDb");
        require(ActionDb(_adb).addAction(_name, _addr), "Error query");
    }
}

// Add action. NOTE: Overwrites currently added actions with the same name.
contract ActionAddActions is Action("owner") {

    bool allowSetPermission = false;

    function execute(bytes32[] _names, address[] _addrs)
    public
    isActionManager_
    {
        address _adb = getContractAddress("ActionDb");
        for (uint i = 0; i < _names.length; i++) {
            ActionDb(_adb).addAction(_names[i], _addrs[i]);
        }
    }
}

// Remove action. Does not allow 'ActionAddAction' to be removed, though that it can still
// be done by overwriting this action with one that allows it.
contract ActionRemoveAction is Action("owner") {

    function execute(bytes32 _name)
    external
    isActionManager_
    {
        require(_name != "ActionAddAction");
        address _adb = getContractAddress("ActionDb");
        require(ActionDb(_adb).removeAction(_name), "Error query");
    }
}

// Lock actions. Makes it impossible to run actions for everyone but the owner.
// It is good to unlock the actions manager while replacing parts of the system
// for example.
contract ActionLockActions is Action("owner") {
    function execute()
    external
    isActionManager_
    {
        address _am = getContractAddress("ActionManager");
        require(ActionManager(_am).lock());
    }
}

// Unlock actions. Makes it possible for everyone to run actions.
contract ActionUnlockActions is Action("owner") {
    function execute()
    external
    isActionManager_
    {
        address _am = getContractAddress("ActionManager");
        require(ActionManager(_am).unlock());
    }
}

// The set user permission action.
contract ActionAddUser is Action("owner") {
    function execute(address _addr, bytes32 _name, bytes32 _role)
    external
    isActionManager_
    {
        address _permissionDb = getContractAddress("PermissionDb");
        require(PermissionDb(_permissionDb).addUser(_addr, _name, _role));
    }
}

// The set user permission action.
contract ActionRemoveUser is Action("owner") {
    function execute(address _addr)
    external
    isActionManager_
    {
        address _permissionDb = getContractAddress("PermissionDb");
        require(PermissionDb(_permissionDb).removeUser(_addr));
    }
}

// The set user permission action.
contract ActionSetUserRole is Action("owner") {
    function execute(address _addr, bytes32 _role)
    external
    isActionManager_
    {
        address _perms = getContractAddress("PermissionDb");
        require(PermissionDb(_perms).setRole(_addr, _role));
    }
}


// The set action permission. This is the permission level required to run the action.
contract ActionSetActionPermission is Action("owner") {
    function execute(bytes32 _name, bytes32 _role, bool _permVal)
    external
    isActionManager_
    {
        address _adb = getContractAddress("ActionDb");
        address _action = ActionDb(_adb).actions(_name);
        require(_action != 0x0);
        Action(_action).setPermission(_role, _permVal);
    }
}


// Add contract.
contract ActionAddContract is Action("owner") {

    function execute(bytes32 name, address addr)
    external
    isActionManager_
    {
        Doug d = Doug(DOUG);
        d.addContract(name, addr);
    }
}

// Remove contract.
contract ActionRemoveContract is Action("owner") {

    function execute(bytes32 name)
    external
    isActionManager_
    {
        Doug d = Doug(DOUG);
        d.removeContract(name);
    }
}

contract ActionAddSnapshot is Action("owner") {
    function execute(bytes32 name)
    external
    isActionManager_
    {
        Doug d = Doug(DOUG);
        d.removeContract(name);
    }
}


