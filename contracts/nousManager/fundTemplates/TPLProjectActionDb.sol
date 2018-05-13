pragma solidity ^0.4.18;


import {ProjectActionDb} from "../../projects/commonFunctions/models/ProjectActionDb.sol";


contract TPLProjectActionDb {
    function create() public returns (address) {
        return new ProjectActionDb();
    }
}
