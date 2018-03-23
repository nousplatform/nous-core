pragma solidity ^0.4.18;


//import "./fund/Fund.sol";
import "./lib/Utils.sol";
import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
import "./fund/interfaces/SampleCrowdsaleTokenInterface.sol";
import "./fund/interfaces/SaleInterface.sol";
import "./fund/interfaces/FundInterface.sol";
import "./fund/interfaces/ConstructInterface.sol";


/**
@title Nous Platform Manger
@author Manchenko Valeriy
*/
contract NOUSManager is Ownable {

    /// Structure fund
    struct FundStructure {
        string fundName;
        mapping (bytes32 => address) childFundContracts;
        bytes32[] indexChild;
        uint256 index;
    }

    /// address fund => structure found
    mapping (address => FundStructure) public funds;

    /// Owner fund index fund.
    mapping (address => uint256) ownerFundIndex;

    address[] fundsIndex;

    struct ContractDetails {
        address addr;
        bool overwrite;
    }

    mapping (bytes32 => ContractDetails) public defaultContracts;

    bytes32[] contractsList;

    address public nousTokenAddress = 0x4dd59912CA031Ace5524f22F78226d338bc513aA;
    event CreateFund(address indexed owner, address indexed fund, string fundName);
    event CreateToken(address indexed owner, address indexed token, string tokenName);

    /*function NOUSManager(address _nousTokenAddress, address _nousCreator) {
        owner = msg.sender;
        setNousTokenAddress(_nousTokenAddress);
        setNousCreator(_nousCreator);
    }*/

    /**
    * @notice Set address NOUS tokens
    * @param _nousTokenAddress Contract address NOUS token
    */
    function setNousTokenAddress(address _nousTokenAddress) public onlyOwner {
        require(_nousTokenAddress != 0x0);
        nousTokenAddress = _nousTokenAddress;
    }

    function createToken(
        address _owner,
        string _tokenName,
        string _tokenSymbol,
        uint8 _decimals,
        uint256 _totalSupplyCap,
        uint256 _retainedByCompany,
        address _walletAddress
    ) public onlyOwner returns(address) {
        require(_owner != 0x0);
        require(Utils.emptyStringTest(_tokenName));
        require(Utils.emptyStringTest(_tokenSymbol));

        address _fundAddr = fundsIndex[ownerFundIndex[_owner]];
        assert(_fundAddr != 0x0);

        address _tokenAddress = clone(defaultContracts["sample_tokens"].addr);
        address _saleAddress = clone(defaultContracts["sale"].addr);

        SampleCrowdsaleTokenInterface(_tokenAddress).constructor(_saleAddress, _tokenName, _tokenSymbol, _decimals);
        SaleInterface(_saleAddress).constructor(_owner, _tokenAddress, _totalSupplyCap, _retainedByCompany, _walletAddress, nousTokenAddress);

        FundInterface(_fundAddr).addToken(_tokenSymbol, _tokenAddress);

        bytes32 _tknSymbol = Utils.stringToBytes32(_tokenSymbol);
        funds[_fundAddr].childFundContracts[_tknSymbol] = _tokenAddress;
        funds[_fundAddr].indexChild.push(_tknSymbol);

        CreateToken(_owner, _tokenAddress, _tokenName);
        return _tokenAddress;
    }

    /**
    * @notice Create new fund
    * @dev Is caused from a user name
    * @param _fundName Name new fund
    * @return { "fundaddress" : "new Fund address" }
    */
    function createNewFund(address _owner, string _fundName, bytes32 _fundType) //string _tokenName, string _tokenSymbol, uint8 _decimals
    public onlyOwner returns (address) {
        require(_owner != 0x0);
        require(Utils.emptyStringTest(_fundName));
        //require(!Utils.emptyStringTest(ownerFundIndex[_owner]));
        //require(fundsIndex[ownerFundIndex[_newOwner]] == 0x0);

        ContractDetails memory fundClone = defaultContracts["fund_constructor"];
        address _fundAddr = clone(fundClone.addr);

        FundInterface(_fundAddr).constructor(_owner, _fundName, _fundType);
        ownerFundIndex[_owner] = fundsIndex.push(_fundAddr) - 1;
        // current length array
        CreateFund(_owner, _fundAddr, _fundName);
        FundStructure memory newFund;
        newFund.fundName = _fundName;
        newFund.index = ownerFundIndex[_owner];
        funds[_fundAddr] = newFund;

        return _fundAddr;
    }

    function createComponentsStep(address _owner) public {
        address _fundAddr = fundsIndex[ownerFundIndex[_owner]];
        require(fundsIndex[funds[_fundAddr].index] == _fundAddr);
        require(funds[_fundAddr].indexChild.length != contractsList.length);

        if (funds[_fundAddr].indexChild.length == 0) {
            createComponents(_fundAddr, 0, 4);
        } else {
            createComponents(_fundAddr, 4, contractsList.length);
        }

    }

    function createComponents(address _fundAddr, uint256 _start, uint256 _end) internal {
        FundInterface fund = FundInterface(_fundAddr);
        for (uint i = _start; i < _end; i++) {
            bytes32 _name = contractsList[i];
            bool _doNotOverwrite = defaultContracts[contractsList[i]].overwrite;
            address _addr = defaultContracts[contractsList[i]].addr;
            address _newCompAddr = clone(_addr);
            bool res = fund.addContract(_name, _newCompAddr, _doNotOverwrite);

            if (res) {
                funds[_fundAddr].childFundContracts[_name] = _newCompAddr;
                funds[_fundAddr].indexChild.push(_name);
            }
        }
    }

    //add or edit default contracts
    function addContract(bytes32[] _names, address[] _addrs, bool[] _overwrite) public onlyOwner {
        for (uint256 i = 0; i < _names.length; i++) {
            if (defaultContracts[_names[i]].addr == 0x0) {
                contractsList.push(_names[i]);
            }
            ContractDetails storage contr = defaultContracts[_names[i]];
            contr.addr = _addrs[i];
            contr.overwrite = _overwrite[i];
        }
    }

    /**
    * gets all funds
    */
    function getAllFunds() public constant returns (address[]) {
        address[] memory alladdr = new address[](fundsIndex.length);
        for (uint8 i = 0; i < fundsIndex.length; i++) {
            alladdr[i] = fundsIndex[i];
        }
        return alladdr;
    }

    /*function getDefaultContracts() public constant returns (bytes32[], address[]) {
        uint length = contractsList.length;
        bytes32[] memory names = new bytes32[](length);
        address[] memory addr = new address[](length);
        for (uint i = 0; i < length; i++) {
            names[i] = contractsList[i];
            addr[i] = defaultContracts[contractsList[i]];
        }
        return (names, addr);
    }*/

    /*function getFundContracts(address faddr) public constant returns (bytes32[], address[]) {
        FundStructure storage fs = funds[faddr];
        uint length = fs.indexChild.length;
        bytes32[] memory names = new bytes32[](length);
        address[] memory addr = new address[](length);
        for (uint i = 0; i < length; i++) {
            names[i] = fs.indexChild[i];
            addr[i] = fs.childFundContracts[fs.indexChild[i]];
        }
        return (names, addr);
    }*/

    function getFundAddress(address userAddress) public constant returns(address) {
        return fundsIndex[ownerFundIndex[userAddress]];
    }

    /*
    *  Assembly of the code that we want to use as init-code in the new contract,
    *  along with stack values:
    */
    function clone(address a) internal returns (address) {
        address retval;
        assembly{
            mstore(0x0, or (0x5880730000000000000000000000000000000000000000803b80938091923cF3, mul(a, 0x1000000000000000000)))
            retval := create(0, 0, 32)
        }
        return retval;
    }

}
