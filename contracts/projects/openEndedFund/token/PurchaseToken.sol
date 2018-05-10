pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "../../../doug/safety/DougEnabled.sol";
import "../../../doug/ownership/AllowPurchases.sol";


contract PurchaseToken is BurnableToken, DougEnabled, AllowPurchases {

    using SafeMath for uint256;

    function burn(uint256 _value) public {
        revert();
    }

    // @dev withdraw Token
    function withdrawToken(uint256 _value) public returns(bool) {
        require(_value <= balances[msg.sender]);

        address _sdb = getContractAddress("SnapshotDb");
        var (, _rate) = SnapshotDb(_sdb).last();
        require(_rate > 0);

        uint256 _totalAmount = _value.mul(rate);
        address _withdrawAddr = getAddressForWithdraw(0);

        bool res = ERC20Basic(_withdrawAddr).transfer(msg.sender, _totalAmount);
        require(res, "Transfer error");

        _burn(msg.sender, _value);
    }
}
