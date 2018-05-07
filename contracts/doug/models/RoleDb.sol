pragma solidity ^0.4.18;


import "../safety/Validee.sol";


contract RoleDb is Validee {

    struct Role {
        uint8 permLvl;
        uint256 index;
    }

    // @dev role name <to> structure Role
    mapping(bytes32 => Role) private rolesStruct;

    bytes32[] public rolesIndex;

    constructor() public {
        _addRole("none", 0);
        _addRole("owner", 255);
    }

    function _addRole(bytes32 _name, uint8 _permLvl) internal {
        roles[_name] = Role({
            permLvl: _permLvl,
            index: rolesIndex.push(_name)
        });
    }

    function isRole(bytes32 _roleName) internal returns(bool) {
        if (rolesIndex.length == 0) return false;
        return rolesIndex[roles[_roleName].index] == _roleName;
    }

    function addRole(bytes32 _role, uint8 _permLvl) external returns(bool) {
        if (!validate()) return false;
        if (isRole(_role)) return false;
        _addRole(_role, _permLvl);
        return true;
    }

    /*
    * @dev Notice: Do not overwrite role permission if _permLvl more 200 points
    */
    function updateRole(bytes32 _role, uint8 _permLvl) external returns(bool) {
        if (!validate()) return false;
        if (!isRole(_role)) return false;
        if (roles[_role].permLvl > 200) return false; // Todo на стороне актион менеджера

        roles[_role].permLvl = _permLvl;
        return true;
    }

    // getters
    function role(bytes32 _role) public constant returns(uint) {
        if (!isRole(_role)) return false;
        return rolesStruct[_role].permLvl;
    }

}
