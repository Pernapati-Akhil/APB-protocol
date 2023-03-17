class apb_transaction extends uvm_sequence_item;
  `uvm_object_utils(apb_transaction)
  
  rand bit [31:0]addr;
  rand bit [31:0]data;
  typedef enum {READ,WRITE}kind_e;
  rand kind_e wr; 
  rand bit pready;
  rand bit transfer;
  
  constraint addr_1{addr>0 && addr<256;}
  constraint data_1{data>0 && data<256;}
  
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  endclass