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

    function createNewFund(bytes32 name ) onlyOwner() returns (address foundAddress){
        funds.push(address(new Fund(msg.sender, name)));
        return funds[funds.length-1];
    }

    function addContract(bytes32 name, address addr){
    	defaultContracts[name] = addr;
    	contractsList.push(name);
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

    function createComponents(address fundAddr){
    	Fund fund = Fund(fundAddr);
		for (uint i = 0; i < contractsList.length; i++){
			bytes32 name = contractsList[i];
			address addr = defaultContracts[contractsList[i]];
			fund.clone(name, addr);
		}
    }

    function getAllFund() constant returns (address[]){
    	address[] memory alladdr = new address[](funds.length);
    	for (uint8 i = 0; i < funds.length; i++){
    		alladdr[i] = funds[i];
		}
		return alladdr;
    }

    /*function createAndEndowD(uint arg, uint amount) {
        // Send ether along with the creation
        D newD = (new fund).value(amount)(arg);
    }*/
}
