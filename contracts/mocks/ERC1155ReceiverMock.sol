// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../token/ERC1155/IERC1155Receiver.sol";
import "./ERC165Mock.sol";
import "../Initializable.sol";

contract ERC1155ReceiverMockUpgradeSafe is Initializable, IERC1155Receiver, ERC165MockUpgradeSafe {
    bytes4 private _recRetval;
    bool private _recReverts;
    bytes4 private _batRetval;
    bool private _batReverts;

    event Received(address operator, address from, uint256 id, uint256 value, bytes data, uint256 gas);
    event BatchReceived(address operator, address from, uint256[] ids, uint256[] values, bytes data, uint256 gas);


    constructor(
        bytes4 recRetval,
        bool recReverts,
        bytes4 batRetval,
        bool batReverts
    ) public  {
        __ERC1155ReceiverMock_init(recRetval, recReverts, batRetval, batReverts);
    }

    function __ERC1155ReceiverMock_init(
        bytes4 recRetval,
        bool recReverts,
        bytes4 batRetval,
        bool batReverts
    ) internal initializer {
        __ERC165_init_unchained();
        __ERC165Mock_init_unchained();
        __ERC1155ReceiverMock_init_unchained(recRetval, recReverts, batRetval, batReverts);
    }

    function __ERC1155ReceiverMock_init_unchained(
        bytes4 recRetval,
        bool recReverts,
        bytes4 batRetval,
        bool batReverts
    ) internal initializer {


        _recRetval = recRetval;
        _recReverts = recReverts;
        _batRetval = batRetval;
        _batReverts = batReverts;

    }


    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
        external
        override
        returns(bytes4)
    {
        require(!_recReverts, "ERC1155ReceiverMock: reverting on receive");
        emit Received(operator, from, id, value, data, gasleft());
        return _recRetval;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
        external
        override
        returns(bytes4)
    {
        require(!_batReverts, "ERC1155ReceiverMock: reverting on batch receive");
        emit BatchReceived(operator, from, ids, values, data, gasleft());
        return _batRetval;
    }

    uint256[49] private __gap;
}