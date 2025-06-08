vlib work
vlog -f fifo.list
vsim -voptargs=+acc work.top -cover
add wave /top/fif/*
coverage save top.ucdb -onexit
run -all
quit -sim
vcover report top.ucdb -details -annotate -all -output cov.txt
