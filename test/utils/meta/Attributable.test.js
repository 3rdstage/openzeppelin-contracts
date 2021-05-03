const { BN, constants, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');


const Attributable = artifacts.require('Attributable');

contract('Attributable', function (accounts) {
  
  

  it('start with no attributes', async function () {
    
    const cntr = await Attributable.new();
    
    expect(await cntr.getAttributeNames()).to.be.empty;
    expect(await cntr.getAttribute('name')).to.be.empty;
    expect(await cntr.getAttributes('name')).to.be.empty;

    console.log('getAttributeNames() : ', await cntr.getAttributeNames());
    console.log('getAttribute("name") : ', await cntr.getAttribute('name'));
    console.log('getAttributes("name") : ', await cntr.getAttributes('name'));

  });
  
  
  describe("'getAttribute' function", function () {
    it('returns empty string (not null) for a name that is not being contained', async function () {
      const cntr = await Attributable.new();       
      
      expect(await cntr.getAttribute('color')).to.not.be.null;
      expect(await cntr.getAttribute('color')).to.be.empty;
      
      expect(await cntr.getAttribute('width')).to.not.be.null;
      expect(await cntr.getAttribute('width')).to.be.empty;
    });
  });
  
  
  describe("'setAttribute' function", function () {
    
    it('adds a new name/value pair', async function () {
      const cntr = await Attributable.new();       
      expect(await cntr.getAttribute('name')).to.be.empty;
      expect(await cntr.getAttributeNames()).to.be.empty;
      
      // set 1st attribute
      const receipt1 = await cntr.setAttribute('color', 'blue');
      
      // 'event AttributeSet(string indexed name, string value, uint indexed index)'
      expectEvent(receipt1, 'AttributeSet', 
        { name: web3.utils.keccak256('color'), value: 'blue', index: new BN(0)});
      
      expect(await cntr.getAttribute('color')).to.equal('blue');
      expect(await cntr.getAttributeNames()).to.have.members(['color']);
      
      // set 2nd attribute
      const receipt2 = await cntr.setAttribute('width', '100');
      
      expectEvent(receipt2, 'AttributeSet', 
        { name: web3.utils.keccak256('width'), value: '100', index: new BN(1)});
      expect(await cntr.getAttribute('width')).to.equal('100');
      expect(await cntr.getAttributeNames()).to.have.members(['color', 'width']);
      
    });
    
    
  });
  
  
})