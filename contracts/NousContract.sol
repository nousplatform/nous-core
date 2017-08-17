pragma solidity ^0.4.4;

import "./fund/Fund.sol";

contract NousCreator {

    address private owner;    // the Creator of the contract
    address[] funds;

    function NousCreator(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) { revert(); }
        _;
    }

    function createNewfund(bytes32 name ) onlyOwner() returns (address foundAddress){
        funds.push(address(new Fund(msg.sender, name)));
        return funds[funds.length-1];
    }

    function getContract() constant returns (address[]){
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
