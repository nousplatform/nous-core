pragma solidity ^0.4.18;


import "../commonFunctions/ProjectConstructor.sol";


contract OpenEndedFund is ProjectConstructor {

    address public tokenAddress;

    string public tokenName;

    string public tokenSymbol;

    constructor(address _fundOwn, string _fundName, bytes32[] _cNames, address[] _cAddrs, bool[] _cOverWr) public
    FundConstructor(_fundOwn, _fundName, _cNames, _cAddrs, _cOverWr) {

    }

    function addToken(address _tokenAddress, string _tokenName, string _tokenSymbol) public onlyOwner {
        require(tokenAddress == 0x0);
        tokenAddress = _tokenAddress;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
    }
}
