pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


interface SnapshotDbInterface {
    function last() external constant returns(bytes32 hash, uint256 rate);
}


contract SnapshotDb is Validee {

    struct Snapshot {
        bytes32 hash;
        uint256 rate;
    }

    mapping(uint256 => Snapshot) public snapshot;
    uint256[] public timestampSnapshot;

    function addSnapshot(uint256 _timestamp, bytes32 _hash, uint256 _rate) external returns(bool) {
        if (!validate()) return false;
        snapshot[_timestamp].hash = _hash;
        snapshot[_timestamp].rate = _rate;
        return true;
    }

    function count() external constant returns(uint256) {
        return timestampSnapshot.length;
    }

    function getFromIndex(uint256 _index) external constant returns(bytes32 hash, uint256 rate) {
        Snapshot memory _current = snapshot[timestampSnapshot[_index]];
        return (_current.hash, _current.rate);
    }

    /**
    * @notice gets snapshot from date
    * @param _date format YYYYMMDD
    */
    function getFromDate(uint256 _date) external constant returns(bytes32 hash, uint256 rate) {
        Snapshot memory _current = snapshot[timestampSnapshot[_date]];
        return (_current.hash, _current.rate);
    }

    /**
    * @notice gets last snapshot
    */
    function last() external constant returns(bytes32 hash, uint256 rate) {
        Snapshot memory _last = snapshot[timestampSnapshot.length - 1];
        return (_last.hash, _last.rate);
    }

}
