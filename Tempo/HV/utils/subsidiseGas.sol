

export async function voteToOtherUser(senderAccount:String, senderPrivateKey:String, senderUserId:Number, receiverAccount:String, receiverUserId:Number) {
    const Web3 = require('web3');
    const web3 = new Web3(new Web3.providers.HttpProvider(process.env.INFURA_ENDPOINT)); 
    const contract = new web3.eth.Contract(SITokenABI, TOKEN_CONTRACT_ADDRESS, { from: TOKEN_CONTRACT_DEPLOYED_OWNER_ADDRESS, gas: GAS_FEE});
     //디코딩
    const decryptedPrivateKey = require('aes256').decrypt(process.env.PRIVATE_KEY_SECRET, senderPrivateKey)

    // web3.eth.accounts.wallet.add(decryptedPrivateKey);
    // console.log("result", await contract.methods.transfer(receiverAccount, VOTING_TOKEN_AMOUNT).call())


    console.log(await contract.methods.approve(senderAccount, VOTING_TOKEN_AMOUNT).call())
    console.log(await contract.methods.allowance(senderAccount, TOKEN_CONTRACT_ADDRESS).call())
   console.log( await contract.methods.transferFrom(senderAccount, receiverAccount, VOTING_TOKEN_AMOUNT).call())
    
    updateUserBalance(senderUserId, senderAccount)
    updateUserBalance(receiverUserId, receiverAccount)
}