pragma solidity ^0.4.18;


import {Validee} from "../../../doug/safety/Validee.sol";


contract SnapshotDbInterface {
    function addSnapshot(uint256 _timestamp, bytes32 _hash, uint256 _rate) external returns(bool);
    function getSnapshot(uint256 _date) external constant returns(bytes32 hash, uint256 rate);
    function rate() external constant returns(uint256 rate);
}


contract SnapshotDb is Validee {

    struct Snapshot {
        uint hash;
        uint256 rate;
    }

    mapping(uint256 => Snapshot) public snapshot;
    uint256[] public timestampSnapshot;

    /*constructor(uint256 _rate) {
        snapshot[now].rate = _rate;
        timestampSnapshot.push(now);
    }*/

    function addSnapshot(uint256 _timestamp, uint _hash, uint256 _rate) external returns(bool) {
        if (!validate()) return false;
        snapshot[_timestamp].hash = _hash;
        snapshot[_timestamp].rate = _rate;
        return true;
    }

    function count() external constant returns(uint256) {
        return timestampSnapshot.length;
    }

    function getFromIndex(uint256 _index) external constant returns(uint hash, uint256 rate) {
        Snapshot memory _current = snapshot[timestampSnapshot[_index]];
        return (_current.hash, _current.rate);
    }

    /**
    * @notice gets snapshot from date
    * @param _date format YYYYMMDD
    */
    function getSnapshot(uint256 _date) external constant returns(uint hash, uint256 rate) {
        uint index;
        if (_date == 0) {
            index = timestampSnapshot.length - 1;
        } else {
            index = timestampSnapshot[_date];
        }
        Snapshot storage _current = snapshot[index];
        return (_current.hash, _current.rate);
    }

    /**
    * @notice gets last snapshot
    */
    function rate() external constant returns(uint256 rate) {
        Snapshot storage _last = snapshot[timestampSnapshot.length - 1];
        return _last.rate;
    }

}
