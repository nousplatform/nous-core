pragma solidity ^0.4.18;


import "../../../doug/safety/ActionManagerEnabled.sol";
import "../../../doug/safety/Validee.sol";


contract ActionProject is ActionManagerEnabled, Validee {

    // role => level
    mapping(bytes32 => bool) public permission;

    function setPermission(bytes32 _role, bool _level) external returns (bool) {
        if (!validate()) {
            return false;
        }
        permission[_role] = permVal;
    }
}

// Add action. NOTE: Overwrites currently added actions with the same name.
contract ActionAddActionProject is ActionProject {

    constructor() {
        permission["nous", true];
    }

    function execute(bytes32 name, address addr) external returns (bool) {
        if (!isActionManager()) {
            return false;
        }
        address adb = ContractProvider(DOUG).contracts("ActionDb");
        if (adb == 0x0) {
            return false;
        }
        return ActionDb(adb).addAction(name, addr);
    }
}

