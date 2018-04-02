pragma solidity ^0.4.18;


contract InvestorsCounter {

    mapping (address => uint256) public investors;
    address[] public investorIndex;

    function investorsCheck(address _from, address _to) {

        /*if (balanceOf[_from] <= 0) {

        }*/

        if (investors[_to] == 0) {
            investors[_to] = investorIndex.push(_to);
        }
    }

    function totalInvestors() public constant returns(uint256) {
        return investorIndex.length;
    }
}
