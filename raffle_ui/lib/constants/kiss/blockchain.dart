class Blockchain {
  static const String kissRaffleTokenAddress = '0xaADDC953bBe878720858Ac0CFcd0ed239d34174D';
  static const String kissTokenAddress = '0x9F12CAd130D40d40541CaE8e3c295228769ad111';

  static const int oneKissToken = 1000000000;
  
  static final raffleAbi =[
    'function getExcess() view returns (uint256)',
    'function circulatingSupply() view returns (uint256)',
    'function _winnerShare() view returns (uint256)',
    'function _profitShare() view returns (uint256)',
    'function _delayInDays() view returns (uint256)',
    'function minimumForRaffle() view returns (uint256)',
    'function balanceOf(address) view returns (uint256)',
    'function mintTicket() public returns(bool)',
    'function redeemKiss(uint256 tokenId) public returns(bool)',
    'event Transfer(address indexed from, address indexed to, uint amount)',
    'event Approval(address indexed owner, address indexed spender, uint256 value)',
    'function getOwnedTokenIds() public view returns(uint256[] memory)',
    'function canRedeem(uint256 tokenId) public view returns (bool)'
  ];

  static final kissAbi =[
    'function allowance(address, address) view returns (uint256)',
    'function approve(address, uint256)',
    'function balanceOf(address) view returns (uint256)',
    'event Transfer(address indexed from, address indexed to, uint amount)',
    'event Approval(address indexed owner, address indexed spender, uint256 value)'
  ];
}