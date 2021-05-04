// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../structs/EnumerableSet.sol";
import "../math/Math.sol";


// org.springframework.http.HttpHeaders API : https://docs.spring.io/spring-framework/docs/5.1.x/javadoc-api/index.html?org/springframework/http/HttpHeaders.html

struct Attribute{
    string name;
    string value;
}

// @TODO Who can change attributes ?
// @TODO What if a duplicate pair of name/value is to be added ?
// @TODO For multiple values for a name(key), `Attribute.name`s are redundant. 

contract Attributable{
    using EnumerableSet for EnumerableSet.UintSet;
    using Math for uint256;

    Attribute[] private _attribs;
    mapping(string => EnumerableSet.UintSet) private _idxsByName; // attrib name => attrib indexes
    EnumerableSet.UintSet private _firstIdxs;  // attrib indexes on first values for each name

    event AttributeAdded(string indexed name, string value, uint no);
    event AttributeRemoved(string indexed name, string value);    
    event AttributesRemoved(string indexed name);

    function getAttributeNames() public view returns (string[] memory){
        uint l = _firstIdxs.length();

        string[] memory names = new string[](l);
        for(uint i = 0; i < l; i++){
            names[i] = _attribs[_firstIdxs.at(i)].name;
        }

        return names;
    }
    
    function getAttribute(string memory name) public view returns (string memory){
        uint m = _idxsByName[name].length();
        string memory val;
        if(m > 0) val = _attribs[_idxsByName[name].at(0)].value;
        
        return val;
    }
    
    function getAttributes(string memory name) public view returns (string[] memory){
        uint m = _idxsByName[name].length();
        string[] memory vals = new string[](m);
        
        for(uint i = 0; i < m; i++){
            vals[i] = _attribs[_idxsByName[name].at(i)].value;
        }
        
        return vals;
    }
    
    function getAttributesCount(string memory name) public view returns (uint){
        return _idxsByName[name].length();
    }

    function setAttribute(string memory name, string memory value) public{
        _removeAttributes(name);
        _addAttribute(name, value);
    }
    
    function addAttribute(string memory name, string memory value) public{
        _addAttribute(name, value);
    }
    
    function _addAttribute(string memory name, string memory value) internal{
        uint idx = _attribs.length;
        _attribs.push(Attribute(name, value));
        _idxsByName[name].add(idx);
        uint n = _idxsByName[name].length();
        
        if(n == 1) _firstIdxs.add(idx); 
        emit AttributeAdded(name, value, _idxsByName[name].length());

    }

    function removeAttribute(string memory name, string memory value) public{

        uint m = _idxsByName[name].length();
        if(m == 0) return;
        
        bytes32 hash = keccak256(abi.encodePacked(value));
        string memory val;
        uint idx;
        for(uint i = 0; i < m; i++){
            idx = _idxsByName[name].at(i);
            val = _attribs[idx].value;
            if(keccak256(abi.encodePacked(val)) == hash){
                delete _attribs[idx];
                _idxsByName[name].remove(idx);
                if(_firstIdxs.contains(idx)){
                    _firstIdxs.remove(idx);
                    if(_idxsByName[name].length() > 0){
                        _firstIdxs.add(_idxsByName[name].at(0));
                    }
                }
                emit AttributeRemoved(name, value);
            }
        }
        
    }
    
    function removeAttributes(string memory name) public{
        _removeAttributes(name);

    }
    
    function _removeAttributes(string memory name) internal{
        uint m = _idxsByName[name].length();
        
        if(m > 0){
            uint idx;
            for(uint i = 0; i < m; i++){
                idx = _idxsByName[name].at(i);
                delete _attribs[idx];
                _firstIdxs.remove(idx);
            }
            
            delete _idxsByName[name];
            emit AttributesRemoved(name);
        }
   }

}

