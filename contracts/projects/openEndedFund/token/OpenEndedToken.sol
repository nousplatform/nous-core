pragma solidity ^0.4.18;


//import "../../../doug/safety/Validee.sol";
import "./InvestorsCounter.sol";
import "./PurchaseToken.sol";
//import "./SaleToken.sol";


/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract OpenEndedToken is PurchaseToken, InvestorsCounter /*SaleToken,*/ {

    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;

    // @dev Constructor only nous token can mint.
    constructor(address _owner, address _nousToken, string _name, string _symbol /*, uint8 _decimals*/)
    AllowPurchases(_nousToken)
    PurchaseToken(_owner)
    {
        name = _name;
        symbol = _symbol;
        decimals = 18;

        //paused = true;
        //addAddressToAllowPurchases(_nousToken);
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

    function _burn(address _who, uint256 _value) internal {
        super._burn(msg.sender, _value);
        if (balances[msg.sender] == 0) {
            removeInvestor(msg.sender);
        }
    }

}
