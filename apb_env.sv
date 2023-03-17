class apb_env extends uvm_env;
  
  `uvm_component_utils(apb_env)
  
  apb_agent agt;
  apb_scoreboard scb;
  
  virtual dut_if vif;
  
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction
  
   function void build_phase (uvm_phase phase);
    super.build_phase(phase);
     agt = apb_agent :: type_id ::create("agt",this);
     scb = apb_scoreboard :: type_id ::create("scb",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    //super.connect_phase(phase)
    agt.mon.ap.connect(scb.mon_export);
    endfunction 
 endclass