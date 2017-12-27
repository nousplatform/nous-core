pragma solidity ^0.4.18;

contract PermissionProvider {

	function setPermission(address addr, bytes32 perm) returns(bool res);

	function getRolePerm(bytes32 role) returns (uint8);

	function getUserPerm(address addr) returns (uint8);
}
