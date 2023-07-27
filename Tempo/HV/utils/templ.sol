
describe('BYOM', function () {

	beforeEach(
        async () => {
	    }
    );

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

		it('Should have the correct supply off byoms using totalSupply()', async function () {
			expect(await aliceProxyContract.totalSupply()).to.equal(initialSupply);
		});

		it('Should have correct balance of byoms using balance() and balanceOf()', async function () {
			expect(await aliceProxyContract.connect(alice).balance()).to.equal(initialSupply);
			expect(await aliceProxyContract.balanceOf(alice.address)).to.equal(initialSupply);
		});

	});

    describe('BalanceOf', function () {

     });

    describe('Balance', function () {

     });

    describe('Allowance', function () {

     });

    describe('approve', function () {

     });

    describe('Transfer', function () {

     });

    describe('TransferFrom', function () {

     });

    describe('Minting', function () {
    });

    describe('Burning', function () {

     });

    describe('Deposit', function () {

     });

    describe('Withdrawl', function () {

     });

})

    