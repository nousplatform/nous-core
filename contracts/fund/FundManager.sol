pragma solidity ^0.4.4;

import "./interfaces/ContractProvider.sol";
import "./security/DougEnabled.sol";
import "./models/PermissionsDb.sol";
import "./components/Permissions.sol";
//import "./components/Bank.sol";
import "./components/Managers.sol";

// The fund manager
contract FundManager is DougEnabled {

    // We still want an owner.
    address owner;
    address nous;

    // Constructor
    function FundManager(address foundOwner, address nousaddress){
		owner = foundOwner;
		nous = nousaddress;

		setDougAddress(msg.sender);

		setPermission(nous, 4);
		setPermission(owner, 3);
    }

    function addManager(
		address managerAddress,
		bytes32 firstName,
		bytes32 lastName,
		bytes32 email
	) returns (bool) {
		address managers = ContractProvider(DOUG).contracts("managers");
		address permsdb = ContractProvider(DOUG).contracts("permsdb");
		if ( managers == 0x0 || permsdb == 0x0 || PermissionsDb(permsdb).perms(msg.sender) == 3 ) {

			return false;
		}
		bool success = Managers(managers).addManager(managerAddress, firstName, lastName, email);
		setPermission(managerAddress, 2);
		if (!success) {

		}
		return success;
	}

	function delManager(address managerAddr) returns (bool) {
		address managers = ContractProvider(DOUG).contracts("managers");
		address permsdb = ContractProvider(DOUG).contracts("permsdb");
		if ( managers == 0x0 || permsdb == 0x0 || PermissionsDb(permsdb).perms(msg.sender) == 3 ) {

			return false;
		}
		bool success = Managers(managers).delManager(managerAddr);
		setPermission(managerAddr, 0);
		if (!success) {

		}
		return success;
	}

	// or 2, 3 Manager and Owner
	function addWallet(){

	}

	// only 4 Nous platform
	function confirmedWallet(){

	}


	// Set the permissions for a given address.
	function setPermission(address addr, uint8 permLvl) returns (bool res) {

		if ( msg.sender == owner || DOUG == msg.sender ){

			address permsdb = ContractProvider(DOUG).contracts("permsdb");
			uint8 perission = PermissionsDb(permsdb).perms(addr);

			if (perission < 3){
				address perms = ContractProvider(DOUG).contracts("perms");
				if ( perms == 0x0 ) {
					return false;
				}
				return Permissions(perms).setPermission(addr, permLvl);
			}
		}
		return false;
	}


}