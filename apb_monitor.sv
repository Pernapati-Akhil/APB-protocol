class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual dut_if vif;
  uvm_analysis_port #(apb_transaction) ap;
    
  function new(string name ,uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
  endfunction
  
   function void build_phase (uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif))
       `uvm_fatal("build_phase","virtual interface is not creatioin is faild")
  endfunction
        
	task run_phase(uvm_phase phase);
     super.run_phase(phase);
     forever begin
       apb_transaction tr;
       $display("Run phase of mon");
       tr = apb_transaction :: type_id :: create("tr",this);
       tr.addr =  this.vif.monitor_cb.paddr;       
       tr.wr = (this.vif.monitor_cb.wr) ? apb_transaction::WRITE : apb_transaction::READ;
       @(this.vif.monitor_cb)
       if(tr.wr == apb_transaction::READ)
         tr.data = this.vif.monitor_cb.prdata;
       else if(tr.wr == apb_transaction::WRITE)
         tr.data = this.vif.monitor_cb.pwdata;
       uvm_report_info("APB_MONITOr",$psprintf("GOt transaction"));
       ap.write(tr);
       $display("Run phase of mon endend");
     end
     $display("Run phase of mon ende");
       endtask
 endclass