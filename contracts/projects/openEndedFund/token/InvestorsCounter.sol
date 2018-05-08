pragma solidity ^0.4.18;

//counter investor
contract InvestorsCounter {

    mapping (address => uint256) public investors;
    address[] public investorIndex;

    function addInvestor(address _addr) internal {
        if (investors[_addr] == 0) {
            investors[_addr] = investorIndex.push(_addr);
        }
    }

    function removeInvestor(address _addr) internal {
        uint rowToDel = investors[_addr] - 1;
        investors[_addr] = 0;
        uint lastRow = investorIndex.length - 1;
        investorIndex[rowToDel] = lastRow;
        investorIndex.length--;
    }

    function countInvestors() public constant returns(uint256) {
        return investorIndex.length;
    }


}
