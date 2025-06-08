parameter WIDTH = 16;
parameter DEPTH = 8;
localparam max_fifo_addr = 3;
module FIFO_SV(FIFO_if.DUT fif , 
input logic [max_fifo_addr-1:0] wr_ptr,
input logic [max_fifo_addr-1:0] rd_ptr,
input logic [max_fifo_addr:0] count
);
    property acknowledge;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.wr_en && count!= DEPTH) |=> (fif.wr_ack);
    endproperty
    property of_detection;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.wr_en && fif.full) |=> (fif.overflow);
    endproperty
    property uf_detection;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.rd_en && fif.empty) |=> (fif.underflow);
    endproperty
    property write_wraparound;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.wr_en && wr_ptr == DEPTH -1) |=> (wr_ptr == 0);
    endproperty
    property read_wraparound;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.rd_en && rd_ptr == 0) |=> (rd_ptr == (DEPTH -1));
    endproperty
    property countWrite_wraparound;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.wr_en && fif.full) |=> (count == DEPTH);
    endproperty
    property countRead_wraparound;
        @(posedge fif.clk) disable iff(!fif.rst_n) (fif.rd_en && fif.empty) |=> (count == 0);
    endproperty
    //asynchronous reset & comb logic 
    always_comb begin
        if(!fif.rst_n)begin
            assert final(wr_ptr == 0 && rd_ptr == 0 && count == 0);
        end
        if(count == 0)
            assert final(fif.empty == 1);
        if(count == DEPTH)
            assert final(fif.full == 1);
        if(count == 1)
            assert final(fif.almostempty == 1);
        if(count == (DEPTH -1))
            assert final(fif.almostfull == 1);
    end

    assert property(acknowledge);
    assert property(of_detection);
    assert property(uf_detection);
    assert property(write_wraparound);
    assert property(read_wraparound);
    assert property(countRead_wraparound);
    assert property(countWrite_wraparound);

    cover property(acknowledge);
    cover property(of_detection);
    cover property(uf_detection);
    cover property(write_wraparound);
    cover property(read_wraparound);
    cover property(countRead_wraparound);
    cover property(countWrite_wraparound);
    cover final (count == 0 && rd_ptr == 0 && wr_ptr == 0);
    cover final (fif.empty);
    cover final (fif.full);
    cover final (fif.almostempty);
    cover final (fif.almostfull);
endmodule