import 'package:flutter_web3/ethers.dart';

final abi =[
  "function getExcess() view returns(uint256)"
];

final address = "0xC5eB1F7eC9561EC5eE2D8Da112C747C9b21592F7";

final krt = Contract(address, abi, provider!);