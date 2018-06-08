pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
import "../../lib/MathCalc.sol";
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

        // how many coins we are allowed to spend
        if (nt.allowance(_sender, this) >= _value) {

            uint _amountEntryFee = MathCalc.calculatePercent(_value, getDataParamsSaleDb("entryFee"), decimals);

            uint _amountPlatformFee = MathCalc.calculatePercent(_value, getDataParamsSaleDb("platformFee"), decimals);

            _value = _value.sub(_amountEntryFee).sub(_amountPlatformFee);

            uint256 _totalAmount = MathCalc.percent(_value, rate(), decimals);

            require(validateMaxFundCap(_totalAmount));

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

}
