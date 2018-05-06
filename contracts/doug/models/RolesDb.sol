pragma solidity ^0.4.18;


contract RolesDb {

    struct Role {
        uint8 permLvl;
        uint256 index;
    }

    // @dev role name <to> structure Role
    mapping(bytes32 => Role) public roles;

    bytes32[] public rolesIndex;

    constructor() public {
        roles["none"] = Role({permLvl: 0, index: rolesIndex.push("none")});
        roles["owner"] = Role({permLvl: 0, index: rolesIndex.push("owner")});
    }

    function isRole(bytes32 _roleName) public returns(bool) {
        if (rolesIndex.length == 0) return false;
        return rolesIndex[roles[_roleName].index] == _roleName;
    }

    /*
    * @dev Notice: Do not overwrite role permission if _permLvl more 200 points
    */
    function addUpdateRole(bytes32 _role, uint8 _permLvl) external returns(bool) {
        if (!validate()) return false;
        if (isRole(_role)) return false;
        roles[_role] = Role({
            permLvl: _permLvl,
            index: rolesIndex.push(_role) - 1
        });
        return true;
    }

    function updateRole(bytes32 _role, uint8 _permLvl) public returns(bool) {
        if (!validate()) return false;
        if (!isRole(_role)) return false;
        if (roles[_role].permLvl > 200) return false;
        roles[_role] = Role({
            permLvl: _permLvl
        });
        return true;
    }

}
