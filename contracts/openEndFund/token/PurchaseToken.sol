pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./BurnableToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
import "../../lib/MathCalc.sol";
//import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";


contract PurchaseToken is BurnableToken, BaseSaleOpenEnded {

    using SafeMath for uint256;

    event Redeem(address _tokenProvider, uint256 _amountProviderWithFee, address _spender);
    event Withdraw(address indexed from, address indexed to, uint256 value);

    // @dev withdraw Token
    function redeem(address _withdrawAddr, uint256 _value, bytes _extraData)
    public
    returns(bool)
    {
        require(allowPurchases[_withdrawAddr]);
        require(_value <= balances[msg.sender]);

        uint256 _totalAmount = MathCalc.calculateRedeem(_value, rate(), decimals);

        uint _amountExitFee = getFee(_totalAmount, "exitFee");
        uint _amountPlatformFee = getFee(_totalAmount, "platformFee");

        //_withdraw token
        ERC20(_withdrawAddr).transfer(msg.sender, _totalAmount.sub(_amountExitFee).sub(_amountPlatformFee));

        //fee token
        if (_amountExitFee > 0) {
            ERC20(_withdrawAddr).transfer(wallet, _amountExitFee);
        }

        if (_amountPlatformFee > 0) {
            ERC20(_withdrawAddr).transfer(nousWallet, _amountPlatformFee);
        }

        _burn(msg.sender, _value);

        afterRedeem(_withdrawAddr, _totalAmount, msg.sender);

    }

    // withdraw token to owner wallet
    function withdraw(address _withdrawAddr, uint _value)
    public
    {
        require(msg.sender == wallet);
        require(allowPurchases[_withdrawAddr]);

        ERC20(_withdrawAddr).transfer(msg.sender, _value);
        emit Withdraw(this, msg.sender, _value);
    }

    // hook for redeem token
    function afterRedeem(
        address _tokenProvider,
        uint256 _amountProviderWithFee,
        address _spender
    )
    internal
    {
        emit Redeem(_tokenProvider, _amountProviderWithFee, _spender);
    }
}
