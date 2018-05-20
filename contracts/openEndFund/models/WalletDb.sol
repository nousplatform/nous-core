pragma solidity ^0.4.18;


import {ProjectActionManagerEnabled} from "../actionManager/ProjectActionManagerEnabled.sol";


interface WalletDbInterface {
    function addWallet(bytes32 _symbol, bytes32 _addr) external;
    function confirmWallet(bytes32 _symbol, bytes32 _addr) external;
}

contract WalletDb is ProjectActionManagerEnabled {

    struct Wallet {
        bytes32 symbol;
        bytes32 addr;
        bool confirmed;
    }

    // Ticker wallets ETH
    Wallet[] public wallets;

    function isWallet(
        bytes32 _symbol,
        bytes32 _addr
    )
    internal
    view
    returns (uint)
    {
        uint i = wallets.length;
        while (i > 0) {
            if (wallets[i - 1].symbol == _symbol && wallets[i - 1].addr == _addr) {
                break;
            }
            i--;
        }
        return i;
    }

    // Add new wallet
    function addWallet(
        bytes32 _symbol,
        bytes32 _addr
    )
    external
    isActionManager
    {
        require(isWallet(_symbol, _addr) == 0);
        wallets.push(
            Wallet({
                symbol: _symbol,
                addr: _addr,
                confirmed: false
            })
        );
    }

    /**
    * @dev symbol and address validates on empty in function isWallet
    */
    function confirmWallet(
        bytes32 _symbol,
        bytes32 _addr
    )
    external
    isActionManager
    {
        uint i = isWallet(_symbol, _addr);
        require(i > 0);
        wallets[i - 1].confirmed = true;
    }

}
