pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "../fund/base/DougEnabled.sol";
import "../fund/interfaces/SampleCrowdsaleTokenInterface.sol";

contract BaseSaleAgent is Ownable {

    using SafeMath for uint256;
    uint8 decimals = 18;
    uint256 EXPONENT = 10 ** uint256(decimals); // 18
    bool public finalizeICO = false;
    address public walletAddress; // address for transfer NST token
    address public nousToken; // NST address
    address public tokenAddress;

    uint256 public totalSupplyCap; // 777 Million tokens Capitalize max count NOUS tokens TODO once
    uint256 public retainedByCompany; // percent retained tokens by mining  TODO once
    bytes32[] public issuingJurisdiction; // only for qualification investors TODO changed
    bytes32[] public investorsAccredited; // TODO changed
    //uint256 public vestingPeriod; // date period blocked tokens
    uint256 public vestingPeriodOwners; // date period blocked tokens by owner TODO changed to finalize
    //uint256 public percentageOfCompany; // type sequrity

    struct SalesAgent {
        uint256 tokensLimit; // The maximum amount of tokens this sale contract is allowed to distribute
        uint256 minDeposit; // TODO какой депозит The minimum deposit amount allowed
        uint256 maxDeposit; // The maximum deposit amount allowed
        uint256 startTime; // The start time (unix format) when allowed to mint tokens
        uint256 endTime; // The end time from unix format when to finish minting tokens
        uint256 rate; // default rate
        uint256 tokensMinted; // The current amount of tokens minted by this agent
        //bool isFinalized; // Has this sales contract been completed and the ether sent to the deposit address?
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
        require(_rate > 0);

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

    function getSaleAgents() public constant
    returns(
        uint256[] memory _tokensLimit,
        uint256[] memory _minDeposit,
        uint256[] memory _maxDeposit,
        uint256[] memory _startTime,
        uint256[] memory _endTime,
        uint256[] memory _rate,
        uint256[] memory _tokensMinted
    )
    {
        uint256 _length = salesAgents.length;
        _tokensLimit = new uint256[](_length);
        _minDeposit = new uint256[](_length);
        _maxDeposit = new uint256[](_length);
        _startTime = new uint256[](_length);
        _endTime = new uint256[](_length);
        _rate = new uint256[](_length);
        _tokensMinted = new uint256[](_length);

        for (uint256 i; i < _length; i++) {
            _tokensLimit[i] = salesAgents[i].tokensLimit;
            _minDeposit[i] = salesAgents[i].minDeposit;
            _maxDeposit[i] = salesAgents[i].maxDeposit;
            _startTime[i] = salesAgents[i].startTime;
            _endTime[i] = salesAgents[i].endTime;
            _rate[i] = salesAgents[i].rate;
            _tokensMinted[i] = salesAgents[i].tokensMinted;
        }
        //return (_investors, _balances);
    }

    //@dev you may redefined this function, but coll method super
    function finalise() public onlyOwner {
        require(finalizeICO == false);
        finalizeICO = true;
        SampleCrowdsaleTokenInterface(tokenAddress).finishMinting();
    }

    /*function availabilityCheckPurchase(SalesAgent _saleAgent) public constant returns (bool) {
        return _saleAgent.isFinalized == false && now > _saleAgent.startTime && now < _saleAgent.endTime;
    }

    function checkValue(uint256 _value, SalesAgent _saleAgent) internal constant returns (bool) {
        return _value > 0 && _saleAgent.minDeposit >= _value && _saleAgent.maxDeposit < _value;
    }*/

}
