`ifndef __GUARD_PACKAGE_AXI4L_PKG_SV__
`define __GUARD_PACKAGE_AXI4L_PKG_SV__

`include "axi/typedef.svh"

package axi4l_pkg;
    `AXI_LITE_TYPEDEF_ALL(axi4l, logic[31:0], logic[63:0], logic[7:0])
endpackage

`endif