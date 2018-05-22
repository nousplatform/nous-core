pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";
import {TemplatesDbInterface as TemplatesDb} from "./TemplatesDb.sol";


interface ProjectDbInterface {
    // ---- //
    function addContract(
        address _owner,
        bytes32 _projectType,
        bytes32 _contractName,
        address _contractAddr,
        uint _id
    ) external;
    // ---- //
    function createNewProjectId(
        address _owner,
        bytes32 _projectType
    )
    external
    returns (uint);
    // ---- //
    function getLasId(
        address _owner,
        bytes32 _projectType
    )
    external
    view
    returns (uint);
}


contract ProjectDb is Validee {

    event AddsContract(address indexed owner, bytes32 indexed projectType, bytes32 contractName, address contractAddress);

    // collections contracts array
    struct Contract {
        bytes32 name;
        address addr;
    }

    // current _id
    struct Collect {
        mapping(uint => Contract[]) collects;
        uint256 id;
    }

    // owner address
    // type_project
    mapping (address => mapping(bytes32 => Collect)) public projects;

    function addContract(
        address _owner,
        bytes32 _projectType,
        bytes32 _contractName,
        address _contractAddr,
        uint _id
    )
    validate_
    external
    {
        require(_owner != address(0));
        require(_projectType != bytes32(0));
        require(_contractName != bytes32(0));
        require(_contractAddr != address(0));

        Collect storage collect = projects[_owner][_projectType];
        collect.collects[_id].push(Contract(_contractName, _contractAddr));
        emit AddsContract(_owner, _projectType, _contractName, _contractAddr);
    }

    // @notice
    function createNewProjectId(
        address _owner,
        bytes32 _projectType
    )
    external
    validate_
    returns (uint)
    {
        Collect storage collect = projects[_owner][_projectType];
        return ++collect.id;
    }

    //// -------
    function getLasId(
        address _owner,
        bytes32 _projectType
    )
    external
    view
    returns (uint)
    {
        return projects[_owner][_projectType].id;
    }

    //// -----
    function getProjectContracts(
        address _owner,
        bytes32 _type,
        uint _id
    )
    external
    view
    returns (bytes32[] memory names, address[] memory addrs)
    {
        uint id = _id;
        if (_id == 0) {
            id = projects[_owner][_type].id;
        }
        uint _length = projects[_owner][_type].collects[id].length;

        names = new bytes32[](_length);
        addrs = new address[](_length);
        for (uint i = 0; i < _length; i++) {
            names[i] = projects[_owner][_type].collects[id][i].name;
            addrs[i] = projects[_owner][_type].collects[id][i].addr;
        }

        return(names, addrs);
    }

}
