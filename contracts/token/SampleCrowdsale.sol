pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";


/**
 * @title SampleCrowdsaleToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract SampleCrowdsaleToken is MintableToken, PausableToken {

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

}
