pragma solidity ^0.4.18;


import {StandardToken} from "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import {SaleToken} from "./SaleToken.sol";
import {PurchaseToken} from "./PurchaseToken.sol";


//counter investor
contract InvestorsCounter is StandardToken, SaleToken, PurchaseToken {

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

    function afterSale(
        address _tokenProvider,
        uint256 _amountProviderWithFee,
        address _spender
    )
    internal
    {
        addInvestor(_spender);
        super.afterSale(_tokenProvider, _amountProviderWithFee, _spender);
    }

    function afterRedeem(
        address _tokenProvider,
        uint256 _amountProviderWithFee,
        address _spender
    )
    internal
    {
        subtractInvestor(_spender);
        super.afterRedeem(_tokenProvider, _amountProviderWithFee, _spender);
    }


}
