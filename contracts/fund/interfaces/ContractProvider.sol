pragma solidity ^0.4.19;


// Interface for getting contracts from Doug
contract ContractProvider {
    function contracts(bytes32 name) public returns (address addr);
    function fundStatus() public returns(bool);
}
