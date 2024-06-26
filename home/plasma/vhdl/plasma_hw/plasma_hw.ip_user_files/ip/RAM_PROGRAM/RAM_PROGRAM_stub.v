// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Tue Apr 18 09:56:01 2023
// Host        : CAO2-28 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/cygwin/home/alexandre/plasma/vhdl/plasma_hw/plasma_hw.gen/sources_1/ip/RAM_PROGRAM/RAM_PROGRAM_stub.v
// Design      : RAM_PROGRAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module RAM_PROGRAM(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[3:0],addra[11:0],dina[31:0],clkb,addrb[11:0],doutb[31:0]" */;
  input clka;
  input [3:0]wea;
  input [11:0]addra;
  input [31:0]dina;
  input clkb;
  input [11:0]addrb;
  output [31:0]doutb;
endmodule
