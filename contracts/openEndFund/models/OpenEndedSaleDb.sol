pragma solidity ^0.4.18;


import {ProjectActionManagerEnabled} from "../actionManager/ProjectActionManagerEnabled.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract OpenEndedSaleDbInterface {
    mapping(bytes32 => uint256) public params;
    function setEntryFee(uint _entryFee) external;
    function setExitFee(uint _exitFee) external;
    function setManagementFee(uint _managementFee) external;
}

contract OpenEndedSaleDb is ProjectActionManagerEnabled {

    mapping(bytes32 => uint256) public params;



    struct Decimal {
        uint256 numerator;
        uint8 precision;
    }

    constructor(
        uint256 _entryFee,
        uint256 _exitFee,
        uint256 _initPrice,
        uint256 _maxFundCup,
        uint256 _maxInvestors,
        uint256 _platformFee
    )
    public
    {
        require(_entryFee > 0);
        require(_exitFee > 0);
        //require(_initPrice > 0);
        //require(_maxFundCup > 0);
        //require(_maxInvestors > 0);
        require(_platformFee > 0);

        params["entryFee"] = _entryFee;
        params["exitFee"] = _exitFee;
        params["initPrice"] = _initPrice;

        params["maxFundCup"] = _maxFundCup;
        params["maxInvestors"] = _maxInvestors;
        params["platformFee"] = _platformFee;

    }

    function setEntryFee(uint _entryFee)
    external
    isActionManager
    {
        require(_entryFee > 0);
        params["entryFee"] = _entryFee;
    }

    function setExitFee(uint _exitFee)
    external
    isActionManager
    {
        require(_exitFee > 0);
        params["exitFee"] = _exitFee;
    }

    function setManagementFee(uint _managementFee)
    external
    isActionManager
    {
        require(_managementFee > 0);
        params["managementFee"] = _managementFee;
    }
}
