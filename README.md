# Vivado-Version-Control-Example
This Repository shows an example of how to do version control with Vivado and Xilinx SDK.

The Vivado folder contains the build.tcl script, which is exported from Vivado and afterwards modified to use relative paths and to create the block-design from another .tcl script.
The SDK folder contains all the .c and .h source files as well as the BSP (board-support-package) for the hardware.

## Creating TCL scripts
**Create build.tcl file**

File->Write Project Tcl

**Create design_1.tcl for creating block-design file and HDL wrapper**

Open Block Design
File -> Export -> Export Block Design

**Make the following changes to build.tcl**

Replace
```
# Set the reference directory for source file relative paths
set origin_dir "."
```
With
```
# Set the reference directory to where the script is
set origin_dir [file dirname [info script]]
```

Replace
```
# Create project
create_project myproject ./myproject
```
With
```
# Create project
create_project myproject $origin_dir/myproject
```

Replace all absolute paths with relative paths (example below)

`$origin_dir/src/hdl/test.vhd`

Remove everything regarding HDL wrapper and block design files (.bd) and insert the following instead to create from .tcl script
```
# Create block design
source $origin_dir/src/bd/design_1.tcl

# Generate the wrapper
set design_name [get_bd_designs]
make_wrapper -files [get_files $design_name.bd] -top -import
```

## Generate Vivado project from TCL script:
1. Open Vivado
2. select from menu Window->Tcl Console
3. cd "to project directory/Vivado"
4. source build.tcl
5. delete hdl-wrapper (goto sources, right-click on design_1_wrapper -> remove file from project)
6. generate new hdl-wrapper by right-clicking again an choosing Create HDL Wrapper (otherwise it does not auto-update)
7. generate bitstream

## Import version controlled project to Xilinx SDK:
1. Export vivado hardware: File->Export->Export Hardware
   Select "Include bitstream" and browse to the folder of the SDK source files
2. Launch SDK: File->Launch SDK
   Browse to the SDK source file path under both "Exported location" and "Workspace"
3. Import Application project and BSP: File->Import->General->Existing Projects into Workspace
   browse to BSP folder, repeat and do the same but select the project folder (the one with your .c and .h files)
4. Build project: Project->Build all
5. Program FPGA: Xilinx Tools->Program FPGA
6. Launch the software: Right-click on the project and select Run As->Launch on Hardware (GDB)

## Commiting Vivado changes
Every time changes have been made to the block-design a new "block-design".tcl script needs to be exported before the changes can be committed.

## Commiting Xilinx SDK changes

