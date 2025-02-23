// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts-upgradeable/proxy/UUPS/UUPSUpgradeable.sol";

contract EdenTokenProxy is UUPSUpgradeable {
    address public implementation;

    constructor(address _implementation, bytes memory _data) {
        _disableInitializers();
        _setImplementation(_implementation);
        if (_data.length > 0) {
            (bool success, ) = _implementation.delegatecall(_data);
            require(success, "Initialization failed");
        }
    }

    fallback() external payable {
        _fallback();
    }

    function _setImplementation(address newImplementation) internal virtual override {
        require(newImplementation != address(0), "Invalid implementation address");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }

    function upgradeTo(address newImplementation) public onlyOwner {
        _setImplementation(newImplementation);
    }
}
