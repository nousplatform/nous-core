pragma solidity ^0.4.18;


//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
//import "../../../doug/safety/DougEnabled.sol";
//import "../../../doug/ownership/AllowPurchases.sol";
import "../../../projects/commonFunctions/models/SnapshotDb.sol";
import "./SaleToken.sol";


contract PurchaseToken is BurnableToken, SaleToken /*DougEnabled, AllowPurchases*/ {

    using SafeMath for uint256;

    address public wallet;

    constructor(address _wallet) public {
        wallet = _wallet;
    }

    function burn(uint256 _value) public {
        revert();
    }

    // @dev withdraw Token
    function withdrawToken(address _withdrawAddr, uint256 _value) public returns(bool) {
        require(allowPurchases[_withdrawAddr]);
        require(_value <= balances[msg.sender]);

        address _sdb = getContractAddress("SnapshotDb");
        var (, _rate) = SnapshotDb(_sdb).last();
        require(_rate > 0);

        uint256 _totalAmount = _value.div(_rate);
        //address _withdrawAddr = getAddressForWithdraw(0);

        bool res = ERC20Basic(_withdrawAddr).transfer(msg.sender, _totalAmount);
        require(res, "Transfer error");

        _burn(msg.sender, _value);
    }

    function withdrawWallet(address _withdrawAddr, uint _value) {
        require(msg.sender == wallet);
        require(allowPurchases[_withdrawAddr]);

        bool res = ERC20Basic(_withdrawAddr).transfer(msg.sender, _value);
        require(res, "Transfer error");
    }
}
