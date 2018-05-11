pragma solidity ^0.4.18;


import "../doug/Doug.sol";
import "../doug/interfaces/Validator.sol";


contract NousCore is Doug {

    address public nousTokenAddress;

    /**
    * @dev Constructor
    * @param _nousTokenAddress : NSU address for sale token fund
    */
    function NousCore(address _nousTokenAddress, bytes32[] _names, address[] _addrs) public
    Doug(_names, _addrs)
    {
        setNousTokenAddress(_nousTokenAddress);
    }

    /**
    * @notice Set address NOUS tokens
    * @param _nousTokenAddress Contract address NOUS token
    */
    function setNousTokenAddress(address _nousTokenAddress) public returns(bool) {
        address _am = contractList["ActionManager"];
        if (!Validator(_am).validate(msg.sender)) return false;

        require(_nousTokenAddress != 0x0);
        nousTokenAddress = _nousTokenAddress;
        return true;
    }
}
