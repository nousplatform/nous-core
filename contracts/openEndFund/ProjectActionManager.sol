pragma solidity ^0.4.18;


import {ActionsResolution} from "./actionManager/ActionsResolution.sol";
import {ContactsManager} from "./actionManager/ContactsManager.sol";
import {Permissions} from "./actionManager/Permissions.sol";


contract ProjectActionManager is ActionsResolution, ContactsManager {

    constructor(
        address fundOwner,
        address nousPlatform
    )
    Permissions(fundOwner, nousPlatform)
    public { }
}
