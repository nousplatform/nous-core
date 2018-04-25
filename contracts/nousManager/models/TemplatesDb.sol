pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


interface TemplatesDbInterface {
    function template(bytes32 _name, bytes32 _version) external returns(address, bool, bytes32);
}


contract TemplatesDb is Validee {

    /// address contract,
    /// boll type allow of rewrite contract
    struct templateDetails {
        address addr;
        bool overwrite;
        //bytes32 version;
        uint index;
    }

    /// defaultTpl[name_contract][version.1.0] = struct templateDetails
    mapping (bytes32 => templateDetails[]) public defaultTpl;

    bytes32[] tplList;

    function isElement(bytes32 _name) returns (bool){
        if(tplList.length == 0) return false;
        return (tplList[defaultTpl[_name][0].index] == _name);
    }

    //add or edit default contracts
    function addTemplate(bytes32 _name, address _addr, bool _overwrite) public returns(bool) {

        require(validate());
        /*if (!validate()) {
            return false;
        }*/

        templateDetails memory tpl;

        if (!isElement(_name)) {
            tpl.index = tplList.push(_name) - 1;
        } else {
            tpl.index = defaultTpl[_name][0].index;
        }

        tpl.addr = _addr;
        tpl.overwrite = _overwrite;
        //tpl.version = _version;
        defaultTpl[_name].push(tpl);

        return true;
    }

    /// return last version contract
    function template(bytes32 _name, uint _version) public constant returns(address, bool, uint) {
        require(isElement(_name));
        if (_version == 0) {
            _version = defaultTpl[_name].length - 1;
        }

        templateDetails memory contr = defaultTpl[_name][_version];
        require(contr.addr != 0x0, "Template address empty");
        return (contr.addr, contr.overwrite, contr.index);
    }

    function getDefaultContracts() public constant returns (bytes32[], address[]) {
        uint length = tplList.length;
        bytes32[] memory names = new bytes32[](length);
        address[] memory addr = new address[](length);
        for (uint i = 0; i < length; i++) {
            names[i] = tplList[i];
            uint lastVersionContract = defaultTpl[tplList[i]].length - 1;
            addr[i] = defaultTpl[tplList[i]][lastVersionContract].addr;
        }
        return (names, addr);
    }

}
