pragma solidity ^0.4.18;


contract FundInterface {
    function constructor(address _fundOwn, string _fundName, bytes32 _fundType); //*, uint256 _initCapNSU, uint256 _initCapCAP, */
    function addContract(bytes32 _name, address _addr, bool _doNotOverwrite) public returns(bool);
    function addToken(bytes32 _tokenSymbol, address _tokenAddr) public;
    //function bayShares(address _from, uint256 _value) returns (bool);
}
