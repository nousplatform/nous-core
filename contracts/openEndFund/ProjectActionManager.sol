pragma solidity ^0.4.18;


import {ActionsResolution} from "./actionManager/ActionsResolution.sol";
import {ContactsManager} from "./actionManager/ContactsManager.sol";
import {Permissions} from "./actionManager/Permissions.sol";
import {TokenActions} from "./actionManager/TokenActions.sol";


contract ProjectActionManager is ActionsResolution, ContactsManager, TokenActions {

    constructor(
        address fundOwner,
        address nousPlatform
    )
    Permissions(fundOwner, nousPlatform)
    public { }
}
