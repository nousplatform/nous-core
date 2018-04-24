pragma solidity ^0.4.18;


contract Test {

    uint256 public state = 0;

    function test1(uint256 num) public {
        state = num;
    }

    function getState() public constant returns(uint) {
        return state;
    }
}

contract Test_2 {

    address testContr;

    function Test_2() {
        //testContr = address(new Test());
    }

    function execute(address testtt, uint256 _integer) public {
        testtt.call(bytes4(keccak256("test1(uint256)")), _integer);
    }

    function testAddr() public constant returns(address, address) {
        return (testContr, this);
    }
}
