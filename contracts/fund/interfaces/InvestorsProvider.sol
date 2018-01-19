pragma solidity ^0.4.18;


contract InvestorsProvider {
    function addInvestor(address _addr, uint256 _nousTkn) public returns(bool);
    function getAllBalances() public constant returns(address[], uint256[]);
    //function deleteInvestor(address addr) public returns(bool);
}
