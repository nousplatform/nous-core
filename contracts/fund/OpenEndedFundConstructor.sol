pragma solidity ^0.4.18;


import "./models/DougDb.sol";
import "./models/ICODb.sol";
import "./base/DougEnabled.sol";
import "./base/OwnableFunds.sol";


// The Doug contract.
contract OpenEndedFundConstructor is OwnableFunds, DougDb, ICODb {

    string public fundName;

    //enum TypeFund {Closed_end, Fund}

    bytes32 public fundType; // Type Closed-end Fund

    //uint256 public initCapNSU;

    //uint256 public initCapCAP;

    // When adding a contract.
    event AddContract(address indexed caller, bytes32 indexed name, uint16 indexed code);

    // When removing a contract.
    event RemoveContract(address indexed caller, bytes32 indexed name, uint16 indexed code);

    event AddToken(address indexed caller, string name, uint16 indexed code);

    //, uint256 _initCapNSU, uint256 _initCapCAP
    function OpenEndedFundConstructor(address _nous, address _fundOwn, string _fundName, bytes32 _fundType) external
    onConstructor {
        nous = _nous;
        owner = _fundOwn;
        fundName = _fundName;
        fundType = _fundType;
        //initCapNSU = _initCapNSU;
        //initCapCAP = _initCapCAP;
        //receiveTokenAddress = _receiveTokenAddress;
    }

    function addToken(bytes32 _tokenSymbol, address _tokenAddress, address _saleAddress) public onlyNous returns(bool) {
        require(_tokenAddress != 0x0);
        require(!isToken(_tokenAddress));

        Token memory _ico = ico[_tokenAddress];
        _ico.sale = _saleAddress;
        _ico.tokenSymbol = _tokenSymbol;
        _ico.index = tokenIndex.push(_tokenAddress) - 1;
        return true;
    }

    /**
     * Add a new contract to Doug. This will overwrite an existing contract.
     * @dev _addr.call(bytes4(keccak256("constructor()"))); // конструктор срабатывает
     * @dev _addr.call("setDougAddress", address(this));
     */
    function addContract(bytes32 _name, address _addr, bool _doNotOverwrite)
    public onlyNous allowedUpdateContracts returns(bool) {

        if (!DougEnabled(_addr).setDougAddress(address(this))) {
            AddContract(msg.sender, _name, 403);
            return false;
        }
        bool ae = _addOrUpdateElement(_name, _addr, _doNotOverwrite);
        if (ae) {
            AddContract(msg.sender, _name, 201);
            Construct(_addr).constructor();
        } else {
            // Can't overwrite.
            AddContract(msg.sender, _name, 409);
        }
        return ae;
    }

    // Remove a contract from Doug. We could also selfdestruct if we want to.
    function removeContract(bytes32 _name) public onlyNous allowedUpdateContracts returns (bool) {
        if (list[_name].contractAddress == 0x0) {
            RemoveContract(msg.sender, _name, 403);
        }
        bool re = _removeElement(_name);
        if (re) {
            RemoveContract(msg.sender, _name, 200);
        } else {
            // Can't remove, it's already gone.
            RemoveContract(msg.sender, _name, 410);
        }
        return re;
    }

}
