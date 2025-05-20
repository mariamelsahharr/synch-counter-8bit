/*
 * Copyright (c) 2025 Mariam
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_8bit_prog_counter (
    input  logic [7:0] ui_in,    // 8 bit load val
    output logic [7:0] uo_out,   // Dedicated outputs- not used rn
    input  logic [7:0] uio_in,   // have uio_in[0] = load_e, uio_in[1] = tristate_out_enable. 2:7 unused
    output logic [7:0] uio_out,  // tristate cnter output
    output logic [7:0] uio_oe,   // tristate cnter output enable
    input  logic       ena,      // always 1 when the design is powered, so you can ignore it
    input  logic       clk,      // clock
    input  logic       rst_n     // active low
);

  wire [7:0] counter_data;

  // Instantiate counter module
  prog_counter counter_inst (
      .clk(clk),
      .reset(~rst_n),
      .load_e(uio_in[1]),
      .out_e(uio_in[2]),
      .load_val(ui_in),
      .out_data(counter_data)
  );

  // All output pins must be assigned. If not used, assign to 0.
  //since this is an asic, we cant like assign high z if high z enable is not set
  // so i used the like in outs to assign high z,, not sure if that was the intended functionality but like it wont work otherwise u cant just drive high z lol
  assign uio_oe  = {8{uio_in[2]}};
  assign uio_out = counter_data;
  

  assign uo_out  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:2]};
endmodule
