
let RegistryContract = artifacts.require("./Registry.sol");
let CardStackToken = artifacts.require("./CardStackToken.sol");

const cstRegistryName = 'cst';

module.exports = async function(callback) {
  let registry = await RegistryContract.deployed();
  let cstAddress = await registry.contractForHash(web3.sha3(cstRegistryName));
  let cst = await CardStackToken.at(cstAddress);

  try {
    await cst.freezeToken(true);
    console.log(`Freezing token for CST (${cst.address})`);
  } catch (err) {
    console.error(`Error freezing token for CST (${cst.address}, ${err.message}`);
  }

  callback();
};
