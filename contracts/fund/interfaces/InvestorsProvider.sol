pragma solidity ^0.4.18;


contract InvestorsProvider {
    function addInvestor(address addr) public returns(bool);
    function deleteInvestor(address addr) public returns(bool);
    function getAllBalances() public constant returns(address[], uint256[]);
}
