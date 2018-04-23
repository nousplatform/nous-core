pragma solidity ^0.4.18;


interface ContractProvider {
    function contracts(bytes32 name) returns (address);
}
