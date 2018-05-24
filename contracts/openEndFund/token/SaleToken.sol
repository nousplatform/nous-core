pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
import "../../lib/MathPow.sol";


contract SaleToken is SimpleMintableToken, BaseSaleOpenEnded {

    using SafeMath for uint256;

    /**
    * Get notify in token contracts, only nous token
    * @param _sender Sender coins
    * @param _value The max amount they can spend
    */
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public onlyAllowPurchases returns (bool) {

        require(_sender != 0x0);
        require(_value > 0);

        ERC20 nt = ERC20(msg.sender); //_tknAddress
        uint256 _amount = nt.allowance(_sender, this);

        // how many coins we are allowed to spend
        if (_amount >= _value) {

            uint _entryFee = getDataParamsSaleDb("entryFee");

            uint _amountFee = _value.mul(_entryFee).div(100);

            _value = _value.sub(_amountFee);

            uint _rate;
            uint _precision;
            (_rate, _precision) = rate();

            uint256 _totalAmount = totalSum(_value, _rate, _precision);
            require(validateMaxFundCap(_totalAmount), "Max fund capital is ");

            if (nt.transferFrom(_sender, this, _value)) {
                nt.transfer(wallet, _amountFee); // transfer amount fee to wallet

                // mining token
                mint(_sender, _totalAmount);

                // Todo send nous token to wallet
                //nt.transfer(walletAddress, _value);
                return true;
            }
        }
        return false;
    }

    function validateMaxFundCap(uint256 _totalAmount)
    internal
    returns (bool)
    {
        uint maxFundCup = getDataParamsSaleDb("maxFundCup");
        if (maxFundCup > 0) {
            return maxFundCup >= _totalAmount;
        }
        return true;
    }

    function (uint numerator, uint rate, uint precisionRate)
    public
    constant
    returns(uint quotient)
    {
        uint decimals = 10 ** (precisionRate);
        uint _numerator = numerator * decimals;
        uint _quotient = (_numerator / rate) * decimals;
        return ( _quotient / decimals);
    }


    function totalSum(uint numerator, uint rate, uint precisionRate)
    public
    constant
    returns(uint quotient)
    {
        uint _decimals = 10 ** (precisionRate);
        uint _numerator = numerator.mul(_decimals);
        uint quotient = (_numerator.div(_rate)).mul(_decimals);
        return (quotient / _decimals);
    }

}
