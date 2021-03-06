pragma solidity ^0.4.18;


import "../../doug/safety/Validee.sol";


contract TemplatesDbInterface {
    mapping (bytes32 => address[]) public templates;
    function template(bytes32 _name, uint _version) external view returns(address);
    function addTemplate(bytes32 _name, address _addr) public;
}

contract TemplatesDb is Validee {

    /// defaultTpl[name_contract][version_uint][address] = struct TemplateDetails
    mapping (bytes32 => address[]) public templates;

    event AddTemplate (bytes32 indexed name, address tplAddr, uint version);

    //add or edit default contracts
    function addTemplate(
        bytes32 _name,
        address _addr
    )
    public
    validate_
    {
        // set doug address if not set rejected operation
        DougEnabled(_addr).setDougAddress(DOUG);
        templates[_name].push(_addr);
        emit AddTemplate(_name, _addr, templates[_name].length);
    }

    /**
    * @notice return last version contract
    */
    function template(
        bytes32 _name,
        uint256 _version
    )
    external
    view
    returns(address)
    {
        uint256 _ver;
        if (_version == 0) {
            _ver = templates[_name].length - 1;
        }

        return templates[_name][_ver];
    }

}
