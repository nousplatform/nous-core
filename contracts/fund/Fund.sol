pragma solidity ^0.4.4;

import "./security/DougEnabled.sol";
import "./FundManager.sol";
import "./security/FundManagerEnabled.sol";

// The Doug contract.
contract Fund {

    address owner;

    address nous;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    modifier onlyOwner { //a modifier to reduce code replication
        if (msg.sender == owner) // this ensures that only the owner can access the function
            _;
    }

    //todo get contacts test
    function getContracts(bytes32 name) constant returns (address) {
    	return contracts[name];
    }

    // Constructor
    function Fund(address foundOwner, bytes32 name) {
        owner = foundOwner;
        nous = msg.sender;
    }

    function createComponents() onlyOwner() {
    	//ToDo поставить проверку

    	address addrPermissions = address(new Permissions());
		addContract('perms', addrPermissions);

		address addrPermissionsDB = address(new PermissionsDb());
		addContract('permsdb', addrPermissionsDB);

		address addrFundManager = address(new FundManager(owner, nous));
		contracts['fundManager'] = addrFundManager;

    	address addrManagers = address(new Managers());
		contracts['managers'] = addrManagers;

		address addrManagerDb = address(new ManagerDb());
		contracts['managerdb'] = addrManagerDb;
    }


    // Add a new contract to Doug. This will overwrite an existing contract.
    function addContract(bytes32 name, address addr) onlyOwner returns (bool result) {
        DougEnabled de = DougEnabled(addr);
        // Don't add the contract if this does not work.
        if(!de.setDougAddress(address(this))) {
            return false;
        }
        contracts[name] = addr;
        return true;
    }

    // Remove a contract from Doug. We could also selfdestruct if we want to.
    function removeContract(bytes32 name) onlyOwner returns (bool result) {
        if (contracts[name] == 0x0){
            return false;
        }
        contracts[name] = 0x0;
        return true;
    }

    function remove() onlyOwner {
        address fm = contracts["fundmanager"];
        address perms = contracts["perms"];
        address permsdb = contracts["permsdb"];
        address bank = contracts["bank"];
        address bankdb = contracts["bankdb"];

        // Remove everything.
        if(fm != 0x0){ DougEnabled(fm).remove(); }
        if(perms != 0x0){ DougEnabled(perms).remove(); }
        if(permsdb != 0x0){ DougEnabled(permsdb).remove(); }
        if(bank != 0x0){ DougEnabled(bank).remove(); }
        if(bankdb != 0x0){ DougEnabled(bankdb).remove(); }

        // Finally, remove doug. Doug will now have all the funds of the other contracts,
        // and when suiciding it will all go to the owner.
        selfdestruct(owner);
    }

}