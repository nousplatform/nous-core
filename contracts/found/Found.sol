pragma solidity ^0.4.4;

contract Found {

    //Fond name
    bytes32 name;

    mapping (bytes32 => bytes32) basic_data;

    address private     owner;    // the Creator of the contract
    address private     creator;    // Agent NOUS platform

    event LogAddManager (address indexed addressManager);

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function Found(address addressOwner, bytes32 nameFound) {
        owner = addressOwner;
        creator = msg.sender;
        name = nameFound;
    }

    // =====================
    // =====  MODIFIER =====
    // =====================
    
    modifier onlyOwner() {
        if (msg.sender != owner) { revert(); }
        _; // Will be replaced with function's body
    }

    modifier onlyAgent() {
        if (msg.sender != creator) { revert(); }
        _; // Will be replaced with function's body
    }

    /*modifier orOwnerManager(){
        if ( isManager(msg.sender) ) 
            _;
        else if (msg.sender == ownerAddress) 
            _;
        else 
            revert(); 
    }*/

    /*function isManager(address addressManager)
        public
        constant
        returns(bool isIndeed)
    {
        if (managersIndex.length == 0 ) return false;
        return !!managersAddress[addressManager];
    }*/

    // =====================
    // ====== ADD NEW ======
    // =====================

    function setBasicData (bytes32 key, bytes32 value) onlyOwner() {
        basic_data[key] = value;
    }

    
    /*function verificationWallet(
        address walletAddress,
        bool verification
    ) 
        onlyAgent() 
    {
        wallets[walletAddress].confirmed = verification;        
    }*/

    /*function addManager(
        address managerAddress
    )
        onlyOwner()
    {
        
        if (isManager(managerAddress)) revert();
        managersAddress[managerAddress] = true;
        managersIndex.push(managerAddress);
    }*/

    function createSnapShot(
        int32   balance,
        uint    indexWallet,
        uint    index
    )
        onlyAgent()
    {
        
    }

    // =====================
    // ======= USAGE =======
    // =====================
    function getBasicData (bytes32 arg) constant returns (bytes32) {
        return basic_data[arg];
    }



}
