pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./InvestorsCounter.sol";
import {PurchaseToken} from "./PurchaseToken.sol";
import {SaleToken} from "./SaleToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";


/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract OpenEndedToken is PurchaseToken, SaleToken, InvestorsCounter {

    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;

    // @dev Constructor only nous token can mint.
    constructor(
        address _owner,
        address _nousToken,
        string _name,
        string _symbol,
        uint8 _decimals,
        address _nousWallet
    )
    public
    BaseSaleOpenEnded(_owner)
    AllowPurchases(_nousToken)
    {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        nousWallet = _nousWallet;
    }

}
