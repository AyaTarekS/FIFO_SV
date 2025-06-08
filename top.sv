module top();

//clock generation 
    bit clk = 0;
    initial begin
        clk = 0;
        forever #5 clk = ~ clk;
    end

//instance of the modules
FIFO_if #(.WIDTH(16), .DEPTH(8)) fif(.clk(clk));
FIFO #(.FIFO_WIDTH(16), .FIFO_DEPTH(8)) DUT(fif);
FIFO_monitor mon(fif);
FIFO_TB tb(fif);

endmodule