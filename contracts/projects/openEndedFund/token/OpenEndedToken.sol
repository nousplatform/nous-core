pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
//import "../base/Construct.sol";
import "../sales/Sale.sol";
import "./InvestorsCounter.sol";

//import "../base/DougEnabled.sol";


/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract OpenEndedToken is MintableToken, PausableToken, InvestorsCounter {

    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;

    function OpenEndedToken(string _name, string _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        paused = true;
    }

    function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
        super.mint(_to, _amount);
        addInvestor(_to);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        super.transferFrom(_from, _to, _value);
        if (balanceOf(_from) == 0) {
            removeInvestor(_from);
        }
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        super.transfer(_to, _value);
        if (balanceOf(msg.sender) == 0) {
            removeInvestor(msg.sender);
        }
        return true;
    }

    // after finish mining auto paused
    function finishMinting() public onlyOwner canMint returns (bool) {
        super.finishMinting();
        paused = true;
        return true;
    }

    /**
    * @dev Not paused token after ended mining
    */
    function pause() public onlyOwner whenNotPaused {
        require(mintingFinished == false);
        super.pause();
    }



}
