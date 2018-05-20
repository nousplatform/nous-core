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
        mapping(bytes32 => address) contracts;
    }

    modifier isProjectContract_(bytes32 _tplName) {
        address _tdb = getContractAddress("TemplatesDb");
        require(msg.sender == TemplatesDb(_tdb).template(_tplName, 0));
        _;
    }

    // ownerFund => projecttype => tplstruct
    mapping (address => mapping(bytes32 => TmpTpl[])) tempContracts;

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
        //TmpTpl storage _tpl = tempContracts[_owner][_projectType][_id];
        //_tpl.contracts[_contractName] = _contractAddr;
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
