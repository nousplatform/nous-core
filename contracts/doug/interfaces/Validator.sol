pragma solidity ^0.4.18;


interface Validator {
    function validate(address addr) constant external returns (bool);
}
