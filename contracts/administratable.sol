pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract administratable {
  using SafeMath for uint256;

  address internal constant primaryInitializer = 0x0AEaF8c2Fe778797CD5464E7EB8351d28da2E823;
  address internal constant stagingInitializer = 0x1E65F71b024937b988fdba09814d60049e0Fc59d;
  address internal constant testingInitializer = 0xEa58Ed38E27dDD7Cf1c6e765B1d61CFC2AE3036E;

  address public owner;
  bool public adminsInitialized;
  address[] public adminsForIndex;
  address[] public superAdminsForIndex;
  mapping (address => bool) public admins;
  mapping (address => bool) public superAdmins;
  mapping (address => bool) private processedAdmin;
  mapping (address => bool) private processedSuperAdmin;

  event AddAdmin(address indexed admin);
  event RemoveAdmin(address indexed admin);
  event AddSuperAdmin(address indexed admin);
  event RemoveSuperAdmin(address indexed admin);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  // Accepting a function param to set initial owner/admins
  // is a potential security vulnerability when using initialize
  // pattern (which is just a public function). So we hard-code
  // our initial admin addresses and use zOS to manage this list.
  function initializeAdmins() internal {
    require(!adminsInitialized, "Contract instance has already initialized the admins");

    owner = primaryInitializer;
    _addSuperAdmin(stagingInitializer);
    _addSuperAdmin(testingInitializer);

    adminsInitialized = true;
  }

  modifier onlyInitializers() {
    require(msg.sender == primaryInitializer ||
            msg.sender == stagingInitializer ||
            msg.sender == testingInitializer);
    _;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyAdmins {
    if (msg.sender != owner && !superAdmins[msg.sender] && !admins[msg.sender]) revert();
    _;
  }

  modifier onlySuperAdmins {
    if (msg.sender != owner && !superAdmins[msg.sender]) revert();
    _;
  }

  constructor() public {
    owner = msg.sender;
  }

  function totalSuperAdminsMapping() public view returns (uint256) {
    return superAdminsForIndex.length;
  }

  function _addSuperAdmin(address admin) internal {
    require(admin != address(0));
    superAdmins[admin] = true;
    if (!processedSuperAdmin[admin]) {
      superAdminsForIndex.push(admin);
      processedSuperAdmin[admin] = true;
    }
  }

  function addSuperAdmin(address admin) public onlySuperAdmins {
    _addSuperAdmin(admin);

    emit AddSuperAdmin(admin);
  }

  function removeSuperAdmin(address admin) public onlySuperAdmins {
    require(admin != address(0));
    superAdmins[admin] = false;

    emit RemoveSuperAdmin(admin);
  }

  function totalAdminsMapping() public view returns (uint256) {
    return adminsForIndex.length;
  }

  function addAdmin(address admin) public onlySuperAdmins {
    require(admin != address(0));
    admins[admin] = true;
    if (!processedAdmin[admin]) {
      adminsForIndex.push(admin);
      processedAdmin[admin] = true;
    }

    emit AddAdmin(admin);
  }

  function removeAdmin(address admin) public onlySuperAdmins {
    require(admin != address(0));
    admins[admin] = false;

    emit RemoveAdmin(admin);
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}
