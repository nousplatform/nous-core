pragma solidity ^0.4.18;


import {ProjectActionManagerEnabled} from "../actionManager/ProjectActionManagerEnabled.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";


contract OpenEndedSaleDbInterface {
    mapping(bytes32 => uint256) public params;
    mapping(bytes32 => uint256) public paramsAddr;
    function setEntryFee(uint _entryFee) external returns (bool);
    function setExitFee(uint _exitFee) external returns (bool);
    function setPlatformFee(uint _platformFee) external returns (bool);
}

contract OpenEndedSaleDb is ProjectActionManagerEnabled {

    mapping(bytes32 => uint256) public params;

    //mapping(bytes32 => uint256) public paramsAddr;

    address public nousWallet;

    address public  ownerWallet;

    constructor(
        uint256 _entryFee,
        uint256 _exitFee,
        uint256 _initPrice,
        uint256 _maxFundCup,
        uint256 _maxInvestors,
        uint256 _platformFee/*,
        address _nousWallet,
        address _ownerWallet*/
    )
    public
    {
        require(_entryFee > 0);
        require(_exitFee > 0);
        require(_platformFee > 0);
        //require(_nousWallet > 0x0);
        //require(_ownerWallet > 0x0);

        params["entryFee"] = _entryFee;
        params["exitFee"] = _exitFee;
        params["initPrice"] = _initPrice;
        params["maxFundCup"] = _maxFundCup;
        params["maxInvestors"] = _maxInvestors;
        params["platformFee"] = _platformFee;

        //paramsAddr["nousWallet"] = _nousWallet;
        //paramsAddr["ownerWallet"] = _ownerWallet;
    }

    function setEntryFee(uint _entryFee)
    external
    isActionManager_
    returns (bool)
    {
        params["entryFee"] = _entryFee;
        return true;
    }

    //--
    function setExitFee(uint _exitFee)
    external
    isActionManager_
    returns (bool)
    {
        params["exitFee"] = _exitFee;
        return true;
    }

    //--
    function setPlatformFee(uint _platformFee)
    external
    isActionManager_
    returns (bool)
    {
        params["platformFee"] = _platformFee;
        return true;
    }

}
