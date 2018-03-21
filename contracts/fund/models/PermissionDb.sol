pragma solidity ^0.4.18;


import "../base/FundManagerEnabled.sol";
import "../interfaces/ContractProvider.sol";
import "../../base/Construct.sol";


// Permissions database
contract PermissionDb is FundManagerEnabled, Construct {

    mapping(bytes32 => mapping(address => bool)) public permissions;

    function constructor(address _foundOwner, address _nousAddress) public onConstructor {
        permissions["owner"][_foundOwner] = true;
        permissions["nous"][_nousAddress] = true;
    }

    // Set or update the permissions of an account.
    // not in owner and nous
    function setPermission(address _addr, bytes32 _role, bool _status) isFundManager public returns (bool) {
        require(_addr != 0x0);
        require(_role != "nous");
        require(_role != "owner");
        permissions[_role][_addr] = true;
    }

    function getPermission(bytes32 _role, address _addr) public returns (bool) {
        return permissions[_role][_addr];
    }

    // Transfer address
    function transferOwnership(bytes32 _role, address _newAddress) public returns (bool) {
        require(permissions[_role][msg.sender]);
        require(_newAddress != 0x0);
        permissions[_role][msg.sender] = false;
        permissions[_role][_newAddress] = true;
    }

}
