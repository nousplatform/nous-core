pragma solidity ^0.4.18;


import {OpenEndedToken} from "./OpenEndedToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";


contract PurchaseToken is OpenEndedToken, BurnableToken {

    using SafeMath for uint256;

    uint rate = 1;
    address NSU = 0x0;

    // @dev withdraw Token
    function withdrawToken(uint256 _value) public returns(bool) {
        require(_value <= balances[msg.sender]);
        uint256 _amount = _value.mul(rate);
        bool res = ERC20Basic(NSU).transfer(msg.sender, _amount);
        if (!res) {
            revert("transfer error");
        }
        burn(_value);
    }
}
