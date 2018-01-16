pragma solidity ^0.4.18;


import "./fund/Fund.sol";
import "./base/Ownable.sol";
import "./lib/Validator.sol";
import "./lib/SafeMath.sol";


contract NousCreator is Ownable {

    struct FundStructure {
    	string fundName;
    	mapping(bytes32 => address) childFundContracts;
    	bytes32[] indexChild;
		uint256 index;
    }

    mapping (address => FundStructure) Funds;
	mapping (address => uint256) ownerFundIndex; // owner fund index fund.
    address[] fundsIndex;

    mapping(bytes32 => address) defaultContracts;
    bytes32[] contractsList;

    function NousCreator() {
        owner = msg.sender;
    }

    function createNewFund(string _fundName, string _tokenName, string _tokenSymbol, uint256 _initialSupply) external returns(address) {
		require(Validator.emptyStringTest(_fundName));
		require(Validator.emptyStringTest(_tokenName));
		require(Validator.emptyStringTest(_tokenSymbol));
		require(_initialSupply > 0);
		require(!(ownerFundIndex[msg.sender]-1 < ownerFundIndex[msg.sender]));

    	address fundAddr = new Fund(msg.sender, _fundName, _tokenName, _tokenSymbol, _initialSupply);
		ownerFundIndex[msg.sender] = fundsIndex.push(fundAddr); // current length array

        FundStructure memory newFund;
        newFund.fundName = _fundName;
        newFund.index = ownerFundIndex[msg.sender] - 1; // index = lenght - 1
        Funds[fundAddr] = newFund;

        return fundAddr;
    }

    function createComponents(uint8 step) public {
		require((ownerFundIndex[msg.sender]-1) >= 0);
		address fundAddr = fundsIndex[ownerFundIndex[msg.sender] - 1];

		require(fundsIndex[Funds[fundAddr].index] == fundAddr);
		require(!(step == 0 && Funds[fundAddr].indexChild.length > 1));
		require(!(step > 0 && Funds[fundAddr].indexChild.length == 0));
		require(!(step > 0 && Funds[fundAddr].indexChild.length == contractsList.length));

		uint256 start;
		uint256 end;

		if (step == 0) {
			start = 0;
			end = 4;
		}
		else if (step == 2) {
			start = 4;
			end = contractsList.length;
		} else {
			revert();
		}

    	Fund fund = Fund(fundAddr);
		for (uint i = start; i < end; i++) {
			bytes32 name = contractsList[i];
			address addr = defaultContracts[contractsList[i]];
			address newComp = clone(addr);
			bool res = fund.addContract(name, newComp);

			if (res) {
				Funds[fundAddr].childFundContracts[name] = newComp;
				Funds[fundAddr].indexChild.push(name);
			}
		}
    }

    // clone contracts
	function clone(address a) internal returns(address) {
		/*
		Assembly of the code that we want to use as init-code in the new contract,
		along with stack values:
						# bottom [ STACK ] top
		 PUSH1 00       # [ 0 ]
		 DUP1           # [ 0, 0 ]
		 PUSH20
		 <address>      # [0,0, address]
		 DUP1       	# [0,0, address ,address]
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
		 DUP1      	 	# [0,0, address ,address]
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
			retval := create(0,0,32)
		}
		return retval;
	}

	//add or edit default contracts
	function addContract(bytes32[] names, address[] addrs) public onlyOwner {
		for (uint256 i=0; i < names.length; i++) {
			if (defaultContracts[names[i]] == 0x0) {
				contractsList.push(names[i]);
			}
			defaultContracts[names[i]] = addrs[i];
		}
	}

	function getAllFunds() public constant returns (address[]) {
		address[] memory alladdr = new address[](fundsIndex.length);
		for (uint8 i = 0; i < fundsIndex.length; i++){
			alladdr[i] = fundsIndex[i];
		}
		return alladdr;
	}

	function getDefaultContracts() public constant returns (bytes32[], address[]) {
		uint length = contractsList.length;
		bytes32[] memory names = new bytes32[](length);
		address[] memory addr = new address[](length);
		for (uint i = 0; i < length; i++){
			names[i] = contractsList[i];
			addr[i] = defaultContracts[contractsList[i]];
		}
		return (names, addr);
	}

	function getFundContracts(address faddr) public  constant returns (bytes32[], address[]) {
		FundStructure storage fs = Funds[faddr];
		uint length = fs.indexChild.length;
		bytes32[] memory names = new bytes32[](length);
		address[] memory addr = new address[](length);
		for (uint i = 0; i < length; i++){
			names[i] = fs.indexChild[i];
			addr[i] = fs.childFundContracts[fs.indexChild[i]];
		}
		return (names, addr);
	}

	function getFundAddress(address userAddress) {
		contractsList[ownerFundIndex[userAddress]];
	}

}
