pragma solidity ^0.4.18;

import "./base/DougEnabled.sol";
import "./interfaces/Construct.sol";
import "../token/ERC20.sol";
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

        contracts['fund_tokens'] =  new FundToken(_tokenName, _tokenSymbol, _initialSupply);
        contracts['nous_token_address'] = 0xc0f09168046c43a64d59dd78bbd503d8f2e9a71d;

        allowAddContract = true;
    }

    //@dev
    /*function bayShares(address _to, uint256 _value) public returns(bool) {
        require (msg.sender == contracts['fund_manager']);
        return ERC20(contracts["fund_tokens"]).transfer(_to, _value);
    }*/

    /**
     * Add a new contract to Doug. This will overwrite an existing contract.
     *
     */
    function addContract(bytes32 _name, address _addr) public returns (bool result) {
    	if (msg.sender != nous && allowAddContract == false){
			return false;
    	}

    	//_addr.call(bytes4(keccak256("constructor()"))); // конструктор срабатывает
        //_addr.call("setDougAddress", address(this));

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