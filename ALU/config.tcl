##############################################################
# OpenLane Configuration for design: alu
#
# This file controls every stage of the ASIC flow. Each setting
# acts like a small “knob” that affects how the flow behaves:
#    - Some change timing targets (e.g., clock period)
#    - Some change physical sizes and densities (e.g., DIE_AREA)
#    - Some enable or disable flow stages (RUN_*)
#    - Some control library/process choices (PDK, STD_CELL_LIBRARY)
#
# You should experiment with these parameters to observe
# how the design’s area, timing, routing quality, and DRC/LVS
# results change. This file is the main way to customize,
# constrain, and debug an ASIC in OpenLane.
##############################################################

set ::env(DESIGN_NAME) "alu"                               ;# Name of the block

if {![info exists ::env(DESIGN_DIR)]} {
    set ::env(DESIGN_DIR) [file normalize [file join [pwd] "designs" $::env(DESIGN_NAME)]]
}                                                           ;# Path to design folder

set ::env(VERILOG_FILES) [glob -nocomplain -directory $::env(DESIGN_DIR) src/*.v]
if {$::env(VERILOG_FILES) == {}} {
    set ::env(VERILOG_FILES) [glob -nocomplain $::env(DESIGN_DIR)/*.v]
}                                                           ;# RTL source files

if {![info exists ::env(PDK)]} { set ::env(PDK) "sky130A" } ;# Process technology
if {![info exists ::env(STD_CELL_LIBRARY)]} { 
    set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd" 
}                                                           ;# Standard cell library

set ::env(CLOCK_PORT)   "clk"                              ;# Clock input name
set ::env(CLOCK_PERIOD) "10.0"                             ;# Clock period in ns

set ::env(BASE_SDC_FILE) "$::env(DESIGN_DIR)/alu.sdc"      ;# Timing constraints

set ::env(DESIGN_IS_CORE) 1                                ;# 1: standalone core

if {![info exists ::env(USE_POWER_PINS)]} { 
    set ::env(USE_POWER_PINS) 0 
}                                                           ;# Include VPWR/VGND in RTL

set ::env(FP_SIZING) "absolute"                            ;# Absolute die size
set ::env(DIE_AREA) "0 0 300 300"                          ;# Chip dimensions
set ::env(FP_CORE_UTIL) 35                                 ;# Target core density
set ::env(FP_PDN_AUTO_ADJUST) 0                            ;# Fixed PDN
set ::env(FP_PDN_VPITCH) 10                                ;# Vertical PDN pitch
set ::env(FP_PDN_HPITCH) 10                                ;# Horizontal PDN pitch

set ::env(PL_MIN_UTIL) 0.15                                ;# Minimum placement density
set ::env(PL_MAX_UTIL) 0.60                                ;# Maximum placement density
set ::env(RUN_SEED)    1234                                ;# Deterministic random seed

##############################################################
# Enable all flow stages
##############################################################

set ::env(RUN_SYNTH)      1                                ;# Synthesis
set ::env(RUN_FLOORPLAN)  1                                ;# Floorplanning
set ::env(RUN_PDN)        1                                ;# Power grid
set ::env(RUN_PL)         1                                ;# Placement
set ::env(RUN_CTS)        1                                ;# Clock tree
set ::env(RUN_RESIZER)    1                                ;# Gate resizing
set ::env(RUN_RTLMP)      1                                ;# Macro placement
set ::env(RUN_ROUTING)    1                                ;# Routing
set ::env(RUN_FILL)       1                                ;# Metal fill
set ::env(RUN_DIODE_INSERTION) 1                           ;# Antenna diodes
set ::env(RUN_POST_CTS_RESIZER_TIMING) 1                   ;# Timing fix after CTS
set ::env(RUN_POST_CTS_GATE_RESIZER_TIMING) 1              ;# Additional timing fixes
set ::env(RUN_POST_PNR_TIMING) 1                           ;# Post-route timing fixes

set ::env(RUN_STA)        1                                ;# Static timing
set ::env(RUN_MAGIC)      1                                ;# Magic layout
set ::env(RUN_MAGIC_DRC)  1                                ;# DRC checks
set ::env(RUN_KLAYOUT)    1                                ;# GDS generation
set ::env(RUN_LVS)        1                                ;# Netlist-vs-layout

set ::env(RUN_SPEF_EXTRACTION) 1                           ;# Parasitic extraction
set ::env(RUN_IRDROP_REPORT)   1                           ;# IR drop analysis
set ::env(RUN_CVC)             1                           ;# Electrical checks

##############################################################
# Timing & optimization controls
##############################################################

set ::env(ENABLE_TRANSFORMATIONS) 1                        ;# Allow resizing/buffering
set ::env(PL_INSERT_BUFFERS)      1                        ;# Allow buffer insertion
set ::env(CLOCK_PORTS)            $::env(CLOCK_PORT)       ;# Clock mapping

set ::env(RUN_LOG_LEVEL) "INFO"                            ;# Log verbosity

##############################################################
# Optional tech-specific overrides
##############################################################

set tech_specific_config \
    "$::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl"

if {[file exists $tech_specific_config]} {
    source $tech_specific_config
}
