pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


contract InvestorsDb is Validee {

    uint256 maxInvestors;

    // address = index, start from 1, 0 - is not investor
    mapping (address => uint256) public investors;

    address[] public investorIndex;

    function addInvestor(address _addr) internal {
        if (!validate()) return false;
        if (investors[_addr] == 0) {
            investors[_addr] = investorIndex.push(_addr);
        }
    }

    function removeInvestor(address _addr) internal {
        if (!validate()) return false;
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
