# Copyright (c) 2024 texer.ai, Maveric @ NU.
# All rights reserved.

import argparse
import os

# Constant messages.
HELP_MSG_SCRIPT_DESCRIPTION = "This is a utility script that compiles design with Verilator simulator."
HELP_MSG_COMPILE_ALL = "Compile all modules in the design."
HELP_MSG_LIST_MODULES = "List all modules present in the design."
HELP_MSG_COMPILE_SINGLE = "Compile single module."
HELP_MSG_PRINT_HELP = "Print this message."
HELP_MSG_GENERATE_WAVEFORM = "Generate .vcd waveform."
HELP_MSG_CLEAN_SIMULATION = "Clean simulation. Remove all Verilator generated files."

# List of all hardware modules you have.
MODULES = ["top", "Control_Unit", "ARITHM", "Reg_0", "mux", "top_tb"]

# Linux commands invoked within this script.
# Verilator command to generate C++ and Makefiles.
VERILATE_COMMAND = "verilator --assert -I./rtl --Wall {0} --trace --cc ./rtl/{1}.v ./rtl/ARITHM.v ./rtl/Reg_0.v ./rtl/mux.v --exe ./rtl/top_tb.cpp"
MAKE_COMMAND = "make -C obj_dir/ -f V{0}.mk V{0}"
CLEAN_COMMAND = "rm -rf ./obj_dir"

def print_all_modules():
    print("The design has the following modules:")
    for module in MODULES:
        print(" * {}".format(module))
    print("To compile any of these modules, pick the module and run the script with the -s flag.")
    print("For example:")
    print("   python3 bitty_run.py -s top")

def compile_all(should_gen_wave):
    trace = ""
    if should_gen_wave:
        trace = "--trace"
    os.system(VERILATE_COMMAND.format(trace, "top"))
    os.system(MAKE_COMMAND.format("top"))
    os.system("./obj_dir/Vtop")

def compile_single(module, should_gen_wave):
    trace = ""
    if should_gen_wave:
        trace = "--trace"
    if module in MODULES:
        os.system(VERILATE_COMMAND.format(trace, module))
        os.system(MAKE_COMMAND.format(module))
        os.system(f"./obj_dir/V{module}")
    else:
        print(f"Module {module} not found in the design.")

def clean_simulation():
    print("Cleaning...")
    os.system(CLEAN_COMMAND)

def parse_arguments():
    parser = argparse.ArgumentParser(description=HELP_MSG_SCRIPT_DESCRIPTION)
    parser.add_argument('-a', '--compile-all', action='store_true', default=False, help=HELP_MSG_COMPILE_ALL)
    parser.add_argument('-l', '--list-modules', action='store_true', default=False, help=HELP_MSG_LIST_MODULES)
    parser.add_argument('-s', '--compile-single', type=str, help=HELP_MSG_COMPILE_SINGLE)
    parser.add_argument('-w', '--gen-waveform', action='store_true', default=False, help=HELP_MSG_GENERATE_WAVEFORM)
    parser.add_argument('-c', '--clean', action='store_true', default=False, help=HELP_MSG_CLEAN_SIMULATION)

    return parser.parse_args(), parser.format_help()

def main():
    args, help_msg = parse_arguments()

    if hasattr(args, 'help') and args.help:
        print(help_msg)
    elif args.clean:
        clean_simulation()
    elif args.list_modules:
        print_all_modules()
    elif args.compile_all:
        compile_all(should_gen_wave=args.gen_waveform)
    elif args.compile_single:
        compile_single(args.compile_single, should_gen_wave=args.gen_waveform)
    else:
        print(help_msg)

main()

