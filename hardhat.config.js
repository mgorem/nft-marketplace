require("@nomiclabs/hardhat-waffle");

const projectId = "a4905e3b34cc498aa5a839bbcf49b8f2";
const fs = require("fs");
const privateKey = fs.readFileSync(".secret").toString();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
      chainId: 1337,
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${projectId}`,
      accounts: [privateKey],
    },
    // mainnet: {
    //   // url: "https://polygon-mumbai.infura.io/v3/a4905e3b34cc498aa5a839bbcf49b8f2",
    //   // accounts: [],
    // },
  },
  solidity: "0.8.9",
};
