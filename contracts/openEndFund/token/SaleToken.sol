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

            uint _amountEntryFee;
            uint _amountPlatformFee;
            (_amountEntryFee, _amountPlatformFee) = getFees(_value, "entryFee", "platformFee");

            uint256 _totalAmount = MathCalc.percent(_value.sub(_amountEntryFee).sub(_amountPlatformFee), rate(), decimals);

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

    /**
    * @notice Delivery tokens to client
    * @param _accountHolder user address
    * @param _amountOf balance to send out
    */
    function airdropToken(
        address _accountHolder,
        uint256 _amountOf
    )
    public
    validate_
    {
        require(validateMaxFundCap(_amountOf));
        mint(_accountHolder, _amountOf);
    }

    function validateMaxFundCap(uint256 _totalAmount)
    view
    internal
    returns (bool)
    {
        uint maxFundCup = getDataParamsSaleDb("maxFundCup");

        if (maxFundCup > 0) {
            return maxFundCup >= _totalAmount;
        }
        return true;
    }

}
