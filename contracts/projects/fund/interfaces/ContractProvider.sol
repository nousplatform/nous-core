pragma solidity ^0.4.18;


// Interface for getting contracts from Doug
contract ContractProvider {
    function contracts(bytes32 name) public returns (address addr);
    function permission(bytes32 name) public returns (address addr);
}
