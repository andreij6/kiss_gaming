const KissRaffleToken = artifacts.require("KissRaffleToken");

module.exports = function (deployer) {
  
  //bsc
  
  var kissToken = '0x9F12CAd130D40d40541CaE8e3c295228769ad111';
  var vrfCoordinator = '0x747973a5A2a4Ae1D3a8fDF5479f1514F65Db9C31';
  var linkToken = '0x404460C6A5EdE2D891e8297795264fDe62ADBB75';
  var keyHash = '0xc251acd21ec4fb7f31bb8868288bfdbaeb4fbfec2df3735ddbd4f7dc8d60103c'
  
  deployer.deploy(KissRaffleToken, kissToken, vrfCoordinator, linkToken, keyHash);

};