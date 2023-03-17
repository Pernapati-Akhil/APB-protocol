class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  virtual dut_if vif;
  
  apb_driver drv;
  apb_monitor mon;
  apb_sequencer seqr;
  
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase (uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif))
       `uvm_fatal("build_phase","virtual interface is not creatioin is faild");
       	drv = apb_driver :: type_id ::create("drv",this);
     	seqr = apb_sequencer :: type_id ::create("seqr",this);
        mon = apb_monitor :: type_id ::create("mon",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    uvm_report_info("APB_DRIVER","connect_phase, connected to sequencer");
  endfunction 
  
 endclass