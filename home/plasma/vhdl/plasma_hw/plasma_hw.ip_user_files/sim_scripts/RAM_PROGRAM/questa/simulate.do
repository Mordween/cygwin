onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib RAM_PROGRAM_opt

do {wave.do}

view wave
view structure
view signals

do {RAM_PROGRAM.udo}

run -all

quit -force
