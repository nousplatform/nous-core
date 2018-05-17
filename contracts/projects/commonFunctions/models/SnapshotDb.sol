pragma solidity ^0.4.18;


import {Validee} from "../../../doug/safety/Validee.sol";


contract SnapshotDbInterface {
    function addSnapshot(uint256 _timestamp, bytes32 _hash, uint256 _rate) external returns(bool);
    //function getSnapshot(uint256 _date) external constant returns(bytes32 hash, uint256 rate);
    function rate(uint date) external constant returns(uint hash, uint rate);
}


contract SnapshotDb is Validee {

    struct Snapshot {
        uint hash;
        uint256 rate;
    }

    mapping(uint256 => Snapshot) public snapshot;
    Snapshot last;

    function addSnapshot(uint256 _timestamp, uint _hash, uint256 _rate) external returns(bool) {
        if (!validate()) return false;
        snapshot[_timestamp].hash = _hash;
        snapshot[_timestamp].rate = _rate;
        last = snapshot[_timestamp];
        return true;
    }

    /**
    * @notice gets last snapshot
    */
    function rate(uint date) external constant returns(uint hash, uint rate) {
        if (date > 0) {
            return (snapshot[date].hash, snapshot[date].rate);
        }
        return (last.hash, last.rate);
    }

}
