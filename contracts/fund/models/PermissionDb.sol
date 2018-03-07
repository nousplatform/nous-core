pragma solidity 0.4.18;


import "../base/FundManagerEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../../base/Construct.sol";


// Permissions database
contract PermissionDb is FundManagerEnabled, Construct {

    mapping (address => uint8) public perms;

    mapping (bytes32 => uint8) public rolePermission;

    function construct(address foundOwner, address nousaddress) public {
        if (isCall) revert();

        rolePermission["nous"] = 4;
        rolePermission["owner"] = 3;
        rolePermission["manager"] = 2;
        rolePermission["investor"] = 1;

        perms[foundOwner] = 3;
        perms[nousaddress] = 4;
        perms[msg.sender] = 3;

        isCall = true;
    }

    // Set the permissions of an account.
    function setPermission(address _addr, bytes32 _role) public returns (bool res) {
        require(isFundManager());
        perms[_addr] = rolePermission[_role];
        return true;
    }

    function getRolePerm(bytes32 _role) public returns (uint8) {
        return rolePermission[_role];
    }

    function getUserPerm(address _addr) public returns (uint8) {
        return perms[_addr];
    }

}
