##############################################################
# OpenLane Configuration for design: alu 
#
# INSTRUCTIONS:
#   - ONLY edit the variables in the USER-SET PARAMETERS section.
#   - Every parameter is a physical-design “knob” that affects
#       • timing     • area     • routing congestion
#       • power grid strength   • signoff results
#
#   By changing these variables, you directly control how the
#   backend flow behaves. The rest of the file consumes your
#   settings automatically and should NOT be edited.
##############################################################


#################################################################
###############         USER-SET PARAMETERS         #############
#################################################################

# --- Basic design identity ---
set USER_DESIGN_NAME           "alu"        
# Changing this lets you reuse the same config for other designs.


# --- Clock specification (timing target) ---
set USER_CLOCK_PORT            "clk"        ;# name of the clock pin
set USER_CLOCK_PERIOD_NS       10.0         ;# 10 ns = 100 MHz
# Smaller number → faster clock → harder timing → more buffering/up-sizing.

# --- Floorplanning parameters (area + density controls) ---
set USER_DIE_X1                0
set USER_DIE_Y1                0
set USER_DIE_X2                300
set USER_DIE_Y2                300
# These four numbers define the physical silicon rectangle (microns).
# Larger die → more routing space but higher area cost.

set USER_CORE_UTIL_PERCENT     35
# % of core area that standard cells may occupy.
# Low util → easy routing; high util → congestion/timing challenges.

# --- Power Delivery Network (PDN) parameters ---
set USER_PDN_AUTO_ADJUST       0     
# If set to 1, OpenLane strengthens the PDN automatically based on load.

set USER_PDN_VPITCH            10
set USER_PDN_HPITCH            10
# Pitch controls spacing between power stripes.
# Smaller pitch = stronger PDN (more metal). Larger pitch = weaker PDN.

# --- Placement density constraints ---
set USER_PL_MIN_UTIL           0.15 
set USER_PL_MAX_UTIL           0.60
# Guides the placer to keep density within a sane window.

# --- Random seed for deterministic runs (debug repeatability) ---
set USER_RUN_SEED              1234

# --- Flow stage controls (enable/disable full backend stages) ---
set USER_RUN_SYNTH             1   ;# RTL → gate-level netlist
set USER_RUN_PNR               1   ;# Full place + route
set USER_RUN_CTS               1   ;# Clock tree synthesis
set USER_RUN_STA               1   ;# Static timing analysis

# --- Signoff controls (enable for final tapeout-style checks) ---
set USER_RUN_MAGIC             1   ;# DRC / layout inspection
set USER_RUN_MAGIC_DRC         1
set USER_RUN_KLAYOUT           1   ;# Write GDS
set USER_RUN_LVS               1   ;# Layout vs schematic check

# --- Optional expensive analyses (enable only if needed) ---
set USER_RUN_SPEF_EXTRACTION   0   ;# Parasitics (wire RC) extraction
set USER_RUN_IRDROP_REPORT     0   ;# Power grid IR-drop analysis
set USER_RUN_CVC               0   ;# Electrical rule checks
# Turning these ON increases runtime significantly.

# --- Optimization behavior controls ---
set USER_ENABLE_TRANSFORMATIONS 1
# Allows synthesis/PnR to resize cells, insert buffers, restructure logic.

set USER_PL_INSERT_BUFFERS      1
# Enables buffer insertion during placement to help long wires.

# --- Power pin handling ---
set USER_USE_POWER_PINS        0
# If the library requires explicit VPWR/VGND pins, set this to 1.

# --- Logging verbosity ---
set USER_RUN_LOG_LEVEL         "INFO"
#################################################################
###############     END USER-SET PARAMETERS       ###############
#################################################################



#################################################################
########            DO NOT EDIT BELOW THIS LINE           #######
#################################################################

# --- Design name ---
set ::env(DESIGN_NAME) $USER_DESIGN_NAME

# Auto-resolve design directory
if {![info exists ::env(DESIGN_DIR)]} {
    set ::env(DESIGN_DIR) \
        [file normalize [file join [pwd] "designs" $::env(DESIGN_NAME)]]
}

# --- RTL files ---
set ::env(VERILOG_FILES) \
    [glob -nocomplain -directory $::env(DESIGN_DIR) src/*.v]
if {$::env(VERILOG_FILES) == {}} {
    set ::env(VERILOG_FILES) \
        [glob -nocomplain $::env(DESIGN_DIR)/*.v]
}

# --- PDK and standard-cell library selection ---
set USER_PDK                   "sky130A"          
set USER_STD_CELL_LIBRARY      "sky130_fd_sc_hd"  


# --- Clock / SDC ---
set ::env(CLOCK_PORT)       $USER_CLOCK_PORT
set ::env(CLOCK_PERIOD)     $USER_CLOCK_PERIOD_NS
set ::env(BASE_SDC_FILE)    "$::env(DESIGN_DIR)/alu.sdc"

# --- Core / IO ---
set ::env(DESIGN_IS_CORE)   1
set ::env(USE_POWER_PINS)   $USER_USE_POWER_PINS

# --- Floorplan ---
set ::env(FP_SIZING)        "absolute"
set ::env(DIE_AREA)         "$USER_DIE_X1 $USER_DIE_Y1 $USER_DIE_X2 $USER_DIE_Y2"
set ::env(FP_CORE_UTIL)     $USER_CORE_UTIL_PERCENT

# --- PDN configuration ---
set ::env(FP_PDN_AUTO_ADJUST) $USER_PDN_AUTO_ADJUST
set ::env(FP_PDN_VPITCH)      $USER_PDN_VPITCH
set ::env(FP_PDN_HPITCH)      $USER_PDN_HPITCH

# --- Placement / routing ---
set ::env(PL_MIN_UTIL)      $USER_PL_MIN_UTIL
set ::env(PL_MAX_UTIL)      $USER_PL_MAX_UTIL
set ::env(RUN_SEED)         $USER_RUN_SEED

# --- Flow stages ---
set ::env(RUN_SYNTH)        $USER_RUN_SYNTH
set ::env(RUN_PNR)          $USER_RUN_PNR
set ::env(RUN_CTS)          $USER_RUN_CTS
set ::env(RUN_STA)          $USER_RUN_STA

# --- Signoff ---
set ::env(RUN_MAGIC)        $USER_RUN_MAGIC
set ::env(RUN_MAGIC_DRC)    $USER_RUN_MAGIC_DRC
set ::env(RUN_KLAYOUT)      $USER_RUN_KLAYOUT
set ::env(RUN_LVS)          $USER_RUN_LVS

# --- Additional analysis ---
set ::env(RUN_SPEF_EXTRACTION) $USER_RUN_SPEF_EXTRACTION
set ::env(RUN_IRDROP_REPORT)   $USER_RUN_IRDROP_REPORT
set ::env(RUN_CVC)             $USER_RUN_CVC

# --- Optimization ---
set ::env(ENABLE_TRANSFORMATIONS) $USER_ENABLE_TRANSFORMATIONS
set ::env(PL_INSERT_BUFFERS)      $USER_PL_INSERT_BUFFERS
set ::env(CLOCK_PORTS)            $::env(CLOCK_PORT)

# --- Logging ---
set ::env(RUN_LOG_LEVEL) $USER_RUN_LOG_LEVEL

# --- Optional tech-specific overrides ---
set tech_specific_config \
    "$::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl"
if {[file exists $tech_specific_config]} {
    source $tech_specific_config
}

##############################################################
# Final Notes:
#
# • Increasing DIE_AREA solves congestion but costs area.
# • Increasing CORE_UTIL makes placement tighter and exposes timing issues.
# • Increasing PDN pitch weakens the power grid → possible IR-drop failures.
# • Changing CLOCK_PERIOD affects how aggressively timing is optimized.
# • Enabling SPEF/IRDROP reveals more realistic signoff failures.
#
# The best way to learn physical design is to tune one knob at a time
# and inspect the logs under:
#     designs/alu/runs/<run_id>/logs/
##############################################################
