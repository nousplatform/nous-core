pragma solidity ^0.4.4;

/**
* Found Manager
* This components check user permission and coll actions on components
* Permission: (Nous platform = 4, Owner Fund = 3, Manager = 2, Investor = 1, No permission = 0 )
*
*/


import "./security/DougEnabled.sol";
import "./interfaces/ContractProvider.sol";
import "./interfaces/PermissionProvider.sol";

//import "./models/PermissionDb.sol";
//import "./components/Permissions.sol";

import "./components/Managers.sol";
import "./components/Wallets.sol";
import "./interfaces/Construct.sol";


// The fund manager
contract FundManager is DougEnabled, Construct {

    // We still want an owner.
    address owner;
    address nous;
    address fund;

    function getDoug() constant returns (address){
    	return DOUG;
    }

    function getOwnerAddress() constant returns (address, address, address, address){
    	return (owner, msg.sender, nous, fund);
    }


    function construct(address foundOwner, address nousaddress){
    	if (isCall) revert();
		//TODO ONLY FIRST START
    	owner = foundOwner;
        nous = nousaddress;
        fund = msg.sender;

        setPermission(nous, 4);
        setPermission(fund, 3);
        setPermission(owner, 3);

        isCall = true; // disabled constructor
    }


    function checkPermission(bytes32 role) returns (bool) {

    	address permsdb = ContractProvider(DOUG).contracts("permissiondb");
    	if ( permsdb != 0x0 ){
    		PermissionProvider permComp = PermissionProvider(permsdb);
    		return permComp.getUserPerm(msg.sender) == permComp.getRolePerm(role);
    	}
    	return false;
    }

    // Set the permissions for a given address.
	function setPermission(address addr, uint8 permLvl) returns (bool res) {
		if (msg.sender != owner && msg.sender != fund) {
			return false;
		}

		address perms = ContractProvider(DOUG).contracts("permissions");
		if ( perms == 0x0 ) {
			return false;
		}

		return PermissionProvider(perms).setPermission(addr, permLvl);
	}

	function getRole(bytes32 role) constant returns (uint8, uint8){
		address permsdb = ContractProvider(DOUG).contracts("permissionsdb");
		if ( permsdb != 0x0 ){
			PermissionProvider permComp = PermissionProvider(permsdb);
			return (permComp.getUserPerm(msg.sender), permComp.getRolePerm(role));
		}
		return (0, 0);
	}

	// Prmissions only owner delete or add manager
    function addManager(
		address managerAddress,
		bytes32 firstName,
		bytes32 lastName,
		bytes32 email
	) returns (bool) {
		if (!checkPermission("owner")){
			return false;
		}

		address managers = ContractProvider(DOUG).contracts("managers");
		if (managers == 0x0){
			return false;
		}

		return Managers(managers).addManager(managerAddress, firstName, lastName, email);
	}

	// public method
	function getAllManagers() constant returns (bytes32[] memory names, address[] memory addrs){
		if (!checkPermission("owner")){
			//return false;
		}

		address managersDb = ContractProvider(DOUG).contracts("managerdb");
		if (managersDb == 0x0){

		}

		var length = ManagerDb(managersDb).getManagersLength();

		names = new bytes32[](length);
		addrs = new address[](length);

		for (uint i = 0; i < length; i++){
			var (name, addr) = ManagerDb(managersDb).getManager(i);
			names[i] = name;
            addrs[i] = addr;
		}

		return (names, addrs);
	}

	function delManager(address managerAddr) returns (bool) {
		if (!checkPermission("owner")){
			return false;
		}

		address managers = ContractProvider(DOUG).contracts("managers");
		if ( managers == 0x0 ) {
			// todo: 500 not installed
			return false;
		}

		if (!Managers(managers).delManager(managerAddr)){
			return false;
		}

		return true;
	}

	/**
	* Add wallet
	*/
	function addWallet( bytes32 type_wallet, address walletAddress ) returns (bool){
		if (!checkPermission("owner") && !checkPermission("manager")) {
			return false;
		}

		address wallets = ContractProvider(DOUG).contracts("wallets");
		if ( wallets != 0x0 ){
			return false;
		}

		if (!Wallets(wallets).addWallet(type_wallet, walletAddress)){
			return false;
		}

		return true;
	}

	/**
	* Confirmed Wallet
	* confirm address wallets
	* param address walletAddress
	* can do only Nous platform
	*/
	function confirmedWallet(address walletAddress) returns (bool) {
		if (!checkPermission("nous")){
			return false;
		}

		address wallets = ContractProvider(DOUG).contracts("wallets");

		if (wallets == 0x0){
			return false;
		}

		if (!Wallets(wallets).confirmWallet(walletAddress)) {
			return false;
		}

		return true;
	}

	// Create snapshot can do only Nous platform
	function createSnapshot(address walletAddress, uint32 balance) returns (bool){
		if (!checkPermission("nous")){
			return false;
		}

		address wallets = ContractProvider(DOUG).contracts("wallets");

		if (wallets == 0x0){
			return false;
		}

		if (!Wallets(wallets).createSnapshot(walletAddress, balance)) {
			return false;
		}

		return true;
	}




}