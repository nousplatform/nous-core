const Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const Test_2 = artifacts.require("Test_2.sol");
const Test = artifacts.require("Test.sol");

const testInitialParams = {
  action: "ActionAddAction",
  methodParam: "execute(bytes32, addr)",
  data: ["ActionSetActionPermission", "0x1"]
}

function callToFunction(param = testInitialParams) {
  let str = web3.utils.sha3(param.methodParam).substr(0,10);
  web3.utils.hexToBytes('0x000000ea');
}



contract('NousCore', async function (accounts) {

  let test2Inst;
  let testInst;

  beforeEach(async function () {
    test2Inst = await Test_2.new();
    testInst = await Test.new();
    console.log("test2Inst.address", test2Inst.address);
    console.log("testInst.address", testInst.address);
  });

  it("Test Deploy all nous core contracts ", async function () {

      let data = await web3.eth.abi.encodeFunctionCall({
          name: 'test1',
          type: 'function',
          inputs: [{
              type: 'uint256',
              name: 'num'
          }]
      }, ['50']);

      console.log("data", data);
      console.log("testInst.address", testInst.address)

      let res = await test2Inst.execute(testInst.address, data);

      let data2 = web3.eth.abi.encodeParameters(['uint256'], ['10']);

      let res2 = await test2Inst.getexecute(testInst.address, data2);
      console.log("res", res2.toNumber());


      //console.log("test2Inst.addr()", await test2Inst.testAddr());

      //let res = await test2Inst.execute(testInst.address, data);
      //console.log("res", res);

      console.log("testInst.getState()", (await testInst.getState()).toNumber());

  });


})
