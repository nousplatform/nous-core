pragma solidity ^0.4.4;

import "./fund/Fund.sol";

contract NousCreator {

    address private owner;    // the Creator of the contract
    address[] funds;

    mapping(bytes32 => address) defaultContracts;
    bytes32[] contractsList;


    function NousCreator(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) { revert(); }
        _;
    }

    function addFound(address addr) onlyOwner() returns (bool){
    	funds.push(addr);
    }

    function createNewFund(bytes32 name ) onlyOwner() returns (address fundAddress){
    	address fundAddr = new Fund(msg.sender, name);
        funds.push(fundAddr);
        createComponents(fundAddr);
        //funds.push(address(new Fund(msg.sender, name)));
        return funds[funds.length-1];
    }

    function createComponents(address fundAddr){
    	Fund fund = Fund(fundAddr);
		for (uint i = 0; i < contractsList.length; i++){
			bytes32 name = contractsList[i];
			address addr = defaultContracts[contractsList[i]];
			address newComp = clone(addr);
			fund.addContract(name, newComp);
		}
    }

    function getAllFund() constant returns (address[]){
    	address[] memory alladdr = new address[](funds.length);
    	for (uint8 i = 0; i < funds.length; i++){
    		alladdr[i] = funds[i];
		}
		return alladdr;
    }

    // clone contracts
	function clone(address a) onlyOwner returns(address) {
		/*
		Assembly of the code that we want to use as init-code in the new contract,
		along with stack values:
						# bottom [ STACK ] top
		 PUSH1 00       # [ 0 ]
		 DUP1           # [ 0, 0 ]
		 PUSH20
		 <address>      # [0,0, address]
		 DUP1       # [0,0, address ,address]
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
		 DUP1       # [0,0, address ,address]
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
			retval := create(0,0, 32)
		}
		return retval;
	}

	//add or edit default contracts
	function addContract(bytes32 name, address addr) onlyOwner() {
		if (defaultContracts[name] == 0x0) {
			contractsList.push(name);
		}
		defaultContracts[name] = addr;
	}

	function getDefaultContracts() constant returns (bytes32[], address[]){

		uint length = contractsList.length;
		bytes32[] memory names = new bytes32[](length);
		address[] memory addr = new address[](length);
		for (uint i = 0; i < length; i++){
			names[i] = contractsList[i];
			addr[i] = defaultContracts[contractsList[i]];
		}
		return (names, addr);
	}

    /*function createAndEndowD(uint arg, uint amount) {
        // Send ether along with the creation
        D newD = (new fund).value(amount)(arg);
    }*/
}
