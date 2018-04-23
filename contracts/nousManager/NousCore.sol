pragma solidity ^0.4.18;


import "../doug/models/DougDb.sol";


contract NousCore is DougDb {

    address public nousTokenAddress;

    /**
    * @dev Constructor
    * @param _nousTokenAddress : NSU address for sale token fund
    */
    function NousCore(address _nousTokenAddress) {
        setNousTokenAddress(_nousTokenAddress);
    }

    /**
    * @notice Set address NOUS tokens
    * @param _nousTokenAddress Contract address NOUS token
    */
    function setNousTokenAddress(address _nousTokenAddress) public onlyOwner {
        require(_nousTokenAddress != 0x0);
        nousTokenAddress = _nousTokenAddress;
    }
}
