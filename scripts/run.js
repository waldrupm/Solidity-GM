// Compile, deploy, and run the GMPortal contract on the local blockchain
const main = async () => {
  const gmContractFactory = await hre.ethers.getContractFactory("GMPortal")
  const gmContract = await gmContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  })
  await gmContract.deployed()
  console.log(`Contract deployed to ${gmContract.address}`)

  let contractBalance = await hre.ethers.provider.getBalance(gmContract.address)
  console.log(
    `Contract balance: ${hre.ethers.utils.formatEther(contractBalance)}`
  )

  let gmCount
  gmCount = await gmContract.getTotalGMs()
  console.log(gmCount.toNumber())

  let gmTxn = await gmContract.sayGM("A message here")
  await gmTxn.wait()

  const [_, randomPerson] = await hre.ethers.getSigners()

  gmTxn = await gmContract.connect(randomPerson).sayGM("Another message for ya")
  await gmTxn.wait()

  let allGMs = await gmContract.getAllGMs()
  console.log(allGMs)

  gmCount = await gmContract.getTotalGMs()
  console.log(gmCount.toNumber())

  //TODO: Test rewardGMer here
  const [deployer] = await hre.ethers.getSigners()
  rewardTxn = await gmContract
    .connect(deployer)
    .rewardGMer(randomPerson.address)
  await rewardTxn.wait()

  contractBalance = await hre.ethers.provider.getBalance(gmContract.address)
  console.log(
    `Contract balance: ${hre.ethers.utils.formatEther(contractBalance)}`
  )
}

const runMain = async () => {
  try {
    await main()
    process.exit(0)
  } catch (error) {
    console.log(error)
    process.exit(1)
  }
}

runMain()
