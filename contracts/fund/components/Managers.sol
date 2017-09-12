pragma solidity ^0.4.0;

import "../interfaces/ContractProvider.sol";
import "../models/ManagerDb.sol";
import "../security/FundManagerEnabled.sol";
import "../interfaces/Construct.sol";

contract Managers is FundManagerEnabled, Construct  {

    function addManager(
    	address managerAddress,
		bytes32 firstName,
		bytes32 lastName,
		bytes32 email
	) returns (bool) {
		if (!isFundManager()){
			return false;
		}
		address managerdb = ContractProvider(DOUG).contracts("managerdb");

		if ( managerdb == 0x0 ) {
			return false;
		}
		return ManagerDb(managerdb).insertManager(managerAddress, firstName, lastName, email);
    }

    function delManager(address managerAddress) returns (bool){
    	if (!isFundManager()){
			return false;
		}
		address managerdb = ContractProvider(DOUG).contracts("managerdb");

		if ( managerdb == 0x0 ) {
			return false;
		}
		return  ManagerDb(managerdb).deleteManager(managerAddress);
    }

}
