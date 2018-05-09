pragma solidity ^0.4.18;


import "../../../doug/safety/Validee.sol";


contract SnapshotDb is Validee {

    struct Snapshot {
        uint256 totalUSD;
        uint256 course;
    }

    mapping(uint256 => Snapshot) public snapshot;
    uint256[] public timestampSnapshot;

    function addSnapshot(uint256 _timestamp, uint256 _total, uint256 _course) external returns(bool) {
        if (!validate()) return false;
        snapshot[_timestamp].totalUSD = _total;
        snapshot[_timestamp].course = _course;
        return true;
    }

    function count() external constant returns(uint256) {
        return timestampSnapshot.length;
    }

    function getFromIndex(uint256 _index) external constant returns(uint256 totalUsd, uint256 course) {
        Snapshot memory _last = snapshot[timestampSnapshot[_index]];
        return (_last.totalUSD, _last.course);
    }

    /**
    * @notice gets last snapshot
    * @return {}
    */
    function last() external constant returns(uint256 _totalUsd, uint256 course) {
        Snapshot memory _last = snapshot[timestampSnapshot.length - 1];
        return (_last.totalUSD, _last.course);
    }

}
