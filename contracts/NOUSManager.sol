pragma solidity ^0.4.18;


import "./fund/Fund.sol";
import "./base/Ownable.sol";
import "./lib/Validator.sol";
import "./lib/SafeMath.sol";

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

    mapping (bytes32 => address) defaultContracts;

    bytes32[] contractsList;

    address nousTokenAddress;

    event CreateFund(address indexed owner, address indexed fund, string fundName);

    function NOUSManager(address _nousTokenAddress) {
        owner = msg.sender;
        setNousTokenAddress(_nousTokenAddress);
    }

    /**
    @notice Set address NOUS tokens
    @param _nousTokenAddress Contract address NOUS token
    */
    function setNousTokenAddress(address _nousTokenAddress) public onlyOwner {
        require(_nousTokenAddress != 0x0);
        nousTokenAddress = _nousTokenAddress;
    }

    /**
    @notice Create new fund
    @dev Is caused from a user name
    @param _fundName Name new fund
    @param _tokenName Name token
    @param _tokenSymbol abbreviation
    @param _initialSupply Token initial supply
    @return { "fundaddress" : "new Fund address" }
    */
    function createNewFund(string _fundName, string _tokenName, string _tokenSymbol, uint256 _initialSupply, uint256 _rate)
    external returns (address) {
        require(Validator.emptyStringTest(_fundName));
        require(Validator.emptyStringTest(_tokenName));
        require(Validator.emptyStringTest(_tokenSymbol));
        require(_initialSupply > 0);
        require(!(ownerFundIndex[msg.sender] - 1 < ownerFundIndex[msg.sender]));

        address _fundAddr = new Fund(msg.sender, nousTokenAddress, _fundName, _tokenName, _tokenSymbol, _initialSupply, _rate);

        ownerFundIndex[msg.sender] = fundsIndex.push(_fundAddr);
        // current length array
        CreateFund(msg.sender, _fundAddr, _fundName);

        FundStructure memory newFund;
        newFund.fundName = _fundName;
        newFund.index = ownerFundIndex[msg.sender] - 1;
        // index = lenght - 1
        funds[_fundAddr] = newFund;

        return _fundAddr;
    }

    function createComponents(uint8 step) public {
        require((ownerFundIndex[msg.sender] - 1) >= 0);
        address fundAddr = fundsIndex[ownerFundIndex[msg.sender] - 1];

        require(fundsIndex[funds[fundAddr].index] == fundAddr);
        require(!(step == 0 && funds[fundAddr].indexChild.length > 1));
        require(!(step > 0 && funds[fundAddr].indexChild.length == 0));
        require(!(step > 0 && funds[fundAddr].indexChild.length == contractsList.length));

        uint256 start;
        uint256 end;

        if (step == 0) {
            start = 0;
            end = 4;
        } else if (step == 2) {
            start = 4;
            end = contractsList.length;
        } else {
            revert();
        }

        Fund fund = Fund(fundAddr);
        for (uint i = start; i < end; i++) {
            bytes32 name = contractsList[i];
            address addr = defaultContracts[contractsList[i]];
            address newCompAddr = clone(addr);
            bool res = fund.addContract(name, newCompAddr);

            if (res) {
                funds[fundAddr].childFundContracts[name] = newCompAddr;
                funds[fundAddr].indexChild.push(name);
            }
        }
    }

    //add or edit default contracts
    function addContract(bytes32[] names, address[] addrs) public onlyOwner {
        for (uint256 i = 0; i < names.length; i++) {
            if (defaultContracts[names[i]] == 0x0) {
                contractsList.push(names[i]);
            }
            defaultContracts[names[i]] = addrs[i];
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

    function getDefaultContracts() public constant returns (bytes32[], address[]) {
        uint length = contractsList.length;
        bytes32[] memory names = new bytes32[](length);
        address[] memory addr = new address[](length);
        for (uint i = 0; i < length; i++) {
            names[i] = contractsList[i];
            addr[i] = defaultContracts[contractsList[i]];
        }
        return (names, addr);
    }

    function getFundContracts(address faddr) public constant returns (bytes32[], address[]) {
        FundStructure storage fs = funds[faddr];
        uint length = fs.indexChild.length;
        bytes32[] memory names = new bytes32[](length);
        address[] memory addr = new address[](length);
        for (uint i = 0; i < length; i++) {
            names[i] = fs.indexChild[i];
            addr[i] = fs.childFundContracts[fs.indexChild[i]];
        }
        return (names, addr);
    }

    function getFundAddress(address userAddress) public {
        contractsList[ownerFundIndex[userAddress]];
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
