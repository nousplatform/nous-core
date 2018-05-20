pragma solidity ^0.4.18;


import {Doug} from "../doug/Doug.sol";
import "../doug/interfaces/Validator.sol";
//import {ActionManager} from "../doug/ActionManager.sol";


contract NousCore is Doug {

    address public nousTokenAddress;

    /**
    * TODO Nous tOken In constructor only for test
    * @dev Constructor
    * @param _nousTokenAddress : NSU address for sale token fund
    */
    constructor(
        address _nousTokenAddress,
        bytes32[] _names,
        address[] _addrs
    )
    public
    Doug(_names, _addrs)
    {
        nousTokenAddress = _nousTokenAddress;
    }


    // Todo temp
    /*function queryFund(
        address _fundAddr,
        bytes _data
    )
    public
    onlyActionManager
    {
        _fundAddr.call(_data);
    }*/

    /**
    * @notice Set address NOUS tokens
    * @param _nousTokenAddress Contract address NOUS token
    */
    function setNousTokenAddress(address _nousTokenAddress)
    public
    onlyActionManager
    returns(bool)
    {
        require(_nousTokenAddress != 0x0);
        nousTokenAddress = _nousTokenAddress;
        return true;
    }
}
