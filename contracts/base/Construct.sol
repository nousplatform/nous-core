pragma solidity ^0.4.18;


contract Construct {

    bool private constructorCall = false;

    modifier onConstructor() {
        require(!constructorCall);
        //constructor();
        _;
    }

    //if constructor call first line must be super.constructor();
    function constructor() public {
        constructorCall = true;
    }
}
