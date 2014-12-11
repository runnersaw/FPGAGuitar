vlog -reportprogress 300 -work work frequencyGen.v
vsim -voptargs="+acc" testFreqGen
add wave -position insertpoint  \
sim:/testFreqGen/generator/counter \
sim:/testFreqGen/generator/clkDivider \
sim:/testFreqGen/soundWave 
run 50000000
wave zoom full