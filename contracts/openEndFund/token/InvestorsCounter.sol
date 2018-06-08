pragma solidity ^0.4.18;


import {StandardToken} from "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";
import {PurchaseToken} from "./PurchaseToken.sol";


//counter investor
contract InvestorsCounter is StandardToken, SimpleMintableToken, PurchaseToken {

    mapping(address => bool) public investors;
    uint256 public totalInvestors;

    function subtractInvestor(address _addr) private {
        if (balances[_addr] == 0) {
            investors[_addr] = false;
            totalInvestors--;
        }
    }

    function addInvestor(address _addr) private {
        if (investors[_addr] == false) {
            investors[_addr] = true;
            totalInvestors++;
        }
    }

    // @dev Override mint function
    function mint(address _to, uint256 _amount)
    internal
    returns (bool)
    {
        addInvestor(_to);
        return super.mint(_to, _amount);
    }

    // @dev Override transfer from function
    function transferFrom(address _from, address _to, uint256 _value)
    public
    returns(bool)
    {
        subtractInvestor(_from);
        addInvestor(_to);
        return super.transferFrom(_from, _to, _value);
    }

    // @dev Override transfer function
    function transfer(address _to, uint256 _value)
    public
    returns (bool)
    {
        subtractInvestor(msg.sender);
        addInvestor(_to);
        return super.transfer(_to, _value);
    }

    function afterRedeem()
    internal
    {
        subtractInvestor(msg.sender);
    }

}
