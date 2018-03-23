pragma solidity ^0.4.18;


contract SaleInterface {
    function constructor(
        address _owner,
        address _tokenAddress,
        uint256 _totalSupplyCap,
        uint256 _retainedByCompany,
        address _walletAddress,
        address _nousToken
    );
}
