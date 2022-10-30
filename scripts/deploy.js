// deploy.js
const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");

  const nftContract = await nftContractFactory.deploy();

  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  let txn;
  // txn = await nftContract.makeAnEpicNFT("Super Artist",{
  //   value: hre.ethers.utils.parseEther("0.01"),
  // });


  txn = await nftContract.makeAnEpicNFT("First Artist", "ff6347", 100, 100);
  await txn.wait();
  console.log("Minted NFT");

  txn = await nftContract.makeAnEpicNFT("Second Artist", "008080", 580, 580);
  await txn.wait();
  console.log("Minted NFT");

  txn = await nftContract.makeAnEpicNFT("Third Artist", "b22222", 340, 340);
  await txn.wait();
  console.log("Minted NFT");

  // txn = await nftContract.updateNFT();
  // await txn.wait();
  // console.log("UPDATE NFT.");
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