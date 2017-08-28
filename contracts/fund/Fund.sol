pragma solidity ^0.4.4;

import "./security/DougEnabled.sol";
import "./FundManager.sol";
import "./components/Permissions.sol";
import "./models/PermissionsDb.sol";
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
		//permission
    	address addrPermissions = address(new Permissions());
		addContract('perms', addrPermissions);

		address addrPermissionsDB = address(new PermissionsDb());
		addContract('permsdb', addrPermissionsDB);

		// fund manager
		address addrFundManager = address(new FundManager(owner, nous));
		contracts['fundManager'] = addrFundManager;

		FundManager(contracts['fundManager']).constructSetPermission();

		//manager db
		address addrManagers = address(new Managers());
		contracts['managers'] = addrManagers;

		address addrManagerDb = address(new ManagerDb());
		contracts['managerdb'] = addrManagerDb;

		//wallets
		address addrWallets = address(new Wallets());
		contracts['wallets'] = addrWallets;

		address addrWalletsDb = address(new WalletsDb());
		contracts['walletsdb'] = addrWalletsDb;

    }

    function createSecondComponents() onlyOwner() {


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


}