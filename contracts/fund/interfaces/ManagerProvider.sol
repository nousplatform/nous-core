pragma solidity ^0.4.18;


contract ManagerProvider {

    function deleteManager(address managerAddress) returns(bool);

    function insertManager(address managerAddress, bytes32 firstName, bytes32 lastName, bytes32 email) returns (bool);

}
