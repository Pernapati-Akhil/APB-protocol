class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  
  apb_env env;
  virtual dut_if vif;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase (uvm_phase phase);
    super.build_phase(phase);
     env = apb_env :: type_id :: create("env",this);
     uvm_config_db#(virtual dut_if) :: set(this,"","vif",vif);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_sequence apb_seq;
    apb_seq = apb_sequence ::type_id:: create("apb_seq",this);
    phase.raise_objection(this,"starting the apb_base_seq in main phase");
    apb_seq.start(env.agt.seqr);
    phase.drop_objection(this,"finishing the apb_seq");
  endtask
  
 endclass