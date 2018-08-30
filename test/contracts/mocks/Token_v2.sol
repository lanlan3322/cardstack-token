pragma solidity ^0.4.24;

import "../../../contracts/CardstackToken.sol";

contract Token_v2 is CardstackToken {
  function getVersion() public pure returns (string) {
    return "v2";
  }

  function foo() public pure returns (string) {
    return 'bar';
  }
}
