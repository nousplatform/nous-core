pragma solidity ^0.4.18;


contract Construct {
    bool isCall = false;

    function construct(address foundOwner, address nousAddress) public {
        isCall = true;
    }
}
