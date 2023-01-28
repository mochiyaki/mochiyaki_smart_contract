// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

library Base64 {

    bytes constant private base64stdchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    bytes constant private base64urlchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=";
                                            
    function encode(string memory _str) internal pure returns (string memory) {
        uint i = 0;
        uint j = 0;

        uint padlen = bytes(_str).length;
        if (padlen%3 != 0) padlen+=(3-(padlen%3));

        bytes memory _bs = bytes(_str);
        bytes memory _ms = new bytes(padlen);
        
        for (i=0; i<_bs.length; i++) {
            _ms[i] = _bs[i];
        }
 
        uint res_length = (padlen/3) * 4;
        bytes memory res = new bytes(res_length);

        for (i=0; i < padlen; i+=3) {
            uint c0 = uint(uint8(_ms[i])) >> 2;
            uint c1 = (uint(uint8(_ms[i])) & 3) << 4 |  uint(uint8(_ms[i+1])) >> 4;
            uint c2 = (uint(uint8(_ms[i+1])) & 15) << 2 | uint(uint8(_ms[i+2])) >> 6;
            uint c3 = (uint(uint8(_ms[i+2])) & 63);

            res[j]   = base64urlchars[c0];
            res[j+1] = base64urlchars[c1];
            res[j+2] = base64urlchars[c2];
            res[j+3] = base64urlchars[c3];

            j += 4;
        }

        // Adjust trailing empty values
        if ((padlen - bytes(_str).length) >= 1) { res[j-1] = base64urlchars[64];}
        if ((padlen - bytes(_str).length) >= 2) { res[j-2] = base64urlchars[64];}
        return string(res);
    }

}
