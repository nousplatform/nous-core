pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


interface TemplatesDbInterface {
    function template(bytes32 _name, bytes32 _version) external returns(address, bool, bytes32);
}


contract TemplatesDb is Validee {

    /// address contract,
    /// boll type allow of rewrite contract
    struct ContractDetails {
        address addr;
        bool overwrite;
        bytes32 version;
    }

    /// defaultContracts[name_contract][version.1.0] = struct ContractDetails
    mapping (bytes32 => ContractDetails[]) public defaultContracts;

    bytes32[] contractsList;

    //add or edit default contracts
    function addContract(bytes32[] _names, address[] _addrs, bytes32[] _version, bool[] _overwrite) public returns(bool) {

        require(validate());
        /*if (!validate()) {
            return false;
        }*/

        for (uint256 i = 0; i < _names.length; i++) {
            if (defaultContracts[_names[i]].length == 0) {
                contractsList.push(_names[i]);
            }
            ContractDetails memory contr; //defaultContracts[_names[i]];
            contr.addr = _addrs[i];
            contr.overwrite = _overwrite[i];
            contr.version = _version[i];
            defaultContracts[_names[i]].push(contr);
        }
        return true;
    }

    /// return last version contract
    function template(bytes32 _name, bytes32 _version) public returns(address, bool, bytes32) {

        uint _item = 0;

        if (_version.length != 0) {
            uint _length = defaultContracts[_name].length;
            for (uint i = 0; i < _length; i++) {
                if (defaultContracts[_name][i].version == _version) {
                    _item = i;
                    break;
                }
            }
        }

        if (_item == 0) {
            _item = defaultContracts[_name].length - 1;
        }

        ContractDetails memory contr = defaultContracts[_name][_item];
        return (contr.addr, contr.overwrite, contr.version);
    }

    function getDefaultContracts() public constant returns (bytes32[], address[]) {
        uint length = contractsList.length;
        bytes32[] memory names = new bytes32[](length);
        address[] memory addr = new address[](length);
        for (uint i = 0; i < length; i++) {
            names[i] = contractsList[i];
            uint lastVersionContract = defaultContracts[contractsList[i]].length - 1;
            addr[i] = defaultContracts[contractsList[i]][lastVersionContract].addr;
        }
        return (names, addr);
    }

}
