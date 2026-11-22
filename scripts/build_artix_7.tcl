# build_artix_7.tcl
# vivado -mode tcl -source


set here [file dirname [file normalize [info script]]]
set root [file normalize "$here/.."]


# arguements from the makefile. Basys 3 board by default
set part [expr {[llength $argv] > 0 [lindex $argv 0] : "xc7a35tcpg236-1"}] 
set topModule [expr {[llength $argv] > 0 [lindex $argv 1] : "Top_Module"}]
set outputDir [expr {[llength $argv] > 0 [lindex $argv 2] : "$root/build/artix7"}] 

set rpt $outputDir/reports
set dcp $outputDir/checkpoints
file mkdir $rpt $dcp


set_msg_config -severity {CRITICAL WARNING} -new_severity ERROR

read_verilog [ glob $root/rtl/*.v]
read_xdc $root/constraints/con.xdc

synth_design -top $topModule -part $part
write_checkpoint -force $dcp/post_synth

report_utilization -file  $rpt/post_synth_util.rpt
report_timing_summary -file $rpt/post_synth_timing_summary.rpt
report_power -file $rpt/post_synth_power.rpt


opt_design
place_design
phys_opt_design
write_checkpoint -force $dcp/post_place
report_timing_summary -file $rpt/post_place_timing_summary.rpt

route_design
write_checkpoint -force $dcp/post_route
report_timing_summary -file $rpt/post_route_timing_summary.rpt


report_timing -sort_by group -max_paths 100 -path_type summary -file $rpt/post_route_timing.rpt
report_clock_utilization -file $rpt/clock_util.rpt
report_utilization -file $rpt/post_route_util.rpt
report_power -file $rpt/post_route_power.rpt
report_drc -file $rpt/post_imp_drc.rpt
report_methodology -file $rpt/post_route_methodology.rpt

set wns [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
set whs [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -hold]]

if {$wns eq ""} {
    error "No timing paths found. Clock may be constrained. Design might have been optimized away."
}
set period [get_property PERIOD [lindex [get_clocks] 0]]
puts [format "TIMING: WNS = %.3f ns, WHS = %.3f ns, est. Fmax = %.1f MHz" $wns $whs [expr {1000.0 / $period - $wns)}]]

if {$wns < 0 || $whs < 0} {
    error "Timing not met."
}


write_verilog -force $outputDir/dds_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/dds_impl.xdc

write_bitstream -force $outputDir/dds.bit


