onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib VGA_PROM_DINO_opt

do {wave.do}

view wave
view structure
view signals

do {VGA_PROM_DINO.udo}

run -all

quit -force
