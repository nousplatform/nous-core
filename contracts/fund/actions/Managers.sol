pragma solidity ^0.4.18;


import "./Permission.sol";
import "../interfaces/ManagerProvider.sol";
import "../../lib/Validator.sol";


contract Managers is Permission {

    //@dev Managers actions
    function addManager(address _managerAddress, bytes32 _firstName, bytes32 _lastName, bytes32 _email)
    external returns (bool) {
        require(!checkPermission("owner"));
        require(_managerAddress != 0x0);
        require(_firstName.length > 0);
        require(_lastName.length > 0);
        require(_email.length > 0);

        address managerDb = getContractAddress("manager_db");
        return ManagerProvider(managerDb).insertManager(_managerAddress, _firstName, _lastName, _email);
    }

    function delManager(address managerAddress) external returns (bool) {
        require(!checkPermission("owner"));
        require(managerAddress != 0x0);

        address managerDb = getContractAddress("manager_db");
        return  ManagerProvider(managerDb).deleteManager(managerAddress);
    }

}
