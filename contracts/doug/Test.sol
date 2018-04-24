pragma solidity ^0.4.18;


contract Test {

    uint256 public state = 0;

    function execute(uint256 num) public {
        state = num;
    }

    function getExecute(uint256 _num) constant public returns(uint256) {
        return _num + state;
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

    //bytes4(keccak256("test1(uint256)")), _integer
    function execute(address addr, bytes data) public {
        addr.call(data);
    }

    function getexecute(address addr, bytes data) constant public returns(uint256) {
        uint256 res = Test(addr).getExecute(10);
        return res;
    }

    function testAddr() public constant returns(address, address) {
        return (testContr, this);
    }
}
