# build_artix_7.tcl
#

set outputDir ../build
file mkdir $outputDir

read_verilog [ glob ../rtl/*.v]

read_xdc ../constraints/con.xdc

synth_design -top Top_Module -part xc7a35tcpg236-1
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt

opt_design
place_design
phys_opt_design
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt

route_design
write_checkpoint -force $outputDir/post_route
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -sort_by group -max_paths 100 -path_type summary -file $outputDir/post_route_timing.rpt
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/dds_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/dds_impl.xdc

write_bitstream -force $outputDir/dds.bit


