pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";
import {TemplatesDbInterface as TemplatesDb} from "./TemplatesDb.sol";


interface ProjectDbInterface {

    function addProject(
        address _owner,
        bytes32 _type,
        bytes32 _name,
        address _addr,
        uint _id
    ) external returns(bool);
}


contract ProjectDb is Validee {

    event CreateProject(address indexed owner, address indexed fund, string projectName, string projectType);

    struct TmpTpl {
        bytes32 name;
        address addr;
    }

    struct Ids {
        mapping(uint => TmpTpl[]) ids;
        uint[] idsIndex;
    }

    // ownerFund => projecttype => tplstruct
    mapping (address => mapping(bytes32 => Ids)) public tempContracts;


    modifier isProjectContract_(bytes32 _tplName) {
        address _tdb = getContractAddress("TemplatesDb");
        require(msg.sender == TemplatesDb(_tdb).template(_tplName, 0));
        _;
    }

    function addProject(
        address _owner,
        bytes32 _projectType,
        bytes32 _contractName,
        address _contractAddr,
        uint _id
    )
    //isProjectContract_(_tplName)
    public
    {
        require(_owner != address(0));
        require(_contractName != bytes32(0));
        require(_contractAddr != address(0));

        require(validate());

        tempContracts[_owner][_projectType].push(TmpTpl({
            name: _contractName,
            addr: _contractAddr
        }));
    }

    // -----
    function getProjectContracts(
        address _owner,
        bytes32 _type/*,
        uint _id,
        bytes32 _contractName*/
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
