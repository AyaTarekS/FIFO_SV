interface FIFO_if (input logic clk);
    parameter WIDTH = 16;
    parameter DEPTH = 8;
    logic [WIDTH-1:0] data_in;
    logic rst_n , wr_en , rd_en ;
    reg underflow , overflow , wr_ack;
    logic [WIDTH-1:0] data_out;
    logic full , empty , almostfull , almostempty ;

    modport DUT (input data_in , rst_n , clk , wr_en , rd_en , output data_out , full , almostempty , almostfull , empty , overflow , underflow , wr_ack);
    modport TEST(output data_in , rst_n , wr_en ,rd_en , input clk, data_out , full , almostempty , almostfull , overflow , underflow , empty , wr_ack);
    modport MON(input data_in, rst_n , clk , wr_en , rd_en, data_out , full , almostempty , almostfull , empty , overflow , underflow ,wr_ack);
endinterface