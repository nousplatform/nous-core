pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


interface ProjectDbInterface {

    function addProject(address _owner,
        bytes32 _type,
        bytes32 _name,
        address _addr,
        uint _id
    ) external
    returns(bool);

}


contract ProjectDb is Validee {

    event CreateProject(address indexed owner, address indexed fund, string projectName, string projectType);

    struct TmpTpl {
        mapping(bytes32 => address) contracts;
    }

    // ownerFund => projecttype => tplstruct
    mapping (address => mapping(bytes32 => TmpTpl[])) tempContracts;

    function addProject(
        address _owner,
        bytes32 _type,
        bytes32 _name,
        address _addr,
        uint _id
)
    validate_
    external
    {
        require(_owner != address(0));
        require(_name != bytes32(0));
        require(_addr != address(0));
        TmpTpl storage _tpl = tempContracts[_owner][_type][_id];
        _tpl.contracts[_name] = _addr;
    }

    // -----
    function getProjectContract(
        address _owner,
        bytes32 _projectType,
        uint _id,
        bytes32 _contractName
    )
    external
    view
    returns (address)
    {
        return tempContracts[_owner][_projectType][_id].contracts[_contractName];
    }

    // -----
    function getLastIdProjectType(
        address _owner,
        bytes32 _projectType
    )
    external
    view
    returns (uint256)
    {
        return tempContracts[_owner][_projectType].length;
    }

}
