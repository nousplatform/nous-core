pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";
import {TemplatesDbInterface as TemplatesDb} from "./TemplatesDb.sol";


interface ProjectDbInterface {

    function addContract(
        address _owner,
        bytes32 _projectType,
        bytes32 _contractName,
        address _contractAddr
    ) external returns(bool);
}


contract ProjectDb is Validee {

    event CreateProject(address indexed owner, address indexed fund, string projectName, string projectType);

    struct TmpTpl {
        bytes32 name;
        address addr;
    }

    // ownerFund => projecttype => tplstruct
    mapping (address => mapping(bytes32 => TmpTpl[])) public tempContracts;

    function addContract(
        address _owner,
        bytes32 _projectType,
        bytes32 _contractName,
        address _contractAddr
    )
    validate_
    external
    {
        require(_owner != address(0));
        require(_projectType != bytes32(0));
        require(_contractName != bytes32(0));
        require(_contractAddr != address(0));

        tempContracts[_owner][_projectType].push(TmpTpl({
            name: _contractName,
            addr: _contractAddr
        }));
    }

    // -----
    function getProjectContracts(
        address _owner,
        bytes32 _type
    )
    external
    view
    returns (bytes32[] memory names, address[] memory addrs)
    {
        uint _length = tempContracts[_owner][_type].length;
        names = new bytes32[](_length);
        addrs = new address[](_length);
        for (uint i = 0; i < _length; i++) {
            names[i] = tempContracts[_owner][_type][i].name;
            addrs[i] = tempContracts[_owner][_type][i].addr;
        }

        return(names, addrs);
    }

}
