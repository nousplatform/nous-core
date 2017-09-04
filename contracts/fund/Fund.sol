pragma solidity ^0.4.4;

import "./security/DougEnabled.sol";

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
    function Fund(address fundOwn, bytes32 name) {
        owner = fundOwn;
        nous = msg.sender;
    }

    /*function createComponents() onlyOwner() {
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

    }*/


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

	// clone contracts
    function clone(bytes32 name, address a) onlyOwner returns(address) {
        /*
        Assembly of the code that we want to use as init-code in the new contract,
        along with stack values:
                        # bottom [ STACK ] top
         PUSH1 00       # [ 0 ]
         DUP1           # [ 0, 0 ]
         PUSH20
         <address>      # [0,0, address]
         DUP1       # [0,0, address ,address]
         EXTCODESIZE    # [0,0, address, size ]
         DUP1           # [0,0, address, size, size]
         SWAP4          # [ size, 0, address, size, 0]
         DUP1           # [ size, 0, address ,size, 0,0]
         SWAP2          # [ size, 0, address, 0, 0, size]
         SWAP3          # [ size, 0, size, 0, 0, address]
         EXTCODECOPY    # [ size, 0]
         RETURN

        The code above weighs in at 33 bytes, which is _just_ above fitting into a uint.
        So a modified version is used, where the initial PUSH1 00 is replaced by `PC`.
        This is one byte smaller, and also a bit cheaper Wbase instead of Wverylow. It only costs 2 gas.

         PC             # [ 0 ]
         DUP1           # [ 0, 0 ]
         PUSH20
         <address>      # [0,0, address]
         DUP1       # [0,0, address ,address]
         EXTCODESIZE    # [0,0, address, size ]
         DUP1           # [0,0, address, size, size]
         SWAP4          # [ size, 0, address, size, 0]
         DUP1           # [ size, 0, address ,size, 0,0]
         SWAP2          # [ size, 0, address, 0, 0, size]
         SWAP3          # [ size, 0, size, 0, 0, address]
         EXTCODECOPY    # [ size, 0]
         RETURN

        The opcodes are:
        58 80 73 <address> 80 3b 80 93 80 91 92 3c F3
        We get <address> in there by OR:ing the upshifted address into the 0-filled space.
          5880730000000000000000000000000000000000000000803b80938091923cF3
         +000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000000
         -----------------------------------------------------------------
          588073xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx00000803b80938091923cF3

        This is simply stored at memory position 0, and create is invoked.

        */
        address retval;
        assembly{
            mstore(0x0, or (0x5880730000000000000000000000000000000000000000803b80938091923cF3 ,mul(a,0x1000000000000000000)))
            retval := create(0,0, 32)
        }
        contracts[name] = retval;
        return retval;
    }


}