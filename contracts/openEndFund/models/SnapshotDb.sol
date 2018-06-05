pragma solidity ^0.4.18;


import {ProjectActionManagerEnabled} from "../actionManager/ProjectActionManagerEnabled.sol";


interface SnapshotDbInterface {
    function addSnapshot(uint256 _timestamp, uint256 _hash, uint256 _rate) external returns(bool);
    function rate() external constant returns(uint);
}

interface NetInterface {
    function getFromIndex(uint256 _index) public view returns (address, uint256);
    function totalNet() public view returns (uint256);
}


contract SnapshotDb is ProjectActionManagerEnabled {

    struct NetStr {
        address token;
        uint256 totalSum;
    }

    struct Snapshot {
        uint256 hash;
        uint256 rate;
        mapping(uint => NetStr) nets;
        uint netSize;
    }

    mapping(uint256 => Snapshot) public snapshot;

    uint256 public rate;

    function addSnapshot(
        uint256 _timestamp,
        uint256 _hash,
        uint256 _rate
    )
    external
    isActionManager
    returns (bool)
    {
        require(_timestamp > 0);
        require(_rate > 0);
        rate = _rate;

        Snapshot storage _sanpsh = snapshot[_timestamp];
        _sanpsh.hash = _hash;
        _sanpsh.rate = _rate;

        NetInterface _net = NetInterface(getContractAddress("OpenEndedToken"));
        uint256 total = _net.totalNet();
        for (uint i = 0; i < total; i++) {
            address _netAddr;
            uint256 _totalSum;
            (_netAddr, _totalSum) = _net.getFromIndex(i-1);
            _sanpsh.nets[i] = NetStr(_netAddr, _totalSum);
            _sanpsh.netSize = i+1;
        }

        return true;
    }

}
