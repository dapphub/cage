/// cage.sol -- global settlement engine

// Copyright (C) 2018 Rain <rainbreak@riseup.net>
// Copyright (C) 2018 Lev Livnev <lev@liv.nev.org.uk>
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
// 
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma sol ^0.4.24;

contract VatLike {
    function dai(address lad) public;
    function flux(bytes32 ilk, bytes32 src, bytes32 dst, int256 rad) public;
    function tune(bytes32 i, bytes32 u, bytes32 v, bytes32 w, int256 dink, int256 dart) public;
    function grab(bytes32 i, bytes32 u, bytes32 v, bytes32 w, int256 dink, int256 dart) public;
}
contract PitLike {
    function cage() public;
}
contract CatLike {
    function cage() public;
}
contract VowLike {
    function cage(uint256 dump) public;
}
contract DripLike {
    function cage() public;
}

contract End {
    // --- Auth ---
    mapping (address => uint) public wards;
    function rely(address guy) public note auth { wards[guy] = 1; }
    function deny(address guy) public note auth { wards[guy] = 0; }
    modifier auth { require(wards[msg.sender] == 1); _; }

    // --- Data ---
    VatLike  public vat;
    PitLike  public pit;
    CatLike  public cat;
    VowLike  public vow;
    DripLike public drip;
    uint256  public live;
    
    mapping (address => uint256)                      public dai;
    mapping (bytes32 => uint256)                      public tags;
    mapping (bytes32 => uint256)                      public fixs;
    mapping (bytes32 => mapping (bytes32 => uint256)) public bags;

    // --- Init ---
    constructor() public {
        wards[msg.sender] = 1;
        live = 1;
    }

    // --- Math ---
    function add(uint x, uint y) internal pure returns (uint z) {
        z = x + y;
        require(z >= x);
    }
    
    uint constant ONE = 10 ** 27;
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = x * y;
        require(y == 0 || z / y == x);
        z = z / ONE;
    }

    // --- Administration ---
    function file(bytes32 what, address data) public auth {
        if (what == "pit")  pit  = PitLike(data);
        if (what == "cat")  cat  = CatLike(data);
        if (what == "vow")  vow  = VowLike(data);
        if (what == "drip") drip = DripLike(data);
    }

    function cage(uint256 dump) public auth {
        // require(live == 1); ???
        pit.cage();
        cat.cage();
        vow.cage(dump);
        drip.cage();
        live = 0;
    }

    function cage(bytes32 ilk, uint256 tag, uint256 fix) public auth {
        require(live == 0);
        tags[ilk] = tag;
        fixs[ilk] = fix;
    }

    function skim(bytes32 ilk, bytes32 urn) public {
        require(tags[ilk] != 0);
    
        (uint take, uint rate, uint Ink, uint Art) = vat.ilks(ilk); Art; Ink; take;
        (uint ink, uint art) = vat.urns(ilk, urn);
    
        // assumes take is ONE
        uint war = min(ink, rmul(rmul(art, rate), tags[ilk]));
    
        vat.grab(ilk, urn, bytes32(address(this)), bytes32(address(this)), -int(war), -int(art));
    }

    function shut(bytes32 ilk) public {
        (uint ink, uint art) = vat.urns(ilk, bytes32(msg.sender));
        require(art == 0);
        vat.tune(ilk, bytes32(msg.sender), -int(ink), 0);
    }

    function shop() public {
        uint rad = vat.dai(msg.sender);
        vat.heal(this, msg.sender, rad);
        dai[msg.sender] = add(dai[msg.sender], rad);
    }

    function pack(bytes32 ilk) public {
        require(bags[ilk][msg.sender] == 0);
        bags[ilk][msg.sender] = add(bags[ilk][msg.sender], dai[msg.sender]);
    }

    function cash(bytes32 ilk) public {
        vat.flux(ilk, this, msg.sender, rmul(bags[ilk][msg.sender], fixs[ilk]));
        bags[ilk][msg.sender]  = 0;
        dai[msg.sender]        = 0;
    }
}
