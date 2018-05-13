pragma solidity ^0.4.18;


import {SnapshotDb} from "../../projects/commonFunctions/models/SnapshotDb.sol";
contract TPLSnapshotDb {
    function create() public returns (address) {
        return new SnapshotDb();
    }
}
