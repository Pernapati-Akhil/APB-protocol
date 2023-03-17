class apb_sequence extends uvm_sequence;
  `uvm_object_utils(apb_sequence)
  
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction
  
  task body();
    apb_transaction rw_trans;
    repeat (10)begin 
      rw_trans = new();
      //rw_trans.wr= 1;
      start_item(rw_trans);
      assert(rw_trans.randomize());
      finish_item(rw_trans);
    end
  endtask
  
 endclass