#cocotb related imports
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles
import logging

T_C = 10
TPD_C = 1

#We create this TB object in every test so that all the required functions can be accessed
#from within this class. 

class TB(object):
    #The init method of this class can be used to do some setup like logging etc, start the 
    #toggling of the clock and also initialize the internal to their pre-reset vlaue.
    def __init__(self, dut):
        self.dut = dut
        self.log = logging.getLogger('cocotb_tb')
        self.log.setLevel(logging.DEBUG)
                
        #start the clock as a parallel process.
        cocotb.start_soon(Clock(dut.clk_i, T_C, units="ns").start())

        #NOTE: every supporting function you define inside the TB class should have 'self' as an input parameter, 
        #otherwise you'll get an number of parameters error.

    #Note the 'async def' keyword here. It means that this is a coroutine that needs to 
    #be awaited.
    async def cycle_reset(self):
        self.dut.rst_i.value = 0
        await ClockCycles(self.dut.clk_i, 2)
        self.dut.rst_i.value = 1               
        await ClockCycles(self.dut.clk_i, 10)
        self.dut.rst_i.value = 0
        await ClockCycles(self.dut.clk_i, 2)

    async def clock_cycles_tpd(self, num, tpd = 0):
        await ClockCycles(self.dut.clk_i, num)
        if (tpd > 0):
            await Timer(tpd,'ns')

@cocotb.test() #decorator indicates that this is a test that needs to be run by cocotb.
async def test(dut):
    
    tb = TB(dut) #creating a testbench object for this dut. __init__ function is run automatically

    await Timer(1)    #pauses current function and lets the simulator run for 1 time step.

    #init
    tb.dut.rst_i.value = 0
    tb.dut.fwOutputs_i.value = 0

    tb.dut._log.info('resetting the module') #logging helpful messages
    await tb.cycle_reset() #running the cycle_reset corouting defined above
    tb.dut._log.info('out of reset')

    tb.dut._log.info('Start testing hwOutputs_o') #logging helpful messages
    for I in range(10):
        await tb.clock_cycles_tpd(1, TPD_C)
        tb.dut.fwOutputs_i.value = I
        await tb.clock_cycles_tpd(3)
        tb.dut._log.info(f'hwOutputs_o == fwOutputs_i (I = {I})') #logging helpful messages
        assert  tb.dut.hwOutputs_o.value == tb.dut.fwOutputs_i.value, "Error"
    tb.dut._log.info('Stop testing hwOutputs_o') #logging helpful messages
    

@cocotb.test()
async def second_test(dut):
    tb = TB(dut)

    await ClockCycles(dut.clk_i, 10)
    await tb.cycle_reset()
    await ClockCycles(dut.clk_i, 10)