pragma solidity 0.4.18;

contract SalesDb {

    enum SaleContractType {Preorder, Presale, Crowdsale}

    // These are contract addresses that are authorised to mint tokens
    struct SalesAgent {
        address tokenAddress; // Address of the contract
        SaleContractType saleContractType; // Type of the contract ie. presale, crowdsale, reserve_funds
        uint256 tokenLimit; // The maximum amount of tokens this sale contract is allowed to distribute
        uint256 tokenMinted; // The current amount of tokens minted by this agent
        uint256 weiRaised; // The current amount of tokens minted by this agent
        uint256 rate; // default rate
        uint256 minDeposit; // The minimum deposit amount allowed
        uint256 maxDeposit; // The maximum deposit amount allowed
        uint256 startTime; // The start time (unix format) when allowed to mint tokens
        uint256 endTime; // The end time from unix format when to finish minting tokens
        bool isFinalized; // Has this sales contract been completed and the ether sent to the deposit address?
        bool exists; // Check to see if the mapping exists
        uint256 index;
    }

    mapping (bytes32 => SalesAgent) internal salesAgents; // symbol agent
    address[] internal salesAgentsAddresses; // Keep an array of all our sales agent addresses for iteration

    function addSaleAgent(
        address _saleAddress,
        SaleContractType _saleContractType,
        uint256 _tokensLimit,
        uint256 _minDeposit,
        uint256 _maxDeposit,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _rate
    )
    public onlyOwner
    {
        uint256 _tokensMinted = changeActiveSale(_saleContractType);
        require(saleState != SaleState.Ended); // if Sale state closed do not add sale config
        require(_saleAddress != 0x0); // Valid addresses
        require(_tokensLimit > 0 && _tokensLimit <= totalSupplyCap); // Must have some available tokens
        require(_minDeposit <= _maxDeposit); // Make sure the min deposit is less than or equal to the max
        require(_endTime > _startTime);
        require(_startTime >= now);

        // Add the new sales contract
        SalesAgent newSalesAgent = salesAgents[_saleAddress];
        newSalesAgent.saleContractAddress = _saleAddress;
        newSalesAgent.saleContractType = _saleContractType;
        newSalesAgent.tokensLimit = _tokensLimit * EXPONENT;
        newSalesAgent.tokensMinted = 0;
        newSalesAgent.minDeposit = _minDeposit * 1 ether;
        newSalesAgent.maxDeposit = _maxDeposit * 1 ether;
        newSalesAgent.startTime = _startTime;
        newSalesAgent.endTime = _endTime;
        newSalesAgent.rate = _rate;
        newSalesAgent.isFinalized = false;
        newSalesAgent.exists = true;
        newSalesAgent.tokensMinted = _tokensMinted;
        newSalesAgent.index = salesAgentsAddresses.push(_saleAddress) - 1;
    }

    /**** Getters ****/
    /// @dev Returns true if this sales contract has finalised
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractIsFinalised(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (bool) {
        return salesAgents[_salesAgentAddress].isFinalized;
    }

    /// @dev Returns the start block for the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractStartTime(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].startTime;
    }

    /// @dev Returns the start block for the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractEndTime(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].endTime;
    }

    /// @dev Returns the max tokens for the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractTokensLimit(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].tokensLimit;
    }

    /// @dev Returns the token total currently minted by the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractTokensMinted(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].tokensMinted;
    }

    /// @dev Returns the token total currently minted by the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractTokensRate(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].rate;
    }

    /// @dev Returns the token total currently minted by the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractMinDeposit(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].minDeposit;
    }

    /// @dev Returns the token total currently minted by the sale agent
    /// @param _salesAgentAddress The address of the token sale agent contract
    function getSaleContractMaxDeposit(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns (uint256) {
        return salesAgents[_salesAgentAddress].maxDeposit;
    }

    function getTokenTotalSupply() returns (uint256) {
        return tokenContract.totalSupply();
    }


}
