pragma solidity ^0.4.18;

contract PermissionProvider {

	function setPermission(address _addr, bytes32 _role) public returns (bool res) {}

	function getRolePerm(bytes32 _role) public returns (uint8) {}

	function getUserPerm(address _addr) public returns (uint8) {}
}
