pragma solidity ^0.4.18;


import {ProjectPermissionDb} from "../../projects/commonFunctions/models/ProjectPermissionDb.sol";
contract TPLProjectPermissionDb {
    function create(address _nous, address _owner) public returns (address) {
        return new ProjectPermissionDb(_nous, _owner);
    }
}
