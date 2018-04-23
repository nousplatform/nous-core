pragma solidity ^0.4.18;


contract Doug {
    function addContract(bytes32 name, address addr) returns (bool result);
    function removeContract(bytes32 name) returns (bool result);
}
