pragma solidity ^0.4.18;


import {PurchaseToken} from "./PurchaseToken.sol";
import {SaleToken} from "./SaleToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract Net is SaleToken, PurchaseToken {

    using SafeMath for uint256;

    mapping (address => uint256) public fundCup;
    address[] public indexTicker;

    // @dev Override mint function
    function afterSale(
        address _tokenProvider,
        uint256 _amountProviderWithFee,
        address _spender
    )
    internal
    {
        if (fundCup[_tokenProvider] == 0) {
            indexTicker.push(_tokenProvider);
        }

        fundCup[_tokenProvider] += _amountProviderWithFee;
        super.afterSale(_tokenProvider, _amountProviderWithFee, _spender);
    }

    function afterRedeem(
        address _tokenProvider,
        uint256 _amountProviderWithFee,
        address _spender
    )
    internal
    {
        fundCup[_tokenProvider] -= _amountProviderWithFee;
        super.afterRedeem(_tokenProvider, _amountProviderWithFee, _spender);
    }

    function totalNet()
    public
    view
    returns (uint256)
    {
        return indexTicker.length;
    }
}
