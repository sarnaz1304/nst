// SPDX-FileCopyrightText: © 2023 Dai Foundation <www.daifoundation.org>
// SPDX-License-Identifier: AGPL-3.0-or-later
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

pragma solidity ^0.8.16;

import { ScriptTools } from "dss-test/ScriptTools.sol";

import { Nst } from "src/Nst.sol";
import { NstJoin } from "src/NstJoin.sol";
import { DaiNst } from "src/DaiNst.sol";

import { NstInstance } from "./NstInstance.sol";

interface DaiJoinLike {
    function vat() external view returns (address);
}

library NstDeploy {
    function deploy(
        address deployer,
        address owner,
        address daiJoin
    ) internal returns (NstInstance memory instance) {
        address _nst = address(new Nst());
        ScriptTools.switchOwner(_nst, deployer, owner);

        address _nstJoin = address(new NstJoin(DaiJoinLike(daiJoin).vat(), _nst));
        address _daiNst = address(new DaiNst(daiJoin, _nstJoin));

        instance.nst     = _nst;
        instance.nstJoin = _nstJoin;
        instance.daiNst  = _daiNst;
        instance.owner   = owner;
    }
}