// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon May 15 17:37:36 2023
// Host        : CAO2-28 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/cygwin/home/alexandre/plasma/vhdl/plasma_hw/plasma_hw.gen/sources_1/ip/VGA_PROM_DINO/VGA_PROM_DINO_stub.v
// Design      : VGA_PROM_DINO
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module VGA_PROM_DINO(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[15:0],douta[11:0]" */;
  input clka;
  input [15:0]addra;
  output [11:0]douta;
endmodule
