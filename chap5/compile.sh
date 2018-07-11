#!/bin/bash
iverilog -o test_mips.vvp -cfile.list
vvp test_mips.vvp
