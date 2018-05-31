const Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const ActionManager = artifacts.require("ActionManager.sol");

const ActionManagerInstance = ActionManager.at(
  "0xe0b292985d35e38ee4a4689f973973374ac48512"
);
async function actionManagerQuery(actionNmae, data) {
  let structure = actionsParams[actionNmae];
  let bytes = getFunctionCallData(structure, data);
  console.log("bytes", bytes);

  return (await ActionManagerInstance.execute(actionNmae, bytes)).tx;
}

function getFunctionCallData({ name, inputs = [] }, _data = null) {
  return web3.eth.abi.encodeFunctionCall(
    {
      name: name,
      type: "function",
      inputs: inputs
    },
    _data
  );
}

//ActionAddTemplates execute(bytes32[] _names, address[] _addrs, bool[] _overwrite)
let _data = [
  [web3.utils.toHex("TPLComponentsOEFund3")],
  ["0x18e37b7bc2dbf1c7ab25f0a09d5d4164b58707c6"],
  [true]
];
actionManagerQuery("ActionAddTemplates", _data);

//
// -----==========CONTRACT NOUS CORE==========-----
//   NousCore:  0x51a80300715b542e02eda50eba28030a1ac06773
// ActionManager:  0xe0b292985d35e38ee4a4689f973973374ac48512
// ActionDb:  0x7d0b2d618fd56fbe5e386d0a19c650532d2ffc35
// PermissionDb:  0xd1cb1ce50d3296234cde7b00ae068983f8b0a452
// TemplatesDb:  0xd1aea5a705d37a0524c84c45dcf9c3b01ad87562  0xdf6d79be050683f5193232fa912c0269b643e02d
// ProjectDb:  0x3708df84c060f9f2eb630fc5503a24a53edf8d10
//
// -----==========ACTION ADDRESSES==========-----
//   ActionAddAction:  0x79bb2351efdb6403e8d82d37ad4108aa7ed4558c
// ActionAddActions:  0x51eab26cc4de2de8fce16bd98703ba4cafd1c440
// ActionRemoveAction:  0x65bee0a6ab654abb0f368979a589dbfc41c3d0df
// ActionLockActions:  0xe7b40438bf70aa2e568f738cfea39c284cecf53a
// ActionUnlockActions:  0x156be2b86cbe4130c9cd82b7370ca272b3c2b6e3
// ActionSetUserRole:  0xdf355ecae92bdaee617ea5476e4a9ec12faadcad
// ActionAddUser:  0xde08ada76ac2045eb3b7f3456fe84aec18a6cf06
// ActionSetActionPermission:  0x16b862918c6dd8df316662b2168b1dac145154df
// ActionCreateOpenEndedFund:  0xdc17232f48784ff24094a8d85a6e30adea8baefa
// ActionAddTemplates:  0x841aff4c91f80559e65008b09a731393846e8caa
// ActionCreateActionsOEFund1:  0x823068063a381a5abc97cf5fb740542802b2eda3
// ActionCreateActionsOEFund2:  0x57566d9fd5925e162a3f0f9445ab6c8d9abc8afe
// ActionCreateCompOEFund1:  0x6c9ebc433a6d160ec9c7b60ce9db5cea0dd9a1c6
// ActionCreateCompOEFund2:  0xa693caa436a071a52b04b08b3546f7554184776c
// ActionCreateCompOEFund3:  0x42201653e6d7eeed9972d7c3b775164caaa58aca
//
// -----==========TEMPLATES ADDRESSES==========-----
//   TPLConstructorOpenEndedFund:  0xd65824eae8912eae5e7d24bf8cd24e4541aee319
// TPLActionManager:  0xe8bfc9652c8d12a727e3483952716da2df5c2868
// TPLOpenEndedSaleDb:  0x4675a15939cab3d9581bdbde9e09d9bdda3faaba
// TPLOpenEndedToken:  0xd0d67caef209f3b906db639e3efc5d6bfadf0bd8
// TPLProjectActionDb:  0x893c8220eacd87348f568751abbb760339032bce
// TPLProjectPermissionDb:  0xcb329b6e9b0c1afa288fd889bb9eb3721444317f
// TPLSnapshotDb:  0x7a79b449d417cb53d3a3a6f372d8d84b5728fca5
// TPLWalletDb:  0xc1972ecf42a73f0a119ec6b5acefe3e04f184d96
// TPLComponentsOEFund1:  0x335bf466cac349ee2067b1b2a16f84c28665e14a
// TPLComponentsOEFund2:  0x49bfe1887ac93ca483ba729597fbf8de630eb6a6
// TPLComponentsOEFund3:  0x013ee350e41bbe7f9ad5fca87da97ae3c2707062
// TPLActionsOEFundStep1:  0xd788964a448a838164d0516d29b93047e01496b6
// TPLActionsOEFundStep2:  0x7883e1d05f30d1c0010fe976176e345386ff23c9
