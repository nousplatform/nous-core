pragma solidity ^0.4.18;


import "zeppelin-solidity/contracts/ownership/Ownable.sol";


contract DougProtectionRewriting is Ownable {

    mapping (bytes32 => bool) public notOverWrite;

    modifier validateOverwrite(bytes32 _name) {
        require(!notOverWrite[_name]);
        _;
    }


    constructor(bytes32[] _names, bool[] _perms) {
        for (uint i = 0; i < _names.length; i++) {
            addProtection(_names[i], _perms[i]);
        }
    }

    function addProtection(bytes32 _name, bool _perm) public validateOverwrite(_name) onlyOwner returns(bool) {
        notOverWrite[_name] = _perm;
    }
}
