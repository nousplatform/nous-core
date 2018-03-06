pragma solidity ^0.4.4;


contract OwnableFunds {

    // We still want an owner.
    address public owner;

    address public nous;

    address public fund;

    bool public allowAddContract = true;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event NousTransferred(address indexed previousNous, address indexed newNous);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyNousPlatform() {
        require(msg.sender == nous);
        _;
    }

    modifier ownerOrNous() {
        require(msg.sender == owner || msg.sender == nous);
        _;
    }

    modifier allowedUpdateContracts() {
        require(allowAddContract == true);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != 0x0);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newNous The address to transfer ownership to.
     */
    function transferNous(address newNous) public onlyNous {
        require(newNous != 0x0);
        NousTransferred(nous, newNous);
        nous = newNous;
    }
}
