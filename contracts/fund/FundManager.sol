pragma solidity ^0.4.18;


/**
* Found Manager
* This components check user permission and coll actions on components
* Permission: ( )
*
*/
import "./interfaces/FundInterface.sol";
import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./actions/Wallets.sol";
import "../base/Construct.sol";
import "./interfaces/PermissionProvider.sol";


contract FundManager is Wallets, Construct {


}
