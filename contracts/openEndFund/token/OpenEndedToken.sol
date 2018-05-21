pragma solidity ^0.4.18;


import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "./InvestorsCounter.sol";
import {PurchaseToken} from "./PurchaseToken.sol";
import {SaleToken} from "./SaleToken.sol";
import {AllowPurchases} from "../../doug/ownership/AllowPurchases.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";

//"0x719a22e179bb49a4596efe3bd6f735b8f3b00af1","0x2d968cf3d354c891081610b65e0b83d5073a82e3", "BWT3", "BWTTTT"
/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract OpenEndedToken is /*AllowPurchases, */PurchaseToken, SaleToken, InvestorsCounter {

    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;

    // @dev Constructor only nous token can mint.
    constructor(
        address _owner,
        address _nousToken,
        string _name,
        string _symbol
    )
    public
    BaseSaleOpenEnded(_owner)
    AllowPurchases(_nousToken)
    {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }

    function mint(address _to, uint256 _amount) internal returns (bool) {
        super.mint(_to, _amount);
        addInvestor(_to);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        super.transferFrom(_from, _to, _value);
        if (balances[msg.sender] == 0) {
            removeInvestor(_from);
        }
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        super.transfer(_to, _value);
        if (balances[msg.sender] == 0) {
            removeInvestor(msg.sender);
        }
        return true;
    }

    function _burn(
        address _who,
        uint256 _value
    )
    internal
    {
        super._burn(_who, _value);
        if (balances[_who] == 0) {
            removeInvestor(_who);
        }
    }

}