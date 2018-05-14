pragma solidity ^0.4.18;


//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../../doug/ownership/AllowPurchases.sol";
import {DougEnabled} from "../../../doug/safety/DougEnabled.sol";
import "./SimpleMintableToken.sol";
import {SnapshotDbInterface} from "../../commonFunctions/models/SnapshotDb.sol";


contract SaleToken is DougEnabled, SimpleMintableToken, AllowPurchases {

    using SafeMath for uint256;

    // Todo is set wallet address
    //address public walletAddress = "";

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
            if (nt.transferFrom(_sender, this, _value)) {
                // todo function library to calculate And Calculate fee
                //address _sdb = getContractAddress("SnapshotDb");
                //var (, _rate) = SnapshotDbInterface(_sdb).last();
                //require(_rate > 0);
                uint _rate = 10;

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
