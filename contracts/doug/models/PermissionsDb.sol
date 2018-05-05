pragma solidity ^0.4.18;


import "../safety/Validee.sol";


// The Permissions contract
contract PermissionsDb is Validee {

    struct Role {
        uint8 permLvl;
        uint index;
    }

    mapping(bytes32 => Role) public roles;

    bytes32[] public indexRoles;

    //address => index role
    mapping(address => uint) public users;

    // set roleys
    constructor(address _owner) {
        users[_owner] = 1;
    }

    function setPermission(address _addr, uint _indexRole) external returns (bool) {

        if (!validate()) {
            return false;
        }
        users[_addr] = _indexRole;
        return true;
    }

    function addRole(bytes32 _newRole) external returns (uint) {

        if (!validate()) {
            return 0;
        }
        return roles.push(_newRole) - 1;
    }

    function transferUser(address _oldUser, address _newUser) external returns (bool) {
        if (!validate()) {
            return false;
        }
        uint8 _perm = users[_oldUser];
        users[_oldUser] = 0;
        users[_newUser] = _perm;
    }

    function getRole(address _userAddr) public constant returns(bytes32) {
        return roles[users[_userAddr]];
    }

}
