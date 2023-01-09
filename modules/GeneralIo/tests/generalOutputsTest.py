#cocotb related imports
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
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
        self.dut.rst_i.setimmediatevalue(0)
        await RisingEdge(self.dut.clk_i)
        await RisingEdge(self.dut.clk_i)
        self.dut.rst_i.value = 1               

        await RisingEdge(self.dut.clk_i)
        await RisingEdge(self.dut.clk_i)
        self.dut.rst_i.value = 0
        await RisingEdge(self.dut.clk_i)
        await RisingEdge(self.dut.clk_i)

    async def wait_clk(self, num, tpd = 0):
        for I in range(num):
            await RisingEdge(self.dut.clk_i)
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

    for I in range(10):
        await tb.wait_clk(1, TPD_C)
        tb.dut.fwOutputs_i.value = I
        await tb.wait_clk(3)
        assert  tb.dut.hwOutputs_o.value == tb.dut.fwOutputs_i.value, "Error"
    
    await Timer(100 * T_C,'ns')

    #   #this assert statement checks the module's output against the golden value and 
    #   #raises a test failure exception if the don't match
#   
#       #  for i in range(100):
    #       await RisingEdge(dut.clk_i)
