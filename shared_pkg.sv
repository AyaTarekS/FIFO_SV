package shared_pkg;
    bit test_finished;
    int correct_count = 0 , error_count = 0;
    event sampletrigger;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
endpackage