// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Pool} from "../src/Pool.sol";
import {Token} from "../src/Token.sol";

contract PoolTest is Test {
    Pool public pool;
    Token public token;

    function setUp() public {
        token = new Token();
        token.mint(2e18);

        pool = new Pool(token);

        token.transfer(address(pool), 1e18);
        payable(address(pool)).transfer(1e18);
    }

    function testETHDoubleCount() public {
        uint startingBalance = token.balanceOf(address(this));
        uint endingBalance;

        uint alpha = 1e18;
        (uint x, uint y) = pool.getReserves();
        uint beta = alpha * y / (x + alpha);

        pool.swapEthForToken{value: alpha}();

        endingBalance = token.balanceOf(address(this));

        assertLt(endingBalance - startingBalance, beta);
    }
}
