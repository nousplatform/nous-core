pragma solidity ^0.4.18;


import "../../doug/ActionManager.sol";
import "./models/ProjectPermissionDb.sol";


contract ProjectManager is ActionManager {

    constructor() {
        permToLock = 255;
    }

}
