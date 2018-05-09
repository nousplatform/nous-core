pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../../../doug/safety/Validee.sol";


contract SaleToken is MintableToken, Validee {

    using SafeMath for uint256;

    uint rate = 1;
    address nousToken = 0x0;

    /**
    * Get notify in token contracts, only nous token
    * @param _sender Sender coins
    * @param _value The max amount they can spend
    */
    function receiveApproval(address _sender, uint256 _value) public returns (bool) {

        require(_sender != 0x0 && msg.sender == nousToken);

        address nousToken = getContract("NousToken");
        ERC20 nt = ERC20(nousToken); //_tknAddress
        uint256 _amount = nt.allowance(_sender, this);

        // how many coins we are allowed to spend
        if (_amount >= _value) {
            if (nt.transferFrom(_sender, this, _value)) {
                // todo function library to calculate And Calculate fee
                uint256 _totalAmount = _value.mul(rate); //getRate(_value, rate);

                // todo validate totalSupplyCap if is exists to contract

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
