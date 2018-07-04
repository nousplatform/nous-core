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

    event Sale(address _tokenProvider, uint256 _amountProviderWithFee, address _spender);

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

            uint256 _amountEntryFee = getFee(_value, "entryFee");
            uint256 _amountPlatformFee = getFee(_value, "platformFee");

            uint256 _totalAmount = MathCalc.percent(_value.sub(_amountEntryFee).sub(_amountPlatformFee), rate(), decimals);

            require(validateMaxFundCap(_totalAmount));

            if (nt.transferFrom(_sender, this, _value)) {

                if (_amountEntryFee > 0) {
                    // transfer amount fee to wallet
                    nt.transfer(wallet, _amountEntryFee);
                }

                if (_amountPlatformFee > 0) {
                    // transfer amount fee to wallet for nous platform
                    nt.transfer(nousWallet, _amountPlatformFee);
                }

                // mining token
                mint(_sender, _totalAmount);

                afterSale(msg.sender, _value, _sender);

                return true;
            }
        }
        return false;
    }

    // hook after sale token
    function afterSale(
        address _tokenProvider,
        uint256 _amountProviderWithFee,
        address _spender
    )
    internal
    {
        emit Sale(_tokenProvider, _amountProviderWithFee, _spender);
    }

    /**
    * @notice Delivery tokens to owner
    * @param _amountOf balance to send out
    */
    function airdropToken(
        uint256 _amountOf
    )
    external
    isActionManager_
    {
        require(validateMaxFundCap(_amountOf));
        mint(wallet, _amountOf);
    }

    function validateMaxFundCap(uint256 _totalAmount)
    view
    internal
    returns (bool)
    {
        uint maxFundCup = getDataParamsSaleDb("maxFundCup");

        if (maxFundCup > 0) {
            return maxFundCup >= totalSupply_.add(_totalAmount);
        }
        return true;
    }

}
