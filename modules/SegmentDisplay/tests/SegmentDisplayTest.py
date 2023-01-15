# cocotb related imports
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles
from cocotb.binary import BinaryValue
import logging

T_C = 10
TPD_C = 1

# We create this TB object in every test so that all the required functions can be accessed
# from within this class.

segment_a  = 0;
segment_b  = 1;
segment_c  = 2;
segment_d  = 3;
segment_e  = 4;
segment_f  = 5;
segment_g  = 6;
segment_dp = 7;

#segment_zero = (1 << segment_a) | (1 << segment_b) | (1 << segment_c) | (1 << segment_d) | (1 << segment_e) | (1 << segment_f) 

segment_num = [
BinaryValue(value = 0x3F, n_bits = 8, bigEndian = False),
BinaryValue(value = 0x06, n_bits = 8, bigEndian = False),
BinaryValue(value = 0x5B, n_bits = 8, bigEndian = False),
BinaryValue(value = 0x4F, n_bits = 8, bigEndian = False),
BinaryValue(value = 0x66, n_bits = 8, bigEndian = False), 
BinaryValue(value = 0x6D, n_bits = 8, bigEndian = False),  
BinaryValue(value = 0x7D, n_bits = 8, bigEndian = False),  
BinaryValue(value = 0x07, n_bits = 8, bigEndian = False),
BinaryValue(value = 0x7F, n_bits = 8, bigEndian = False),
BinaryValue(value = 0x6F, n_bits = 8, bigEndian = False),
] 

segment_dp =    BinaryValue(value = 0x80, n_bits = 8, bigEndian = False)

class TB(object):
    # The init method of this class can be used to do some setup like logging etc, start the
    # toggling of the clock and also initialize the internal to their pre-reset value.
    def __init__(self, dut):
        self.dut = dut
        self.log = logging.getLogger('cocotb_tb')
        self.log.setLevel(logging.DEBUG)

        # start the clock as a parallel process.
        cocotb.start_soon(Clock(dut.clk_i, T_C, units="ns").start())

        # NOTE: every supporting function you define inside the TB class should have 'self' as an input parameter,
        # otherwise you'll get an number of parameters error.

    # Note the 'async def' keyword here. It means that this is a coroutine that needs to
    # be awaited.
    async def cycle_reset(self):
        self.dut.rst_i.value = 0
        await ClockCycles(self.dut.clk_i, 2)
        self.dut.rst_i.value = 1
        await ClockCycles(self.dut.clk_i, 10)
        self.dut.rst_i.value = 0
        await ClockCycles(self.dut.clk_i, 2)

    async def clock_cycles_tpd(self, num, tpd=0):
        await ClockCycles(self.dut.clk_i, num)
        if (tpd > 0):
            await Timer(tpd, 'ns')

# decorator indicates that this is a test that needs to be run by cocotb.
@cocotb.test()
async def test(dut):

    # creating a testbench object for this dut. __init__ function is run automatically
    tb = TB(dut)

    # init
    tb.dut.rst_i.value = 0
    tb.dut.en_i.value = 0
    tb.dut.data_i.value = 0

    tb.dut._log.info('resetting the module')  # logging helpful messages
    await tb.cycle_reset()  # running the cycle_reset corouting defined above
    tb.dut._log.info('out of reset')
    await tb.clock_cycles_tpd(10, TPD_C)

    tb.dut._log.info(f'########################################')
    tb.dut._log.info(f'## DISABLE PORT en_i')
    tb.dut._log.info(f'########################################')
    tb.dut.en_i.value = 0
    await tb.clock_cycles_tpd(10, TPD_C)

    tb.dut._log.info(f'########################################')
    tb.dut._log.info(f'## TEST data_i 0 - 16')
    tb.dut._log.info(f'## DISABLED en_i')
    tb.dut._log.info(f'########################################')
    for I in range(16):
        tb.dut.data_i.value = I
        await tb.clock_cycles_tpd(2)
        tb.dut._log.info(f'data_i     = {tb.dut.data_i.value}')
        tb.dut._log.info(f'segments_o = {tb.dut.segments_o.value}')
        tb.dut._log.info(f' ')
        assert tb.dut.segments_o.value == BinaryValue(0,8), "Error"
    tb.dut._log.info(f'########################################')

    tb.dut._log.info(f'########################################')
    tb.dut._log.info(f'## ENABLE PORT en_i')
    tb.dut._log.info(f'########################################')
    tb.dut.en_i.value = 1
    await tb.clock_cycles_tpd(10, TPD_C)

    tb.dut._log.info(f'########################################')
    tb.dut._log.info(f'## TEST data_i 0 - 9')
    tb.dut._log.info(f'########################################')
    for I,segment in enumerate(segment_num):
        tb.dut.data_i.value = I
        await tb.clock_cycles_tpd(2)
        tb.dut._log.info(f'data_i     = {tb.dut.data_i.value}')
        tb.dut._log.info(f'segments_o = {tb.dut.segments_o.value}')
        tb.dut._log.info(f' ')
        assert tb.dut.segments_o.value == segment_num[I], "Error"
    tb.dut._log.info(f'########################################')

    tb.dut._log.info(f'########################################')
    tb.dut._log.info(f'## TEST data_i 10 - 15')
    tb.dut._log.info(f'########################################')
    for I in range(10, 16):
        tb.dut.data_i.value = I
        await tb.clock_cycles_tpd(2)
        tb.dut._log.info(f'data_i     = {tb.dut.data_i.value}')
        tb.dut._log.info(f'segments_o = {tb.dut.segments_o.value}')
        tb.dut._log.info(f' ')
        assert tb.dut.segments_o.value == segment_dp, "Error"
    tb.dut._log.info(f'########################################')



# decorator indicates that this is a test that needs to be run by cocotb.
@cocotb.test()
async def second_test(dut):
    cocotb.start_soon(Clock(dut.clk_i, T_C, units='ns').start())
    await Timer(100, 'ns')
