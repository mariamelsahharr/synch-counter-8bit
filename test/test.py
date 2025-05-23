# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)


    dut._log.info("Test project behavior")

    dut._log.info("loading val 20")

    dut.ui_in.value = 20
    dut.uio_in.value = 0b00000001 # uio_in[0] = LOAD_EN = 1

    await ClockCycles(dut.clk, 1)
    
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 1)
    
    dut._log.info("enable out")
    dut.uio_in.value = 0b00000010    # uio_in[1] = OUT_EN = 1
    await ClockCycles(dut.clk, 1)
    

    assert dut.uio_out.value == 21
    
    await ClockCycles(dut.clk, 1)
    assert dut.uio_out.value == 22
