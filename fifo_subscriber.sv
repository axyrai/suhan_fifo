
class fifo_subscriber extends uvm_subscriber#(transaction);

  `uvm_component_utils(fifo_subscriber)

 

  uvm_analysis_imp#(transaction, fifo_subscriber) item_got_export1;

  transaction tr;


covergroup cg;

  read:coverpoint tr.i_rden;

  write:coverpoint tr.i_wren;

  data: coverpoint tr.i_wrdata;

  full: coverpoint tr.o_full;

  alm_full: coverpoint tr.o_alm_full;

  alm_empty: coverpoint tr.o_alm_empty;

  empty: coverpoint tr.o_empty;

  dataout : coverpoint tr.o_rddata;

endgroup

 

function new(string name="f_subscriber",uvm_component parent);

  super.new(name,parent);

  item_got_export1= new("item_got_export1", this);

  tr=transaction::type_id::create("tr");

  cg=new();

endfunction

 

  function void write(transaction t);

   tr=t;

   cg.sample();

   $display("coverage =%0d ",cg.get_coverage());

endfunction


 

endclass