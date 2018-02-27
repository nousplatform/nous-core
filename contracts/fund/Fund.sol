pragma solidity ^0.4.18;


import "./base/DougEnabled.sol";
import "./interfaces/Construct.sol";
import "../token/ERC20.sol";
import "../FundToken.sol";
import "./base/OwnableFunds.sol";


// The Doug contract.
contract Fund is OwnableFunds {

    string public fondName;

    uint256 public rate;

    bool public allowAddContract;

    struct Tokens {
        address addr;
        string name;
        string symbol;
        uint256 rate;
    }

    // all data
    mapping (bytes32 => address) public fundData;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) public contracts;

    modifier onlyOwner {//a modifier to reduce code replication
        require(msg.sender == owner); // this ensures that only the owner can access the function
        _;
    }

    modifier onlyNousContract() {
        require(msg.sender == nous);
        require(allowAddContract == true);
        _;
    }

    // Construct
    function Fund(address _fundOwn, address _nousTokenAddress, string _fundName, address _tokenAddress, bytes32 _tokenSymbol, uint256 _rate)
    public {
        owner = _fundOwn;
        nous = msg.sender;
        fondName = _fundName;
        rate = _rate;

        addToken(_tokenSymbol, _tokenAddress);
        contracts["nous_token_address"] = _nousTokenAddress;

        allowAddContract = true;
    }

    function addToken(bytes32 _tokenSymbol, address _tokenAddress) public onlyNousContract {
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
    function addContract(bytes32 _name, address _addr) public onlyNousContract returns(bool) {
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
