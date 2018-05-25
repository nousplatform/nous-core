pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import {SimpleMintableToken} from "./SimpleMintableToken.sol";


//counter investor
contract InvestorsCounter is StandardToken, SimpleMintableToken {

    mapping(address => uint256) public investors;
    address[] public investorIndex;

    // @dev remove transaction
    function removeInvestor(address _addr)
    internal
    {
        if (investors[_addr] > 0) {
            uint rowToDel = investors[_addr] - 1;
            investors[_addr] = 0;
            address lastRow = investorIndex[investorIndex.length - 1];
            investorIndex[rowToDel] = lastRow;
            investorIndex.length--;
        }
    }

    // @dev Override mint function
    function mint(address _to, uint256 _amount)
    internal
    returns (bool)
    {
        if (investors[_to] == 0) {
            investors[_to] = investorIndex.push(_to);
        }
        return super.mint(_to, _amount);
    }

    // @dev Override transfer from function
    function transferFrom(address _from, address _to, uint256 _value)
    public
    returns(bool)
    {
        if (balances[_from] == 0) {
            removeInvestor(_from);
        }
        return super.transferFrom(_from, _to, _value);
    }

    // @dev Override transfer function
    function transfer(address _to, uint256 _value)
    public
    returns (bool)
    {
        if (balances[msg.sender] == 0) {
            removeInvestor(msg.sender);
        }
        return super.transfer(_to, _value);
    }

    // @dev returned all investors
    function countInvestors()
    public
    view
    returns(uint256)
    {
        return investorIndex.length;
    }
}
