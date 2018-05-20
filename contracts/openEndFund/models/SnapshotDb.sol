pragma solidity ^0.4.18;


import {ProjectActionManagerEnabled} from "../actionManager/ProjectActionManagerEnabled.sol";


contract SnapshotDbInterface {
    function addSnapshot(uint256 _timestamp, uint256 _hash, uint256 _rate) external returns(bool);
    function rate() external constant returns(uint);
}

contract SnapshotDb is ProjectActionManagerEnabled {

    struct Snapshot {
        uint256 hash;
        uint256 rate;
    }

    mapping(uint256 => Snapshot) public snapshot;

    Snapshot public lastSnapshot;

    function addSnapshot(
        uint256 _timestamp,
        uint256 _hash,
        uint256 _rate
    )
    external
    isActionManager
    returns (bool)
    {
        snapshot[_timestamp] = Snapshot(_hash, _rate);
        lastSnapshot = snapshot[_timestamp];
        return true;
    }

    /**
    * @notice gets last rate snapshot
    */
    function rate()
    external
    view
    returns (uint)
    {
        return lastSnapshot.rate;
    }

}
