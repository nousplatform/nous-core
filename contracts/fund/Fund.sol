pragma solidity ^0.4.18;


import "./base/DougEnabled.sol";
import "./base/Construct.sol";
import "../token/ERC20.sol";
import "../FundToken.sol";
import "./base/OwnableFunds.sol";
import "./interfaces/Construct.sol";


// The Doug contract.
contract Fund is OwnableFunds, Construct {

    string public fondName;

    //uint256 public rate;

    bool public allowAddContract;
    bool private construct = false;

    // all data
    mapping (bytes32 => address) public fundData;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    // This is token
    mapping (bytes32 => address) public tokens;

    modifier onlyOwner {//a modifier to reduce code replication
        require(msg.sender == owner); // this ensures that only the owner can access the function
        _;
    }

    modifier onlyNousPlatform() {
        require(msg.sender == nous);
        _;
    }

    modifier allowedUpdateContracts() {
        require(allowAddContract == true);
        _;
    }

    function constructor(address _fundOwn, bytes32 _tokenSymbol, address _nousTokenAddress, string _fundName) onConstructor external {
        super.constructor();

        allowAddContract = true;
        owner = _fundOwn;
        nous = msg.sender;
        fondName = _fundName;
        addToken(_tokenSymbol, _nousTokenAddress);
    }

    function addToken(bytes32 _tokenSymbol, address _tokenAddress) public onlyNousPlatform {
        contracts[_tokenSymbol] = _tokenAddress;
    }

    //todo get contacts test
    function getContract(bytes32 name) public constant returns (address) {
        return contracts[name];
    }

    /**
     * Add a new contract to Doug. This will overwrite an existing contract.
     * @dev _addr.call(bytes4(keccak256("constructor()"))); // конструктор срабатывает
     * @dev _addr.call("setDougAddress", address(this));
     */
    function addContract(bytes32 _name, address _addr) public onlyNousPlatform allowedUpdateContracts returns(bool) {
        DougEnabled de = DougEnabled(_addr);
        if (!de.setDougAddress(this)) {
            return false;
        }
        contracts[_name] = _addr;
        Construct(_addr).construct(owner, nous);
        return true;
    }

    /**
    * Update address Contract
    */
    function updateDougContract(bytes32 _name, address _addr) public onlyNousContract {
        contracts[_name] = _addr;
    }

    // Remove a contract from Doug. We could also selfdestruct if we want to.
    function removeContract(bytes32 name) public onlyOwner returns (bool result) {
        if (contracts[name] == 0x0) {
            return false;
        }
        contracts[name] = 0x0;
        return true;
    }

}
