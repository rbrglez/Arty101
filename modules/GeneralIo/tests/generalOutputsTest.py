import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
#   async def my_first_test(dut):
#       """Try accessing the design."""
#   
#       dut.rst_i.value = 1
#   
#       for cycle in range(1000):
#           dut.clk_i.value = 0
#           await Timer(1, units="ns")
#           dut.clk_i.value = 1
#           await Timer(1, units="ns")
#   
#   
#       await Timer(100, units="ns")

async def test(dut):
    """ Test that d propagates to q """

    clock = Clock(dut.clk_i, 10, units="ns")  # Create a 10ns period clock on port clk
    cocotb.start_soon(clock.start())  # Start the clock

    # Init
    dut.rst_i.value = 0
    dut.fwOutputs_i.value = 0

    for i in range(10):
        await RisingEdge(dut.clk_i)

    dut.rst_i.value = 1


    for i in range(10):
        await RisingEdge(dut.clk_i)

    dut.rst_i.value = 0

    for i in range(100):
        await RisingEdge(dut.clk_i)

    dut.fwOutputs_i.value = 10

    for i in range(100):
        await RisingEdge(dut.clk_i)
