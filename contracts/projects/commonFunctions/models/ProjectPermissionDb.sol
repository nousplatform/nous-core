pragma solidity ^0.4.18;


import "../../../doug/models/PermissionsDb.sol";


contract ProjectPermissionDb is PermissionsDb {

    constructor(address _nous, address _owner)
    PermissionsDb(_owner) {
        permission[_nous] = "nous";
    }

    /**
    * @notice
    * @dev Permission (nous) is not overwrite
    * @param _addr User address
    * @param _role User role
    * @return
    */
    function setPermission(address _addr, string _role) returns (bool) {
        require(_role != "nous");
        return super.setPermission(_addr, _role);
    }
}
