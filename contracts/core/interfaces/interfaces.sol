pragma solidity ^0.4.4;

contract ContractProvider {
    function contracts(bytes32 name) returns (address){}
}

contract Permissioner {
    function perms(address addr) constant returns (uint8) { }
}

contract Validator {
  function validate(address addr) constant returns (bool) {}
}

contract Charger {
  function charge(address addr, uint amount) returns (bool) {}
}

contract Endower {
  function endow(address addr, uint amount) returns (bool) {}
}
