pragma solidity ^0.4.18;


import "./LockedActionManager.sol";
import "../../doug/safety/DougEnabled.sol";
import {DougInterface as Doug} from "../../doug/Doug.sol";


contract ContactsManager is DougEnabled, LockedActionManager {

    bool public allowed;

    modifier ownerAllowed()
    {
        require(allowed);
        _;
    }

    /**
    * @notice Permission to management contracts can only give owner.
    */
    function ownerAllow()
    onlyOwner
    external
    {
        require(!allowed);
        allowed = true;
    }

    function ownerDisallow()
    onlyOwner
    external
    {
        require(allowed);
        allowed = false;
    }

    function actionAddContract(
        bytes32 _name,
        address _addr
    )
    isLocked
    ownerAllowed
    onlyRole(ROLE_NOUS_PLATFORM)
    external
    {
        require(_name != bytes32(0));
        require(_addr != 0x0);
        Doug(DOUG).addContract(_name, _addr);
    }

    function actionRemoveContract(bytes32 _name)
    isLocked
    ownerAllowed
    onlyRole(ROLE_NOUS_PLATFORM)
    external
    {
        require(_name != bytes32(0));
        Doug(DOUG).removeContract(_name);
    }

}
