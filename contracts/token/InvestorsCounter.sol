pragma solidity ^0.4.18;


contract InvestorsCounter {

    mapping (address => uint256) public investors;
    address[] public indexInvestors;

    function investorsCheck(address _to) {
        if (investors[_to] == 0) {
            investors[_to] = indexInvestors.push(_to);
        }
    }

    function totalInvestors() public constant returns(uint256) {
        return indexInvestors.length;
    }
}
