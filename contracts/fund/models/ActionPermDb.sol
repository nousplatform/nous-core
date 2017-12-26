pragma solidity ^0.4.4;


contract ActionPermDb {

    /*struct ActionPermStruct {
        bytes32 index;
        uint8[] perm_level;
    }

    //@dev name_action -> perm_level
    mapping (bytes32 => ActionPermStruct) actionPermission;
    bytes32[] actionIndex;

    function isAction(bytes32 _actionName) public constant returns(bool) {
        if (managerIndex.length == 0 ) return false;
        return actionIndex[actionPermission[_actionName].index] == _actionName;
    }

    function addAction(bytes32 _name, uint8 _perm_lvl) returns(bool) {
        require(msg.sender == nous);
        ActionPermStruct memory _newActionStruct;
        _newActionStruct.perm_level = _perm_lvl;
        _newActionStruct.index = actionIndex.push(_name) - 1;
        actionPermission[_name] = _newActionStruct;
        return true;
    }

    function getActionPermission(bytes32 name) public constant returns(uint8) {
        return actionPermission[name].perm_level;
    }*/
}
