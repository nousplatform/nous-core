pragma solidity ^0.4.18;


//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";
import "../models/OpenEndedSaleDb.sol";


contract PurchaseToken is BurnableToken, BaseSaleOpenEnded {

    using SafeMath for uint256;

    event Redeem(address indexed from, address indexed to, uint256 value);
    event Withdraw(address indexed from, address indexed to, uint256 value);

    function burn(uint256 _value) public {
        revert();
    }

    // @dev withdraw Token
    function redeem(address _withdrawAddr, uint256 _value) public returns(bool) {
        require(allowPurchases[_withdrawAddr]);
        require(_value <= balances[msg.sender]);

        uint _rate = getRate();
        uint256 _totalAmount = _value.div(_rate);

        uint _exitFee = getDataParamsSaleDb("exitFee");
        uint _amountFee = _totalAmount.mul(_exitFee).div(100);
        _totalAmount = _totalAmount.sub(_amountFee);

        //_withdraw token
        bool res1 = ERC20(_withdrawAddr).transfer(msg.sender, _totalAmount);
        require(res1, "Transfer error");

        emit Redeem(msg.sender, _withdrawAddr, _totalAmount);

        //fee token
        bool res2 = ERC20(_withdrawAddr).transfer(wallet, _amountFee);
        require(res2, "Transfer exit fee error");

        _burn(msg.sender, _value);
    }

    function withdraw(address _withdrawAddr, uint _value) {
        require(msg.sender == wallet);
        require(allowPurchases[_withdrawAddr]);

        bool res = ERC20(_withdrawAddr).transfer(msg.sender, _value);
        require(res, "Transfer error");
        emit Withdraw(this, msg.sender, _value);
    }
}
