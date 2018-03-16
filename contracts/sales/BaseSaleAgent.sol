pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract BaseSaleAgent is Ownable {

    using SafeMath for uint256;
    uint8 decimals = 18;
    uint256 internal constant EXPONENT = 10 ** uint256(decimals); // 18
    bool finalizeICO = false;
    uint256 totalSupply;

    struct SalesAgent {
        uint256 tokensLimit; // The maximum amount of tokens this sale contract is allowed to distribute
        uint256 minDeposit; // The minimum deposit amount allowed
        uint256 maxDeposit; // The maximum deposit amount allowed
        uint256 startTime; // The start time (unix format) when allowed to mint tokens
        uint256 endTime; // The end time from unix format when to finish minting tokens
        uint256 rate; // default rate
        uint256 tokensMinted; // The current amount of tokens minted by this agent
        bool isFinalized; // Has this sales contract been completed and the ether sent to the deposit address?
        bool exists; // Check to see if the mapping exists
    }

    SalesAgent[] internal salesAgents;

    event FinaliseSale(uint256 tokensMinted, uint256 weiAmount, uint256 dateFinalize);
    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 tokens);

    /**
      @notice Set the address of a new crowdsale/presale contract agent if needed, usefull for upgrading
      @notice Only the owner can register a new sale agent
      @param _tokensLimit The maximum amount of tokens this sale contract is allowed to distribute
      @param _minDeposit The minimum deposit amount allowed
      @param _maxDeposit The maximum deposit amount allowed
      @param _startTime The start time when allowed to mint tokens
      @param _endTime The end time when to finish minting tokens
      @param _rate tokens rate
    */
    function setParamsSaleAgent(
        uint256 _tokensLimit,
        uint256 _minDeposit,
        uint256 _maxDeposit,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _rate
    ) public onlyOwner {
        require(_tokensLimit > 0); // Must have some available tokens
        require(_maxDeposit > _minDeposit); // Make sure the min deposit is less than or equal to the max
        require(_endTime > _startTime);

        SalesAgent memory newSalesAgent;
        newSalesAgent.tokensLimit = _tokensLimit * EXPONENT;
        newSalesAgent.minDeposit = _minDeposit * EXPONENT;
        newSalesAgent.maxDeposit = _maxDeposit * EXPONENT;
        newSalesAgent.startTime = _startTime;
        newSalesAgent.endTime = _endTime;
        newSalesAgent.rate = _rate;
        newSalesAgent.exists = true;
        salesAgents.push(newSalesAgent);
    }

    //@dev you may redefined this function, but coll method super
    function finalise() public onlyOwner {
        require(finalizeICO == false);
        finalizeICO = true;
    }


}
