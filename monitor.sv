import transaction_pkg::*;
import score_board::*;
import coverage_pkg::*;
import shared_pkg::*;
module FIFO_monitor(FIFO_if.MON fif);

FIFO_scoreboard obj_score = new();
FIFO_transaction obj_trans = new();
FIFO_coverage obj_cov = new();

initial begin
    forever begin
        @(negedge fif.clk);
        // sample input data
        obj_trans.data_in = fif.data_in;
        obj_trans.rst_n   = fif.rst_n;
        obj_trans.wr_en   = fif.wr_en;
        obj_trans.rd_en   = fif.rd_en;
        
        // sample output data
        obj_trans.data_out    = fif.data_out;
        obj_trans.wr_ack      = fif.wr_ack;
        obj_trans.overflow    = fif.overflow;
        obj_trans.full        = fif.full;
        obj_trans.empty       = fif.empty;
        obj_trans.almostfull  = fif.almostfull;
        obj_trans.almostempty = fif.almostempty;
        obj_trans.underflow   = fif.underflow;

        fork
            begin
                obj_cov.sample_data(obj_trans);
            end

            begin
                @(posedge fif.clk);
                obj_score.check_data(obj_trans);
            end
        join
        if (test_finished) begin
            $display("%0t: At the end of the simulation test Error Count %0d, Correct Count %0d",$time,error_count,correct_count);
            $stop;
        end
    end
end









endmodule