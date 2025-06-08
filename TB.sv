import transaction_pkg::*;
import shared_pkg::*;
module FIFO_TB (FIFO_if.TEST fif);

// create obj from the class to randomize it
FIFO_transaction obj_test ;       

// we choose these certain values to make the overall iteration = 10,000
localparam MIXED_TESTS = 5000;    
localparam WRITE_TESTS = 2500;      
localparam READ_TESTS  = 2500;

initial begin
	obj_test = new();

    test_finished = 0;    // Start of the test stimulus
    #0; fif.rst_n = 1; #0; 
    //-------initially reset the FIFO for 2 clk cycles--------//
    fif.rst_n = 0; 
    repeat(2) @(negedge fif.clk); 
    fif.rst_n = 1;

    //--------First loop to write only inside the FIFO--------//
    obj_test.constraint_mode(0);
    obj_test.write_only_c.constraint_mode(1);
    repeat (WRITE_TESTS) begin
        WRITE_TESTS_RAND: assert(obj_test.randomize());
        fif.rst_n = obj_test.rst_n;
        fif.rd_en = obj_test.rd_en;
        fif.wr_en = obj_test.wr_en;
        fif.data_in = obj_test.data_in;
        @(negedge fif.clk);
    end

    //---------Second loop to read only from the FIFO---------//
    obj_test.constraint_mode(0);
    obj_test.read_only_c.constraint_mode(1);
    obj_test.data_in.rand_mode(0);   // we disable the randomization for the data_in as in the read mode we don't need it
    repeat(READ_TESTS) begin
        READ_TESTS_RAND: assert(obj_test.randomize());
        fif.rst_n = obj_test.rst_n;
        fif.rd_en = obj_test.rd_en;
        fif.wr_en = obj_test.wr_en;
        fif.data_in = obj_test.data_in;
        @(negedge fif.clk);
    end

    //----------Third loop for mixed operations(read & write) inside FIFO--------//
    obj_test.constraint_mode(1);
    obj_test.data_in.rand_mode(1);   // Again , we enable the data_in for write operation
    obj_test.read_only_c.constraint_mode(0);
    obj_test.write_only_c.constraint_mode(0);
    repeat(MIXED_TESTS) begin
        MIXED_TESTS_RAND: assert(obj_test.randomize());
        fif.rst_n = obj_test.rst_n;
        fif.rd_en = obj_test.rd_en;
        fif.wr_en = obj_test.wr_en;
        fif.data_in = obj_test.data_in;
        @(negedge fif.clk);
    end

    test_finished = 1;    // End of the test stimulus

end   // End of the initial block

endmodule
