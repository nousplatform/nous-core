pragma solidity ^0.4.18;


//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../../doug/ownership/AllowPurchases.sol";
import "./SimpleMintableToken.sol";

import {BaseSaleOpenEnded} from "./BaseSaleOpenEnded.sol";


contract SaleToken is SimpleMintableToken, BaseSaleOpenEnded {

    using SafeMath for uint256;

    /**
    * Get notify in token contracts, only nous token
    * @param _sender Sender coins
    * @param _value The max amount they can spend
    */
    function receiveApproval(address _sender, uint256 _value) public onlyAllowPurchases returns (bool) {

        require(_sender != 0x0);
        require(_value > 0);

        ERC20 nt = ERC20(msg.sender); //_tknAddress
        uint256 _amount = nt.allowance(_sender, this);

        // how many coins we are allowed to spend
        if (_amount >= _value) {

            uint _entryFee = getDataParamsSaleDb("entryFee");

            uint _amountFee = _value.mul(_entryFee).div(100);

            _value = _value.sub(_amountFee);

            if (nt.transferFrom(_sender, this, _value)) {
                nt.transfer(wallet, _amountFee); // transfer amount fee to wallet

                uint _rate = getRate();

                uint256 _totalAmount = _value.mul(_rate);
                // mining token
                mint(_sender, _totalAmount);

                // Todo send nous token to wallet
                //nt.transfer(walletAddress, _value);
                return true;
            }
        }
        return false;
    }

}
