###############################################################################
# Created by write_sdc
###############################################################################
current_design c06_core
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_propagated_clock [get_clocks {clk}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {rst_n}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[0]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[1]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[2]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[3]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[4]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[5]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[6]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {sample_in[7]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[0]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[1]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[2]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[3]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[4]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[5]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[6]}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {threshold[7]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[0]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[1]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[2]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[3]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[4]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[5]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[6]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[7]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {event_count[8]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[0]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[1]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[2]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[3]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[4]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[5]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[6]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[7]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {result_count[8]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[0]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[1]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[2]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[3]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[4]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[5]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[6]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_count[7]}]
set_output_delay 1.0000 -clock [get_clocks {clk}] -add_delay [get_ports {window_done}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
