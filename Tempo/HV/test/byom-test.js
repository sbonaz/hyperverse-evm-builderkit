/ USING MOCHA FRAMEWORK FOR TESTING
// Unit tests are written using the Chai Assertion library while using Hardhat to compile and deploy smart contracts.
const { expect } = require('chai'); // Chai packet has be downloaded fro hardhat during projet installation
const { BigNumber } = require('ethers');
const { hdht } = require('hardhat');
let unitMultiple = new BigNumber.from(10).pow(new BigNumber.from(3));
let initialSupply = new BigNumber.from(1000000000).mul(unitMultiple);

// STEP 1: SMART CONTRACT, FACTORY AND PERSONAS DEFINITION
describe('BYOM', function () {
	let BYOMMain;
	let byomMainCtr;
	let BYOMFactory;
	let byomFactoryCtr;
	let aliceProxyContract; // The Smart Contract Proxy Pattern allows you to upgrade contracts even after deployment.
	let alice;
	let bob;
	let cara;
	// need to check that only Kyced and notSanctioned user allow
	

	// STEP 2: CONTRACTS COMPILING AND DEPLOYMENT (USING HARDHAT)

	beforeEach(async () => {
		BYOMMain = await hdht.getContractFactory('BYOM');
		[owner, alice, bob, cara] = await hdht.getSigners();	
		byomMainCtr = await BYOMMain.deploy(owner.address);
		await byomMainCtr.deployed();
		BYOMFactory = await hdht.getContractFactory('BYOMFactory');
		byomFactoryCtr = await BYOMFactory.deploy(byomMainCtr.address, owner.address);
		await byomFactoryCtr.deployed();
		await byomFactoryCtr.connect(alice).createInstance(alice.address, 'BYOM', 'BYM', 'EUR', '1', '6');
		aliceProxyContract = await BYOMMain.attach(await byomFactoryCtr.getProxy(alice.address));
	});

	// STEP 3: MASTER CONTRACT'S FUNCTIONAL TESTS DESCRIPTION

		// >>>>>>>>>>>>>>> State initialization test description  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
	describe('Initial State Variables', function () {
		it('Master Contract should match byomMainCtr', async function () {
			expect(await byomFactoryCtr.masterContract()).to.equal(byomMainCtr.address);
		});
		it("Should match alice's initial byom data", async function () {
			expect(await aliceProxyContract.name()).to.equal('BYOM');
			expect(await aliceProxyContract.symbol()).to.equal('BYM');
			expect(await aliceProxyContract.pegCurr()).to.equal('EUR');
			expect(await aliceProxyContract.pegRate()).to.equal('1');						
			expect(await aliceProxyContract.decimals()).to.equal(6);
		});
		it('Should have the correct supply of byoms using totalSupply()', async function () {
			expect(await aliceProxyContract.totalSupply()).to.equal(initialSupply);
		});
		it('Should have correct balance of byoms using balance() and balanceOf()', async function () {
			expect(await aliceProxyContract.connect(alice).balance()).to.equal(initialSupply);
			expect(await aliceProxyContract.balanceOf(alice.address)).to.equal(initialSupply);
		});
	});
		// >>>>>>>>>>>>>>> User minting (deposit at DApp level) test  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
	describe('Minting (Deposit)', function () {
		it('Should mint byoms using mint()', async function () {
		const amount = new BigNumber.from(500).mul(unitMultiple);
		const mintTxn = await aliceProxyContract.connect(alice).mint(amount);
		const newBal = await aliceProxyContract.balanceOf(alice.address);
		expect(newBal).to.equal(initialSupply.add(amount));
		});
		it('Should not mint byoms using mint() if not owner', async function () {
		const amount = new BigNumber.from(500).mul(unitMultiple);
		await expect(
			aliceProxyContract.connect(bob).mint(amount)
		).to.be.revertedWith('Unauthorized()');
		});	
	});				
		// >>>>>>>>>>>>>>> A user transfer test  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
	describe('Transfer', function () {
		it('Should be able to transfer funds using transfer()', async function () {
			const sourceAccount = alice.address;
			const targetAccount = cara.address;
			const amount = new BigNumber.from(1000);
			const sourceOldBal = await aliceProxyContract.balanceOf(sourceAccount);
			const targetOldBal = await aliceProxyContract.balanceOf(targetAccount);
			const transferTxn = await aliceProxyContract
				.connect(alice)
				.transfer(targetAccount, amount);
			const sourceNewBal = await aliceProxyContract.balanceOf(sourceAccount);
			const targetNewBal = await aliceProxyContract.balanceOf(targetAccount);
			expect(sourceNewBal).to.not.equal(sourceOldBal);
			expect(targetOldBal).to.not.equal(targetNewBal);
			expect(sourceNewBal).to.equal(sourceOldBal.sub(amount));
		});
		it('Should approve funds tranfer using approve() and check spend amount using allowance()', async function () {
			const sourceAccount = alice.address;
			const targetAccount = cara.address;
			const amount = new BigNumber.from(500).mul(unitMultiple);
			await aliceProxyContract.connect(alice).approve(targetAccount, amount);
			const allowance = await aliceProxyContract.allowance(sourceAccount, targetAccount);
			expect(allowance).to.equal(amount);
		});
		it('Should transfer allowance funds between accounts using tranferFrom()', async function () {
			const sourceAccount = alice.address;
			const targetAccount = cara.address;
			const authorizedAccount = bob.address;
			const amount = new BigNumber.from(500).mul(unitMultiple);
			const sourceOldBal = await aliceProxyContract.balanceOf(sourceAccount);
			const targetOldBal = await aliceProxyContract.balanceOf(targetAccount);
			await aliceProxyContract.connect(alice).approve(authorizedAccount, amount);
			let oldAllowance = await aliceProxyContract.allowance(sourceAccount, authorizedAccount);
			await aliceProxyContract
				.connect(bob)
				.transferFrom(sourceAccount, targetAccount, amount);
			let sourceNewBal = await aliceProxyContract.balanceOf(sourceAccount);
			let targetNewBal = await aliceProxyContract.balanceOf(targetAccount);
			let newAllowance = await aliceProxyContract.allowance(sourceAccount, authorizedAccount);
			expect(sourceNewBal).to.not.equal(sourceOldBal);
			expect(targetOldBal).to.not.equal(targetNewBal);
			expect(oldAllowance).to.not.equal(newAllowance);
			expect(sourceNewBal).to.equal(sourceOldBal.sub(amount));
			expect(newAllowance).to.equal(oldAllowance.sub(amount));
			expect(newAllowance).to.equal(0);
		});
		it('Should not transfer funds between acounts using transferFrom() unless authorized', async function () {
			const sourceAccount = alice.address;
			const targetAccount = cara.address;
			const authorizedAccount = bob.address;
			const amount = new BigNumber.from(500).mul(unitMultiple);
			// const transferTxn = await aliceProxyContract.connect(bob).transferFrom(sourceAccount, targetAccount, amount);
			await expect(
				aliceProxyContract.connect(bob).transferFrom(sourceAccount, targetAccount, amount)
			).to.be.revertedWith('InsufficientAllowance()');
		});
	});
// >>>>>>>>>>>>>>> Owner burning (withdrawal at DApp level) test  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
	describe('Burning (Withdrawal)', function () {
		it('Should burn Alice\'s byoms', async function () {
		const amount = new BigNumber.from(500).mul(unitMultiple);
		const oldBal = await aliceProxyContract.balanceOf(alice.address);
		await aliceProxyContract.connect(alice).burn(amount);
		const newBal = await aliceProxyContract.balanceOf(alice.address);
		expect(oldBal).to.not.equal(newBal);
		expect(newBal).to.equal(initialSupply.sub(amount));
		})
	});
});