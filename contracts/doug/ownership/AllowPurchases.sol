pragma solidity ^0.4.21;


import {Validee} from "../safety/Validee.sol";

/**
 * @title AllowPurchases
 * @dev The AllowPurchases contract has a whitelist of addresses, and provides basic authorization control functions.
 * @dev This simplifies the implementation of "user permissions".
 */
contract AllowPurchases is Validee {
  mapping(address => bool) public allowPurchases;

  address[] allowPurchasesIndex;

  event AllowPurchasesAddressAdded(address addr);
  event AllowPurchasesAddressRemoved(address addr);

  /**
   * @dev Throws if called by any account that's not whitelisted.
   */
  modifier onlyAllowPurchases() {
    require(allowPurchases[msg.sender]);
    _;
  }

  constructor(address _addr)
  public
  {
    allowPurchases[_addr] = true;
  }

  /**
   * @dev add an address to the whitelist
   * @param _addr address
   * @return success true if the address was added to the whitelist, false if the address was already in the whitelist
   */
  function addAddressToAllowPurchases(address _addr)  public returns(bool success) {
    require(validate());
    if (!allowPurchases[_addr]) {
      allowPurchases[_addr] = true;
      allowPurchasesIndex.push(_addr);
      emit AllowPurchasesAddressAdded(_addr);
      success = true;
    }
  }

  /**
   * @dev add addresses to the whitelist
   * @param addrs addresses
   * @return success true if at least one address was added to the whitelist,
   * false if all addresses were already in the whitelist
   */
  function addAddressesToAllowPurchases(address[] addrs) public returns(bool success) {
    require(validate());
    for (uint256 i = 0; i < addrs.length; i++) {
      if (addAddressToAllowPurchases(addrs[i])) {
        success = true;
      }
    }
  }

  /**
   * @dev remove an address from the whitelist
   * @param addr address
   * @return success true if the address was removed from the whitelist,
   * false if the address wasn't in the whitelist in the first place
   */
  function removeAddressFromAllowPurchases(address addr) public returns(bool success) {
    require(validate());
    if (allowPurchases[addr]) {
      for (uint i = 0; i < allowPurchasesIndex.length; i++) {
        if (addr == allowPurchasesIndex[i]) break;
      }
      // first element not deleted
      if (i > 0) {
        allowPurchases[addr] = false;
        address lastAddr = allowPurchasesIndex[allowPurchasesIndex.length - 1];
        allowPurchasesIndex[i] = lastAddr;
        emit AllowPurchasesAddressRemoved(addr);
        return true;
      }
      return false;
    }
  }

  function getAddressForWithdraw(uint _index) public view returns(address) {
    return allowPurchasesIndex[_index];
  }


}
