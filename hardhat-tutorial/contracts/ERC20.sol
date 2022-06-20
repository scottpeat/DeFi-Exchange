// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    address public cryptoDevTokenAddress;

    // Exchange is inheriting ERC20, because our exchange would keep track of Crypto Dev LP tokens
    constructor(address _CryptoDevtoken) ERC20("CryptoDev LP Token", "CDLP") {
        require(
            _CryptoDevtoken != address(0),
            "Token address passed is a null address"
        );
        cryptoDevTokenAddress = _CryptoDevtoken;
    }

    /**
     * @dev Returns the amount of `Crypto Dev Tokens` held by the contract
     */
    function getReserve() public view returns (uint256) {
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

    /**
     * @dev Adds liquidity to the exchange.
     */
    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint256 liquidity;
        uint256 ethBalance = address(this).balance;
        uint256 cryptoDevTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);
        /*
        If the reserve is empty, intake any user supplied value for
        `Ether` and `Crypto Dev` tokens because there is no ratio currently
    */
        if (cryptoDevTokenReserve == 0) {
            // Transfer the `cryptoDevToken` from the user's account to the contract
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);
            // Take the current ethBalance and mint `ethBalance` amount of LP tokens to the user.
            // `liquidity` provided is equal to `ethBalance` because this is the first time user
            // is adding `Eth` to the contract, so whatever `Eth` contract has is equal to the one supplied
            // by the user in the current `addLiquidity` call
            // `liquidity` tokens that need to be minted to the user on `addLiquidity` call should always be proportional
            // to the Eth specified by the user
        }
    }
}
