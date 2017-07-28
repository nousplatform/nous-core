pragma solidity ^0.4.4;

import "./found/Found.sol";
import "./core/Doug.sol";

contract NousContract {

    address private owner;    // the Creator of the contract
    //address[] founds;
    address Doug;


    function NousContract(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) { revert(); }
        _;
    }

    // TODO create new Doug
    function setDougAddress(){

    }

    /*function createNewFound(bytes32 _name ) onlyOwner() constant returns (Found foundAddress){
        founds.push(address(new Found(_addressOwner, _name)));
        return founds[founds.length-1];
    }*/

    function addFound( address addressOwner, bytes32 name ) onlyOwner() returns (bool){
        address found_address = address(new Found(addressOwner, name));
        return true;
    }

    /*function createAndEndowD(uint arg, uint amount) {
        // Send ether along with the creation
        D newD = (new Found).value(amount)(arg);
    }*/
}
