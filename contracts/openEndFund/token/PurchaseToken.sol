pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./BurnableToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
import "../../lib/MathCalc.sol";
//import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";


contract PurchaseToken is BurnableToken, BaseSaleOpenEnded {

    using SafeMath for uint256;

    event Redeem(address indexed from, address indexed to, uint256 value);
    event Withdraw(address indexed from, address indexed to, uint256 value);

    // @dev withdraw Token
    function redeem(address _withdrawAddr, uint256 _value, bytes _extraData)
    public
    returns(bool)
    {
        require(allowPurchases[_withdrawAddr]);
        require(_value <= balances[msg.sender]);

        uint256 _totalAmount = _value.div(rate());

        uint _amountEntryFee = MathCalc.calculatePercent(_totalAmount, getDataParamsSaleDb("exitFee"), decimals);

        uint _amountPlatformFee = MathCalc.calculatePercent(_totalAmount, getDataParamsSaleDb("platformFee"), decimals);

        _totalAmount = _totalAmount.sub(_amountEntryFee).sub(_amountPlatformFee);

        //_withdraw token
        ERC20(_withdrawAddr).transfer(msg.sender, _totalAmount);

        emit Redeem(msg.sender, _withdrawAddr, _totalAmount);

        //fee token
        ERC20(_withdrawAddr).transfer(wallet, _amountEntryFee);
        ERC20(_withdrawAddr).transfer(nousWallet, _amountPlatformFee);
        //require(res2, "Transfer exit fee error");

        _burn(msg.sender, _value);
        afterRedeem();
    }

    function withdraw(address _withdrawAddr, uint _value)
    public
    {
        require(msg.sender == wallet);
        require(allowPurchases[_withdrawAddr]);

        ERC20(_withdrawAddr).transfer(msg.sender, _value);
        emit Withdraw(this, msg.sender, _value);
    }

    function afterRedeem() internal {}
}
