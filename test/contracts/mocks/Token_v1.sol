pragma solidity ^0.4.24;

import "../../../contracts/CardstackToken.sol";

contract Token_v1 is CardstackToken {
  function getVersion() public pure returns (string) {
    return "v1";
  }
}
