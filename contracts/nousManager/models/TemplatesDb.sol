pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


interface TemplatesDbInterface {
    function template(bytes32 _name, uint _version) external constant returns(address, bool, uint);
    function addTmpContract(address _owner, bytes32 _type, bytes32[] _name, address[] _addr) external;
}


contract TemplatesDb is Validee {

    /// address contract,
    /// boll type allow of rewrite contract
    struct TemplateDetails {
        address addr;
        bool overwrite;
        uint index;
    }


    /// defaultTpl[name_contract][version.1.0] = struct TemplateDetails
    mapping (bytes32 => TemplateDetails[]) public defaultTpl;

    bytes32[] tplList;

    struct TmpTpl {
        bytes32 name;
        address addr;
    }

    // ownerFund => tempContracts
    mapping (address => mapping(bytes32 => TmpTpl[])) public tempContracts;


    function isElement(bytes32 _name) view returns (bool) {
        if (tplList.length == 0) return false;
        if (defaultTpl[_name].length == 0) return false;
        return (tplList[defaultTpl[_name][0].index] == _name);
    }

    //add or edit default contracts
    function addTemplate(bytes32 _name, address _addr, bool _overwrite) public returns(bool) {

        require(validate());

        TemplateDetails memory tpl;

        if (!isElement(_name)) {
            tpl.index = tplList.push(_name) - 1;
        } else {
            tpl.index = defaultTpl[_name][0].index;
        }

        tpl.addr = _addr;
        tpl.overwrite = _overwrite;
        defaultTpl[_name].push(tpl);

        return true;
    }

    function addTmpContract(address _owner, bytes32 _type,  bytes32[] _name, address[] _addr) external {
        require(validate());
        for (uint i = 0; i < _name.length; i++) {
            tempContracts[_owner][_type].push(TmpTpl({
                    name: _name[i],
                    addr: _addr[i]
                }));
        }
    }

    function getTplContracts(address _owner, bytes32 _type) public view returns(bytes32[] memory names, address[] memory addrs, bool[] memory owrs) {
        uint _length = tempContracts[_owner][_type].length;
        names = new bytes32[](_length);
        addrs = new address[](_length);
        owrs = new bool[](_length);
        for (uint i = 0; i < _length; i++) {
            names[i] = tempContracts[_owner][_type][i].name;
            addrs[i] = tempContracts[_owner][_type][i].addr;
            owrs[i] = true;
        }
        return(names, addrs, owrs);
    }

    /**
    * @notice return last version contract
    */
    function template(bytes32 _name, uint256 _version) external view returns(address, bool, uint) {
        //require(isElement(_name));
        uint256 _ver;
        if (_version == 0) {
            _ver = defaultTpl[_name].length - 1;
        }

        TemplateDetails memory contr = defaultTpl[_name][_ver];
        return (contr.addr, contr.overwrite, contr.index);
    }



    /*function template(bytes32 _name) public constant returns(address) {
        return defaultTpl[_name][defaultTpl[_name].length - 1].addr;
    }*/


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
