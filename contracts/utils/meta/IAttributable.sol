// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


// org.springframework.http.HttpHeaders API : https://docs.spring.io/spring-framework/docs/5.1.x/javadoc-api/index.html?org/springframework/http/HttpHeaders.html

struct Attribute{
    string name;
    string value;
}

interface IAttributable{

    event AttributeAdded(string indexed name, string value, uint no);
    event AttributeRemoved(string indexed name, string value);    
    event AttributesRemoved(string indexed name);

    function getAttributeNames() external view returns (string[] memory);
    
    function getAttribute(string memory name) external view returns (string memory);

    function getAttributes(string memory name) external view returns (string[] memory);

    function getAttributesCount(string memory name) external view returns (uint);

    function setAttribute(string memory name, string memory value) external;
    
    function addAttribute(string memory name, string memory value) external;

    function removeAttribute(string memory name, string memory value) external;

    function removeAttributes(string memory name) external;

}

