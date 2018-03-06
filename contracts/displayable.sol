pragma solidity ^0.4.19;

contract displayable {
  function bytes32ToString(bytes32 x) public pure returns (string) {
    bytes memory bytesString = new bytes(32);
    uint256 charCount = 0;
    for (uint256 j = 0; j < 32; j++) {
      byte char = byte(bytes32(uint256(x) * 2 ** (8 * j)));
      if (char != 0) {
        bytesString[charCount] = char;
        charCount++;
      }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (j = 0; j < charCount; j++) {
      bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
  }
}
