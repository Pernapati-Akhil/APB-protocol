
class apb_driver extends uvm_driver#(apb_transaction);
  `uvm_component_utils(apb_driver)
  
  virtual dut_if vif;
  
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase (uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif))
       `uvm_fatal("build_phase","virtual interface is not creatioin is faild")
  endfunction
  
     task run_phase(uvm_phase phase);
     	super.run_phase(phase);
     		this.vif.master_cb.psel<=0;
     		this.vif.master_cb.penable<=0;
     
     forever begin
       apb_transaction tr;
       @(this.vif.master_cb);
       seq_item_port.get_next_item(tr);
       @(this.vif.master_cb);
       case(tr.wr)
         apb_transaction::READ : drive_read(tr.addr,tr.data);
         apb_transaction::WRITE : drive_write(tr.addr,tr.data);
       endcase
       seq_item_port.item_done();
     end
     endtask
     
     task drive_read(input bit[31:0]addr,output logic[31:0]data);
       this.vif.master_cb.transfer <=1;
       this.vif.master_cb.wr<=0;
       @(this.vif.master_cb)
       this.vif.master_cb.paddr <= addr;
       @(this.vif.master_cb)
       data = this.vif.master_cb.prdata;
     endtask
      
     task drive_write(input bit[31:0]addr,input logic[31:0]data);
       this.vif.master_cb.wr <= 1;
       this.vif.master_cb.transfer <=1;
       @(this.vif.master_cb)
       this.vif.master_cb.paddr <= addr;
       @(this.vif.master_cb) 
       this.vif.master_cb.pwdata <= data;
     endtask
 endclass