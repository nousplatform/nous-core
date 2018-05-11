pragma solidity ^0.4.18;


import {Doug} from "../../doug/Doug.sol";
import "../interfaces/Validator.sol";


contract DougProtectionRewriting is Doug {

    mapping (bytes32 => bool) public notOverWrite;

    modifier validateOverwrite(bytes32 _name) {
        require(!notOverWrite[_name]);
        _;
    }

    constructor(bytes32[] _names, bool[] _perms) public {
        for (uint i = 0; i < _names.length; i++) {
            _addProtection(_names[i], _perms[i]);
        }
    }

    function _addProtection(bytes32 _name, bool _perm) internal validateOverwrite(_name) returns(bool) {
        notOverWrite[_name] = _perm;
        return true;
    }

    function addProtection(bytes32 _name, bool _perm) external returns(bool) {
        address _am = contractList["ActionManager"];
        if (!Validator(_am).validate(msg.sender)) return false;
        _addProtection(_name, _perm);
        return true;
    }

    function addContract(bytes32 _name, address _addr) public validateOverwrite(_name) returns (bool result) {
        return super.addContract(_name, _addr);
    }
}
