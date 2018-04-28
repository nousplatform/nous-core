pragma solidity ^0.4.18;


contract PermissionProvider {

    function setPermission(address _address, bytes32 _role, bool _status) public returns (bool);

    function getPermission(bytes32 _role, address _addr) public returns (bool);
}
