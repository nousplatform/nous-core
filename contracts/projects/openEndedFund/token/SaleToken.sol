pragma solidity ^0.4.18;


//import "./SimpleMintableToken.sol";
//import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../../doug/ownership/AllowPurchases.sol";
import "../../../doug/safety/DougEnabled.sol";
import {SnapshotDbInterface as SnapshotDb} from "../../commonFunctions/models/SnapshotDb.sol";
import "./SimpleMintableToken.sol";


contract SaleToken is SimpleMintableToken, AllowPurchases, DougEnabled {

    using SafeMath for uint256;

    /**
    * Get notify in token contracts, only nous token
    * @param _sender Sender coins
    * @param _value The max amount they can spend
    */
    function receiveApproval(address _sender, uint256 _value) public onlyAllowPurchases returns (bool) {

        require(_sender != 0x0);
        require(_value > 0);

        ERC20 nt = ERC20(subOwner); //_tknAddress
        uint256 _amount = nt.allowance(_sender, this);

        // how many coins we are allowed to spend
        if (_amount >= _value) {
            if (nt.transferFrom(_sender, this, _value)) {
                // todo function library to calculate And Calculate fee
                address _sdb = getContractAddress("SnapshotDb");
                var (, _rate) = SnapshotDb(_sdb).last();
                require(_rate > 0);

                uint256 _totalAmount = _value.mul(_rate);

                // mining token
                mint(_sender, _totalAmount);

                // send nous token to wallet
                nt.transfer(walletAddress, _value);
                return true;
            }
        }
        return false;
    }

}
