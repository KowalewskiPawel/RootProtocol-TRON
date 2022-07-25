// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {DataTypes} from "../DataTypes.sol";

library IterableMappingPosts {
    // Iterable mapping from address to uint;
    struct Map {
        string[] keys;
        mapping(string => DataTypes.Post) values;
        mapping(string => uint) indexOf;
        mapping(string => bool) inserted;
    }

    function get(Map storage map, string memory key) public view returns (DataTypes.Post memory) {
        return map.values[key];
    }

    function getKeyAtIndex(Map storage map, uint index) public view returns (string memory) {
        return map.keys[index];
    }

    function size(Map storage map) public view returns (uint) {
        return map.keys.length;
    }

    function set(
        Map storage map,
        string memory key,
        DataTypes.Post memory val
    ) public {
        if (map.inserted[key]) {
            map.values[key] = val;
        } else {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, string memory key) public {
        if (!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];
        delete map.values[key];

        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        string memory lastKey = map.keys[lastIndex];

        map.indexOf[lastKey] = index;
        delete map.indexOf[key];

        map.keys[index] = lastKey;
        map.keys.pop();
    }
}