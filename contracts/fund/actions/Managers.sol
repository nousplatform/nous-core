pragma solidity ^0.4.4;


import "./Permission.sol";
import "../interfaces/ManagerProvider.sol";


contract Managers is Permission {

    //@dev Managers actions
    function addManager(address managerAddress, bytes32 firstName, bytes32 lastName, bytes32 email) external returns (bool) {
        require(!checkPermission("owner"));
        address managerdb = getContractAddress("manager_db");
        return ManagerProvider(managerdb).insertManager(managerAddress, firstName, lastName, email);
    }

    function delManager(address managerAddress) external returns (bool) {
        require(!checkPermission("owner"));
        address managerdb = getContractAddress("manager_db");
        return  ManagerProvider(managerdb).deleteManager(managerAddress);
    }

}
