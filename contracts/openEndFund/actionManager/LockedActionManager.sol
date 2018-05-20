pragma solidity ^0.4.18;


import "./Permissions.sol";


contract LockedActionManager is Permissions {

    bool locked;

    modifier isLocked()
    {
        require(locked);
        _;
    }

    function actionsLock()
    external
    onlyOwner
    returns (bool)
    {
        require(!locked);
        locked = true;
    }

    function actionsUnlock()
    external
    onlyOwner
    returns (bool)
    {
        require(locked);
        locked = false;
    }

}
