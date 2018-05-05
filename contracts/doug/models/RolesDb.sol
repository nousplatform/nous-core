pragma solidity ^0.4.18;


contract RolesDb {

    struct Role {
        uint8 perm;
        bool notOverwrite;
        uint index;
    }

    mapping(bytes32 => Role) public roles;

    bytes32[] public indexRoles;

    function isRole(bytes32 _role) public constant returns(bool) {
        if (indexRoles.length == 0) return false;
        return indexRoles[roles[_role].index] == _role;
    }

    function addRole(bytes32 _newRole, uint8 _perm, bool _notOverwrite) external returns (uint) {
        if (!validate()/* || isRole(_newRole)*/) {
            return 0;
        }
        Role memory _role;
        _role.perm = _perm;
        _role.notOverwrite = _notOverwrite;
        _role.index = roles.push(_newRole) - 1;
        roles[_newRole] = _role;
        return _role.index;
    }

    function removeRole() {

    }
}
