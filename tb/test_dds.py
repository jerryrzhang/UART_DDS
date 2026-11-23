import os
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge
from cocotb_tools.runner import get_runner

ROOT = Path(__file__).resolve().parent.parent
CLK_PERIOD_NS = 10


async def reset(dut, ftw):
    Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start()
    dut.FTW.value = ftw
    dut.rst.value = 1
    await ClockCycles(dut.clk, 2)
    dut.rst.value = 0


async def collect(dut, n):
    # Sample n clock cycles on the falling edge so registers have settled after the rising edge.
    samples = []
    for _ in range(n):
        await FallingEdge(dut.clk)
        samples.append(dut.sin.value.to_signed())
    return samples


@cocotb.test()
async def smoke(dut):
    samples_per_period = 64
    periods = 4
    await reset(dut, 2**32 // samples_per_period)
    samples = await collect(dut, samples_per_period * periods)

    assert max(samples) > 30000 and min(samples) < -30000 #check to see if it hits both peaks (it should)
    rising_zero_crossings = sum(a < 0 <= b for a, b in zip(samples, samples[1:])) # counts rising zero crossings to make sure freq is tied loosely to FTW
    assert abs(rising_zero_crossings - periods) <= 1


# pytest entry point: builds DDS.v with Verilator, then runs the cocotb tests above.
def test_dds_runner():
    waves = os.getenv("WAVES") == "1"
    runner = get_runner("verilator")
    runner.build(
        sources=[ROOT / "rtl" / "DDS.v"],
        hdl_toplevel="DDS",
        build_dir=ROOT / "build" / "sim" / "dds",
        waves=waves,
        always=True,
    )
    runner.test(hdl_toplevel="DDS", test_module=Path(__file__).stem, waves=waves)
