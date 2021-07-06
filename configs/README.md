# brqrv RISC-V eb1 core from MERL

## Configuration

### Contents
Name                    | Description
----------------------  | ------------------------------
brqrv.config            | Configuration script for brqrv-eb1  
brqrv_config_gen.py     | Python wrapper to run brqrv.config, used by brqrvolf


This script will generate a consistent set of `defines/#defines/parameters` needed for the design and testbench.  
A perl hash (*perl_configs.pl*) and a JSON format for brqrv-iss are also generated.
This set of include files :  

    ./snapshots/<target>
    ├── common_defines.vh                       # `defines for testbench
    ├── defines.h                               # #defines for C/assembly headers
    ├── eb1_param.vh                            # Actual Design parameters
    ├── eb1_pdef.vh                             # Parameter structure definition
    ├── pd_defines.vh                           # `defines for physical design
    ├── perl_configs.pl                         # Perl %configs hash for scripting
    ├── pic_map_auto.h                          # PIC memory map based on configure size
    ├── whisper.json                            # JSON file for brqrv-iss
    └── link.ld                                 # Default linker file for tests



While the defines may be modified by hand, it is recommended that this script be used to generate a consistent set.

### Targets
There are 4 predefined target configurations: `default`, `default_ahb`, `typical_pd` and `high_perf` that can be selected via the `-target=name` option to brqrv.config.

Target                  | Description
----------------------  | ------------------------------
default                 | Default configuration. AXI4 bus interface. 
default_ahb             | Default configuration, AHB-Lite bus interface
typical_pd              | No ICCM, AXI4 bus interface
high_perf               | Large BTB/BHT, AXI4 interface


`brqrv.config` may be edited to add additional target configurations, or new configurations may be created via the command line `-set` or `-unset` options.

**Run `$RV_ROOT/configs/brqrv.config -h` for options and settable parameters.**
