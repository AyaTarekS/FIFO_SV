package transaction_pkg;
    class FIFO_transaction;
    parameter WIDTH = 16;
    parameter DEPTH = 8;
    parameter max_fifo_addr = $clog2(DEPTH);
    rand logic [WIDTH-1:0] data_in;
    rand logic rst_n , wr_en , rd_en;
    logic clk;
    //output
    logic [WIDTH-1:0] data_out;
    logic  underflow , overflow;
    logic full , empty , almostfull , almostempty , wr_ack;
    //variables for distribution
    int RD_EN_ON_DIST , WR_EN_ON_DIST ;
    //constractor
    function new(int write_en_dis = 70 , int read_en_dis = 30);
        this.WR_EN_ON_DIST = write_en_dis;
        this.RD_EN_ON_DIST = read_en_dis;
    endfunction
    //constraints
    constraint reset_c{
        rst_n dist{0:/2 , 1:/98};
    }
    constraint write_en_c{
        wr_en dist{1:= WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST};
    }
    constraint read_en_c{
        rd_en dist{1:= RD_EN_ON_DIST , 0:=100-RD_EN_ON_DIST};
    }

    constraint read_only_c{
        rd_en == 1;
        wr_en == 0; rst_n == 1;
    }
    constraint write_only_c{
        rd_en == 0;
        wr_en == 1; rst_n == 1;
    }


    endclass
endpackage