pragma solidity ^0.4.18;


import "../FundConstructor.sol";


contract OpenEndedFund is FundConstructor {

    address public tokenAddress;

    string public tokenName;

    string public tokenSymbol;

    /*function OpenEndedFund(
        address _fundOwn,
        string _fundName,
        string _fundType,
        bytes32[] _names,
        address[] _addrs
    ) FundConstructor(_fundOwn, _fundName, _fundType, _names, _addrs)
    {

    }*/

    function addToken(address _tokenAddress, string _tokenName, string _tokenSymbol) public onlyOwner {
        require(tokenAddress == 0x0);
        tokenAddress = _tokenAddress;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
    }
}
