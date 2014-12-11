vlog -reportprogress 300 -work work controlSignalGen.v
vsim -voptargs="+acc" testControlGen
add wave -position insertpoint  \
sim:/testControlGen/switches \
sim:/testControlGen/controlSignal
run -all
wave zoom full