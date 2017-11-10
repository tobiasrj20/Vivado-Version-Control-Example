# Vivado-Revision-Control-Example
Repository to show an example of how to do revision control with Vivado and Xilinx SDK.

## Folder description
The Vivado folder contains the build.tcl script, which is exported from Vivado and afterwards modified to use relative paths and to create the block-design from another .tcl script.
The SDK folder contains all the .c and .h source files as well as the BSP (board-support-package) for the hardware.

## Commiting Vivado changes
Every time changes have been made to the block design a new "block-design".tcl script needs to be exported before the changes can be committed.

## Commiting Xilinx SDK changes

## Generate Vivado project from TCL script:
1. Open Vivado
2. select from menu Window->Tcl Console
3. cd "to project directory/Vivado"
4. source build.tcl
5. delete hdl-wrapper (goto sources, right-click on design_1_wrapper -> remove file from project)
6. generate new hdl-wrapper by right-clicking again an choosing Create HDL Wrapper (otherwise it does not auto-update)
7. generate bitstream

## Import project to Xilinx SDK:
1. Export vivado hardware: File->Export->Export Hardware
   Select "Include bitstream" and browse to the folder of the SDK source files
2. Launch SDK: File->Launch SDK
   Browse to the SDK source file path under both "Exported location" and "Workspace"
3. Import Application project and BSP: File->Import->General->Existing Projects into Workspace
   browse to BSP folder, repeat and do the same but select the project folder (the one with your .c and .h files)
4. Build project: Project->Build all
5. Program FPGA: Xilinx Tools->Program FPGA
6. Launch the software: Right-click on the project and select Run As->Launch on Hardware (GDB)
