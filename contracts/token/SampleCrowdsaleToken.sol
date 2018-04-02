pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol"; //
import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
//import "../base/Construct.sol";
import "../sales/Sale.sol";
import "./InvestorsCounter.sol";


/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract SampleCrowdsaleToken is MintableToken, PausableToken, InvestorsCounter {

    bool private constructorCall = false;
    string public name;
    string public symbol;
    uint8 public decimals;

    function SampleCrowdsaleToken(address _owner, string _name, string _symbol, uint8 _decimals) {
        owner = _owner;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        paused = true;
    }

    function finishMinting() public onlyOwner canMint returns (bool) {
        super.finishMinting();
        paused = true;
        return true;
    }

    /**
    * @dev paused only if minting true
    */
    function pause() public onlyOwner whenNotPaused {
        require(mintingFinished == false);
        super.pause();
    }

    function mint(address _to, uint256 _amount) public onlyOwner canMint  returns (bool) {
        super.mint(_to, _amount);
        investorsCheck(0x0, _to);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        super.transferFrom(_from, _to, _value);
        investorsCheck(_from, _to);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        super.transfer(_to, _value);
        investorsCheck(msg.sender, _to);
        return true;
    }

}
