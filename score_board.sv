
package score_board;
import shared_pkg::*;
import transaction_pkg::*;

class FIFO_scoreboard;
    // Outputs Declaration
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic full_ref, almostfull_ref, empty_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref;

    int counter;                     // declared counter to count no. of elements in the queue 
    bit [FIFO_WIDTH-1:0] queue [$];   // declared queue to check the FIFO 
    
    function void check_data(input FIFO_transaction obj);
        logic	[6:0]	flags_ref , flags_dut;
        reference_model(obj);
        flags_ref = {wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref};  // concatenated reference flags
        flags_dut = {obj.wr_ack, overflow_ref, obj.full, obj.empty, obj.almostfull, obj.almostempty, obj.underflow};  // concatenated flags from the obj.
        if( (obj.data_out !== data_out_ref) || (flags_dut !== flags_ref) && (!obj.rst_n) ) begin                                                                           
            if (obj.data_out !== data_out_ref)
                $display("At time = %0t , the output of the DUT (data_out = %0d) , doesn't Match with the Golden model output (data_out_ref = %0d)",$time,obj.data_out,data_out_ref);
            if (flags_dut !== flags_ref) begin
                $display("flags = {wr_ack, overflow, full, empty, almostfull, almostempty, underflow}");
                $display("At time = %0t , the output - Flags of the DUT (flags_dut = %0b) , doesn't Match with the Golden model output (flags_ref = %0b)",$time,flags_dut,flags_ref);
            end
            error_count++;
        end
        else begin
            correct_count++;
        end
    endfunction

    function void reference_model(input FIFO_transaction obj_gold);
        // Write Operation
        if (!obj_gold.rst_n) begin
            wr_ack_ref = 0;
            full_ref = 0;
            almostfull_ref = 0;
            overflow_ref = 0;
            queue.delete();	
        end
        else if (obj_gold.wr_en && (counter < FIFO_DEPTH)) begin  
            queue.push_back(obj_gold.data_in) ;
            wr_ack_ref = 1;
            overflow_ref = 0;
        end
        else begin 
            wr_ack_ref = 0; 
            if (full_ref && obj_gold.wr_en)
                overflow_ref = 1;
            else
                overflow_ref = 0;
        end

        // Read Operation
        if(!obj_gold.rst_n) begin
            empty_ref = 1;
            almostempty_ref = 0;
            underflow_ref = 0;
        end
        else if ( obj_gold.rd_en && counter != 0 ) begin   
            data_out_ref = queue.pop_front();
        end
        else begin
            if(empty_ref && obj_gold.rd_en)
                underflow_ref = 1 ;
            else
                underflow_ref = 0 ;
        end                

        // Counter Operation
        if(!obj_gold.rst_n) begin
            counter = 0;
        end
        else if	( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b10) && !full_ref) 
            counter = counter + 1;
        else if ( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b01) && !empty_ref)
            counter = counter - 1;
        else if ( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b11) && full_ref)
            counter = counter - 1;
        else if ( ({obj_gold.wr_en, obj_gold.rd_en} == 2'b11) && empty_ref)
            counter = counter + 1;

        // To get the updated values for the comb. flags
        full_ref = (counter == FIFO_DEPTH)? 1 : 0;     
        empty_ref = (counter == 0)? 1 : 0;
        almostfull_ref = (counter == FIFO_DEPTH-1)? 1 : 0;         
        almostempty_ref = (counter == 1)? 1 : 0;
    endfunction 
endclass
endpackage

