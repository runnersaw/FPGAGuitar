FPGAGuitar
==========

This is our implementation of an FPGA Guitar for our final project in our Computer Architecture class in Fall 2014

## Description

The logic generated with these Verilog files uses some switches as notes. One of the switches on the FPGA is the strummer. When the strummer's state toggles, the FPGA reads the note from the switches' states, and plays this note until the strummer's state toggles again.

A button on the FPGA toggles the mode between user control of notes and an auto-play mode. In the auto-play mode, the FPGA plays the main chorus from the song "Sweet Child O' Mine". 

## How to Use

We used Xilinx to compile the code and upload the code to an FPGA. 
