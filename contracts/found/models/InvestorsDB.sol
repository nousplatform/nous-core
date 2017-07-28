pragma solidity ^0.4.0;

contract InvestorsDB {

    struct Investors {
        int32 deposit;
        uint timestamp;
        uint index;
    }

    mapping( address => Investors ) private investors;
    address[] private investorsIndex;

    function InvestorsDB(){

    }
}
