pragma solidity ^0.4.18;


contract SubOwner {
    address public subOwner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function SubOwner(address _subOwner) public {
        subOwner = _subOwner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlySubOwner() {
        require(msg.sender == subOwner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlySubOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(subOwner, newOwner);
        subOwner = newOwner;
    }
}
