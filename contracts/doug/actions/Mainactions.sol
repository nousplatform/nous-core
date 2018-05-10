pragma solidity ^0.4.18;


import "../safety/ActionManagerEnabled.sol";
import "../safety/Validee.sol";
import {ActionDbAbstract as ActionDb} from "../models/ActionDb.sol";
import {DougInterface as Doug} from "../Doug.sol";
import {ActionManagerInterface as ActionManager} from "../ActionManager.sol";
import {PermissionsDb as Permissions} from "../models/UserDb.sol";

interface ActionProvider {
    function setPermission(bytes32 _role, bool _permVal) external returns (bool);
}



contract Action is Validee, ActionManagerEnabled {
    // role => level Role permissions
    mapping(bytes32 => bool) public permission;
    // set permission sets only constructor
    bool allowSetPermission = true;

    function setPermission(bytes32 _role, bool _permVal) external returns (bool) {
        require(allowSetPermission);
        require(validate());
        permission[_role] = _permVal;
    }
}

/**
* @notice LockedAction do not set permission
* @dev
* @param
* @return
*/
contract LockedAction is Action {

    //permission lvl
    bool public locked = false;

    function lockAction() external returns (bool) {
        require(validate());
        locked = true;
    }

    function unlockAction() external returns (bool) {
        require(validate());
        locked = false;
    }

}

// Add action. NOTE: Overwrites currently added actions with the same name.
contract ActionAddAction is LockedAction {

    constructor() public {
        permission["owner"] = true;
    }

    function execute(bytes32 _name, address _addr) external {
        require(!locked);
        require(isActionManager(), "Access denied");
        address _adb = getContractAddress("ActionDb");
        require(ActionDb(_adb).addAction(_name, _addr), "Error query");
    }
}

// Remove action. Does not allow 'ActionAddAction' to be removed, though that it can still
// be done by overwriting this action with one that allows it.
contract ActionRemoveAction is Action {

    constructor() public {
        permission["owner"] = true;
    }

    function execute(bytes32 _name) external {
        require(isActionManager(), "Access denied");
        require(_name != "ActionAddAction");
        address _adb = getContractAddress("ActionDb");
        require(ActionDb(_adb).removeAction(_name), "Error query");
    }
}

// Lock actions. Makes it impossible to run actions for everyone but the owner.
// It is good to unlock the actions manager while replacing parts of the system
// for example.
contract ActionLockActions is Action {

    constructor() public {
        permission["owner"] = true;
    }

    function execute() external {
        require(isActionManager(), "Access denied");
        address _am = getContractAddress("ActionManager");
        require(ActionManager(_am).lock());
    }

}

// Unlock actions. Makes it possible for everyone to run actions.
contract ActionUnlockActions is Action {

    constructor() public {
        permission["owner"] = true;
    }

    function execute() external {
        require(isActionManager(), "Access denied");
        address _am = getContractAddress("ActionManager");
        require(ActionManager(_am).unlock());
    }

}

// The set user permission action.
contract ActionSetUserRole is Action {

    constructor() public {
        permission["owner"] = true;
    }

    function execute(address _addr, bytes32 _role, uint8 _perm) external {
        require(isActionManager(), "Access denied");
        address _perms = getContractAddress("UserDb");
        require(UserDb(_perms).setRole(_addr, _role));
    }

}

// The set user permission action.
contract ActionAddUser is Action {

    constructor() public {
        permission["owner"] = true;
    }

    function execute(address _addr, bytes32 _role, uint8 _perm) external {
        require(isActionManager(), "Access denied");
        address _perms = getContractAddress("PermissionDb");
        require(Permissions(_perms).setPermission(_addr, _role, _perm));
    }

}

// The set action permission. This is the permission level required to run the action.
contract ActionSetActionPermission is Action {

    constructor() public {
        permission["owner"] = true;
    }

    function execute(string _name, bool _perm) external {
        require(isActionManager(), "Access denied");
        address _adb = getContractAddress("ActionDb");
        address _action = ActionDb(_adb).actions(_name);
        require(_action != 0x0);
        require(Action(_action).setPermission(_role, _perm));
    }

}

// Add contract.
/*contract ActionAddContract is Action {

    function execute(bytes32 name, address addr) returns (bool) {
        if(!isActionManager()) {
            return false;
        }
        Doug d = Doug(DOUG);
        return d.addContract(name, addr);
    }

}*/

// Remove contract.
/*contract ActionRemoveContract is Action {

    function execute(bytes32 name) returns (bool) {
        if(!isActionManager()){
            return false;
        }
        Doug d = Doug(DOUG);
        return d.removeContract(name);
    }

}*/


