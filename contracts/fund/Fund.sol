pragma solidity ^0.4.4;

import "./base/DougEnabled.sol";
import "./interfaces/Construct.sol";
//import "../token/ERC20.sol";
import "../token/FundToken.sol";

// The Doug contract.
contract Fund {

    address public owner;

    address public nous;

    string public fondName;

    bool allowAddContract;

    // all data
    mapping (bytes32 => address) public fundData;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    modifier onlyOwner { //a modifier to reduce code replication
        if (msg.sender == owner) // this ensures that only the owner can access the function
            _;
    }

    //todo get contacts test
    function getContracts(bytes32 name) public constant returns (address) {
    	return contracts[name];
    }

    // Construct
    function Fund(address _fundOwn, string _fundName, string _tokenName, string _tokenSymbol, uint256 _initialSupply) public {
        owner = _fundOwn;
        nous = msg.sender;
        fondName = _fundName;

        contracts['fundTokens'] =  new FundToken(_tokenName, _tokenSymbol, _initialSupply);
        contracts['nousTokenAddress'] = 0x6Ff4Ac67c80778ad42Ac747b3B89B9EfB4d5BE7B;

        allowAddContract = true;
    }

    /**
	 * Get notify in token contracts, only nous token
	 *
	 * @param _from Sender coins
	 * @param _value The max amount they can spend
	 * @param _tkn_address Address token contract, where did the money come from
	 * @param _extraData SomeExtra Information
	 */
	function receiveApproval(address _from, uint256 _value, address _tkn_address, bytes _extraData) external returns (bool) {
		if (_from == 0x0 || _tkn_address != contracts['nousTokenAddress'] || _value > 0) {
			return false;
		}
        FundToken tkn = FundToken(_tkn_address);
		uint256 amount = tkn.allowance(_from, this); // how many coins we are allowed to spend
		if (amount >= _value) {
			if (tkn.transferFrom(_from, this, _value)) {
                tkn.transfer(_from, _value);
			}
		}
	}

    /**
     * Add a new contract to Doug. This will overwrite an existing contract.
     *
     */
    function addContract(bytes32 _name, address _addr) public returns (bool result) {
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
    function removeContract(bytes32 name) public onlyOwner returns (bool result) {
        if (contracts[name] == 0x0){
            return false;
        }
        contracts[name] = 0x0;
        return true;
    }

}