pragma solidity ^0.4.4;

import "./security/DougEnabled.sol";
import "./interfaces/Construct.sol";
import "../../node_modules/zeppelin-solidity/contracts/token/ERC20.sol";

// The Doug contract.
contract Fund {

    address owner;

    address nous;

    bool allowAddContract;

    bytes32 public fundName;



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

    // Construct
    function Fund(address fundOwn, bytes32 name) {
        owner = fundOwn;
        nous = msg.sender;
        allowAddContract = true;
    }

    /*function createComponents() onlyOwner() {
    	//ToDo поставить проверку
		//permission
    	address addrPermissions = address(new Permissions());
		addContract('perms', addrPermissions);

		address addrPermissionDb = address(new PermissionDb());
		addContract('permsdb', addrPermissionDb);

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

		address addrWalletDb = address(new WalletDb());
		contracts['walletsdb'] = addrWalletDb;

    }*/

    /**
	 * Get notify in token contracts, only nous token
	 *
	 * @param _from Sender coins
	 * @param _value The max amount they can spend
	 * @param _tkn_address Address token contract, where did the money come from
	 * @param _extraData SomeExtra Information
	 */
	function receiveApproval(address _from, uint256 _value, address _tkn_address, bytes _extraData) returns (bool) {
		if (_from == 0x0 || _tkn_address == 0x0 || _value > 0){
			return false;
		}

		ERC20 tkn = ERC20(_tkn_address);
		uint256 amount = tkn.allowance(_from, this); // how many coins we are allowed to spend
		if (amount >= _value) {
			if (tkn.transferFrom(_from, this, _value)) {

			}
		}
	}

    /**
     * Add a new contract to Doug. This will overwrite an existing contract.
     *
     */
    function addContract(bytes32 _name, address _addr) returns (bool result) {
    	if (msg.sender != nous || allowAddContract == false){
			return false;
    	}

    	//addr.call(bytes4(keccak256("constructor()"))); // конструктор срабатывает

        DougEnabled de = DougEnabled(_addr);
        // Don't add the contract if this does not work.
        if(!de.setDougAddress(address(this))) {
            return false;
        }
        contracts[_name] = _addr;

        Construct(_addr).construct(owner, nous);

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