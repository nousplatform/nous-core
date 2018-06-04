pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
//import "../../lib/MathPow.sol";


contract SaleToken is SimpleMintableToken, BaseSaleOpenEnded {

    using SafeMath for uint256;

    /**
    * Get notify in token contracts, only nous token
    * @param _sender Sender coins
    * @param _value The max amount they can spend
    */
    function receiveApproval(
        address _sender,
        uint256 _value,
        address _token,
        bytes _extraData
    )
    public
    onlyAllowPurchases
    returns (bool)
    {
        require(_sender != 0x0);
        require(_value > 0);

        ERC20 nt = ERC20(msg.sender); //_tknAddress
        uint256 _amount = nt.allowance(_sender, this);

        // how many coins we are allowed to spend
        if (_amount >= _value) {

            uint _entryFee = getDataParamsSaleDb("entryFee");
            uint _amountEntryFee = calculatePercent(_value, _entryFee, decimals);// _value.mul(_entryFee).div(100);

            uint _platformFee = getDataParamsSaleDb("platformFee");
            uint _amountPlatformFee = calculatePercent(_value, _platformFee, decimals);

            _value = _value.sub(_amountEntryFee).sub(_amountPlatformFee);

            uint256 _totalAmount = percent(_value, rate(), decimals);

            require(validateMaxFundCap(_totalAmount), "Max fund capital is ");

            if (nt.transferFrom(_sender, this, _value)) {

                // transfer amount fee to wallet
                nt.transfer(wallet, _amountEntryFee);

                // transfer amount fee to wallet for nous platform
                nt.transfer(nousWallet, _amountPlatformFee);

                // mining token
                mint(_sender, _totalAmount);

                return true;
            }
        }
        return false;
    }

    function validateMaxFundCap(uint256 _totalAmount)
    view
    returns (bool)
    {
        uint maxFundCup = getDataParamsSaleDb("maxFundCup");

        if (maxFundCup > 0) {
            return maxFundCup >= _totalAmount;
        }
        return true;
    }

    /*function (uint numerator, uint rate, uint precisionRate)
    public
    constant
    returns(uint quotient)
    {
        uint decimals = 10 ** (precisionRate);
        uint _numerator = numerator * decimals;
        uint _quotient = (_numerator / rate) * decimals;
        return ( _quotient / decimals);
    }*/


    /*function totalSum(uint numerator, uint rate, uint precisionRate)
    public
    constant
    returns(uint quotient)
    {
        uint _decimals = 10 ** (precisionRate);
        uint _numerator = numerator.mul(_decimals);
        uint _quotient = (_numerator.div(rate)).mul(_decimals);
        return (_quotient / _decimals);
    }*/

}
