class fifo_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(transaction, fifo_scoreboard) item_got_export;
  `uvm_component_utils(fifo_scoreboard)
  
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit[127:0] queue[$];
  //bit[9:0] count;
  bit ful;
  bit al_ful;
  bit emp;
  bit al_emp;
  int match;
  int mismatch;
  
  function void write(input transaction item_got);
    bit [127:0] examdata;
    // for write transaction
    if(item_got.i_wren == 'b1)begin
      queue.push_back(item_got.i_wrdata);
      // to check flag condition
      //count=count+1;
      if(queue.size() ==10) begin 
        ful=1;
        al_ful=0;
        emp=0;
        al_emp=0;
      end
      else if(queue.size() >=6&&queue.size() <10) begin 
        ful=0;
        al_ful=1;
        emp=0;
        al_emp=0;
      end
       else if(queue.size()>0 && queue.size() <=2) begin 
        ful=0;
        al_ful=0;
        emp=0;
        al_emp=1;
      end
     // else if(queue.size() >2&&queue.size() <1020)
       else begin 
        ful=0;
        al_ful=0;
        emp=0;
        al_emp=0;
      end
      `uvm_info("write Data", $sformatf("wr: %0b rd: %0b data_in: %0h full: %0b alm_full: %0b empty: %0b alm_empty: %0b ",item_got.i_wren, item_got.i_rden,item_got.i_wrdata, item_got.o_full,item_got.o_alm_full,item_got.o_empty,item_got.o_alm_empty), UVM_LOW);

       `uvm_info("ref model flag write Data", $sformatf("full: %0b alm_full: %0b empty: %0b alm_empty: %0b",ful,al_ful,emp,al_emp), UVM_LOW);

      if  (ful==item_got.o_full&&al_ful==item_got.o_alm_full&&emp==item_got.o_empty&&al_emp==item_got.o_alm_empty) begin $display("---full and almost full flag pass during write---");
        match++;
        $display("match=%0d, mismatch=%0d",match,mismatch);
      end
      else begin 
        $display("---flag fail during write---");
        mismatch++;
        $display("match=%0d, mismatch=%0d",match,mismatch);
      end
    end
    
    // for read transaction
    else if (item_got.i_rden == 'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        // to check flag condition
        //count=count-1;
        if(queue.size() ==0) begin 
        ful=0;
        al_ful=0;
        emp=1;
        al_emp=0;
      end
        else if(queue.size()>0 && queue.size() <=2) begin 
        ful=0;
        al_ful=0;
        emp=0;
        al_emp=1;
      end
        else if(queue.size() >=6 && queue.size() <10) begin 
        ful=0;
        al_ful=1;
        emp=0;
        al_emp=0;
      end

      //else if(count>2&&count<1020) begin 
      else begin
        ful=0;
        al_ful=0;
        emp=0;
        al_emp=0;
      end
        `uvm_info("read Data", $sformatf("wr: %0b rd: %0b data_out: %0h full: %0b alm_full: %0b empty: %0b alm_empty: %0b ",item_got.i_wren, item_got.i_rden,item_got.o_rddata, item_got.o_full,item_got.o_alm_full,item_got.o_empty,item_got.o_alm_empty), UVM_LOW);
        `uvm_info("ref model flag read Data", $sformatf("full: %0b alm_full: %0b empty: %0b alm_empty: %0b data_out= %0h",ful,al_ful,emp,al_emp,examdata), UVM_LOW);

        
         // data check during read
         if(examdata == item_got.o_rddata) begin
           $display("-------- Data out Pass! 		--------");
           if (ful==item_got.o_full&&al_ful==item_got.o_alm_full&&emp==item_got.o_empty&&al_emp==item_got.o_alm_empty) begin 
             $display("---empty and almost empty flag pass during read---");
             match++;
             $display("match=%0d, mismatch=%0d",match,mismatch);
           end
           else begin 
             $display("---flag fail during read---");
             mismatch++;
             $display("match=%0d, mismatch=%0d",match,mismatch);
           end
        end
        else begin
          $display("--------	Data Fail!		--------");
          mismatch++;
          $display("match=%0d, mismatch=%0d",match,mismatch);
        end
      
      end
    end
    
  endfunction
endclass