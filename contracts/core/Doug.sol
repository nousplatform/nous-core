pragma solidity ^0.4.10;

import "./models/DougDB.sol";
import "./models/ActionDB.sol";
import "./security/DougEnabled.sol";
import './interfaces/ActionDbase.sol';


contract Doug is DougDB {

    address owner;

    // When adding a contract.
    event AddContract(address indexed caller, bytes32 indexed name, uint16 indexed code);
    // When removing a contract.
    event RemoveContract(address indexed caller, bytes32 indexed name, uint16 indexed code);

    modifier onlyOwner(){
		if(msg.sender != contractOwner ){
			throw;
		}
		_;
	}

    // Constructor
    function Doug(){
        owner = msg.sender;
    }

    //todo test function
    function testAddContract(address addr) constant returns (bool){
        return DougEnabled(addr).setDougAddress(address(this));
    }

    function addContract(bytes32 name, address addr)  onlyOwner() returns (bool result) {
        // Only the owner may add, and the contract has to be DougEnabled and
        // return true when setting the Doug address.

        if(!DougEnabled(addr).setDougAddress(address(this))){
          // Access denied. Should divide these up into two maybe.
          AddContract(msg.sender, name, 403);
          return false;
        }

        // Add to contract.
        bool ae = _addElement(name, addr);

        if (ae) {
          AddContract(msg.sender, name, 201);
        } else {
          // Can't overwrite.
          AddContract(msg.sender, name, 409);
        }
        return ae;
    }

		//TODO comments
    function setActionDB(address addr) onlyOwner() returns (bool){

		ActionDB ad = ActionDB(addr);

		bool ae = false;
		bool res = ad.setDougAddress(address(this));
		return res;

		if (res){
			ae = _addElement('actiondb', addr);
		}

		if (ae){
			AddContract(msg.sender, 'actiondb', 200);
			return true;
		}

		AddContract(msg.sender, 'actiondb', 410);
		return false;
	}

    function removeContract(bytes32 name) returns (bool result) {
        if(msg.sender != owner){
            RemoveContract(msg.sender, name, 403);
            return false;
        }
        bool re = _removeElement(name);
        if(re){
          RemoveContract(msg.sender, name, 200);
        } else {
          // Can't remove, it's already gone.
          RemoveContract(msg.sender, name, 410);
        }
        return re;
    }


    function contracts(bytes32 name) returns (address addr){
      return list[name].contractAddress;
    }

    /// @notice Remove (selfdestruct) Doug.
    function remove() onlyOwner(){
   		selfdestruct(owner);
    }

}
