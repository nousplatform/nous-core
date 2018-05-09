pragma solidity ^0.4.18;


import "../safety/Validee.sol";


contract RoleDb is Validee {

    struct Role {
        bool locked;
        uint index;
    }

    // @dev role name <to> structure Role
    mapping(bytes32 => Role) roleList;
    address[] public roleIndexes;

    constructor() public {
        _addRole("owner", true);
    }

    function isRole(bytes32 _role) internal returns(bool) {
        if (roleIndexes.length == 0) return false;
        return roleIndexes[roleList[_role].index] == _role;
    }

    function _addRole(bytes32 _name, bool _locked) internal {
        roles[_name].locked = _locked;
        roles[_name].index = rolesIndex.push(_name) - 1;
    }

    // all roley add from function addRole can be overwritten
    function addRole(bytes32 _role) external returns(bool) {
        if (!validate()) return false;
        if (isRole(_role)) return false;

        _addRole(_role, false);
        return true;
    }

    function removeRole(bytes32 _role) external returns(bool) {
        if (!validate()) return false;
        if (!isRole(_role)) return false;
        if (isLocked()) return false;

        // todo Todos this realization

    }

    // getters
    function isLocked(bytes32 _role) public constant returns(bool) {
        require(isRole(_role), "Role not exists");
        return roleList[_role].locked;
    }

    function allowToAssign(bytes32 _role) public constant returns(bool) {
        if (!isRole(_role)) return false;
        return !roleList[_role].locked;
    }

}
