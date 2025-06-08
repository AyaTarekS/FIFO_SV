package coverage_pkg;
    import  transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn = new();
        covergroup fifo_cg ;
            write_en : coverpoint F_cvg_txn.wr_en;
            read_en : coverpoint F_cvg_txn.rd_en;
            uf: coverpoint F_cvg_txn.underflow;
            of: coverpoint F_cvg_txn.overflow;
            fifo_full: coverpoint F_cvg_txn.full;
            fifo_af: coverpoint F_cvg_txn.almostfull;
            fifo_empty: coverpoint F_cvg_txn.empty;
            fifo_ae: coverpoint F_cvg_txn.almostempty;
            ack: coverpoint F_cvg_txn.wr_ack;
            //cross combinations
            //write operations
            write_comb1: cross write_en , of{
                ignore_bins imp1 = binsof(of)intersect {1} && binsof(write_en)intersect {0};
            }
            write_comb2: cross write_en , fifo_full;
            write_comb3: cross write_en , fifo_af;
            write_comb4: cross write_en , ack{
                ignore_bins imp2 = binsof(ack)intersect {1} && binsof(write_en)intersect {0};
            }
            //Read operations
            read_comb1: cross read_en , uf{
                ignore_bins imp3 = binsof(uf)intersect {1} && binsof(read_en)intersect {0};
            }
            read_comb2: cross read_en , fifo_empty;
            read_comb3: cross read_en , fifo_ae;
        endgroup

        //constractor
        function new();
            fifo_cg = new();
        endfunction
         
         //sample function
        function void sample_data(FIFO_transaction F_Txn);
            this.F_cvg_txn = F_Txn;
            fifo_cg.sample();
        endfunction

    endclass
endpackage