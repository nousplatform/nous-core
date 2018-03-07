pragma solidity ^0.4.18;


import "./models/DougDb.sol";
import "./base/DougEnabled.sol";
import "../base/Construct.sol";
import "./base/OwnableFunds.sol";


// The Doug contract.
contract Fund is OwnableFunds, Construct, DougDb {

    string public name;

    enum TypeFund {Closed_end, Fund}

    TypeFund public fundType; // Type Closed-end Fund

    uint256 public initCapNSU;

    uint256 public initCapCAP;

    uint256 public receiveTokenAddress;

    // When adding a contract.
    event AddContract(address indexed caller, bytes32 indexed name, uint16 indexed code);
    // When removing a contract.
    event RemoveContract(address indexed caller, bytes32 indexed name, uint16 indexed code);

    function constructor(address _fundOwn, string _fundName, TypeFund _fundType, uint256 _initCapNSU, uint256 _initCapCAP, address _receiverTokenAddress)
    onConstructor external {
        super.constructor();

        nous = msg.sender;
        owner = _fundOwn;
        fondName = _fundName;
        fundType = _fundType;
        initCapNSU = _initCapNSU;
        initCapCAP = _initCapCAP;
        receiverTokenAddress = _receiverTokenAddress;
    }

    function setReceiveTokenAddress(address _addr) public onlyNousPlatform allowedUpdateContracts {
        require(_addr != 0x0);
        receiveTokenAddress = _addr;
    }

    /**
     * Add a new contract to Doug. This will overwrite an existing contract.
     * @dev _addr.call(bytes4(keccak256("constructor()"))); // конструктор срабатывает
     * @dev _addr.call("setDougAddress", address(this));
     */
    function addContract(bytes32 _name, address _addr, bool _doNotOverwrite)
    public onlyNousPlatform allowedUpdateContracts returns(bool) {
        if (!DougEnabled(_addr).setDougAddress(address(this))) {
            AddContract(msg.sender, name, 403);
            return false;
        }
        bool ae = _addOrUpdateElement(name, addr);
        if (ae) {
            AddContract(msg.sender, name, 201);
            Construct(_addr).construct();
        } else {
            // Can't overwrite.
            AddContract(msg.sender, name, 409);
        }
        return ae;
    }

    // Remove a contract from Doug. We could also selfdestruct if we want to.
    function removeContract(bytes32 _name) public onlyNousPlatform allowedUpdateContracts returns (bool) {
        if (list[_name] == 0x0) {
            RemoveContract(msg.sender, _name, 403);
        }
        bool re = _removeElement(_name);
        if (re) {
            RemoveContract(msg.sender, _name, 200);
        } else {
            // Can't remove, it's already gone.
            RemoveContract(msg.sender, name, 410);
        }
        return re;
    }

}
