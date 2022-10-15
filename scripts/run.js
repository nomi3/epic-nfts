// run.js
const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);
  let txn;
  // txn = await nftContract.makeAnEpicNFT("Super Artist",{
  //   value: hre.ethers.utils.parseEther("0.01"),
  // });

  txn = await nftContract.makeAnEpicNFT("Super Artist", "ff6347", 80, 80);
  await txn.wait();

  // txn = await nftContract.updateNFT();
  // await txn.wait();
  // console.log("UPDATE NFT.");

  let returnedTokenUri = await nftContract.tokenURI(0);
  console.log("Token URI:", returnedTokenUri);
};
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};
runMain();