// Code your design here
interface dut_if;

  logic pclk;
  logic rst_n;
  logic [31:0] paddr;
  logic psel;
  logic penable;
  logic wr;
  logic [31:0] pwdata;
  logic pready;
  logic [31:0] prdata;
  logic transfer;
  //Master Clocking block - used for Drivers
  clocking master_cb @(posedge pclk);
    output paddr, psel, penable, wr, pwdata,transfer;
    input  prdata,pready;
  endclocking: master_cb

  //Slave Clocking Block - used for any Slave BFMs
  clocking slave_cb @(posedge pclk);
     input  paddr, psel, penable, wr, pwdata,pready;
     output prdata;
  endclocking: slave_cb

  //Monitor Clocking block - For sampling by monitor components
  clocking monitor_cb @(posedge pclk);
     input paddr, psel, penable, wr, prdata, pwdata,pready;
  endclocking: monitor_cb

  modport master(clocking master_cb);
  modport slave(clocking slave_cb);
  modport passive(clocking monitor_cb);

endinterface

module apb_slave(dut_if dif);

  logic [31:0] mem [0:256];
  logic [1:0] apb_st;
  const logic [1:0] IDLE=0;
  const logic [1:0] SETUP=1;
  const logic [1:0] ACCESS=2;
  
  always @(posedge dif.pclk or negedge dif.rst_n) begin
    if (dif.rst_n==0) begin
      apb_st <=0;
      dif.prdata <=0;
      dif.pready <=0;
      dif.psel<=0;
      dif.penable<=0;
      dif.transfer<=0;
      for(int i=0;i<256;i++) mem[i]=i;
    end
    else begin
      case (apb_st)
        IDLE: begin
          dif.psel <= 0;
          dif.penable<=0;
          if (dif.transfer) begin
             apb_st <= SETUP;
            end
            else begin
              apb_st <= IDLE;
            end
        end
        SETUP: begin
          dif.psel <=1;
          dif.penable <= 0;
          if (dif.transfer) begin
             apb_st <= ACCESS;
            end
          end
        ACCESS: begin
          dif.psel <=1;
          dif.penable <= 1;
          if (dif.pready) begin
            if(dif.transfer)
             apb_st <= SETUP;
            else
              apb_st <= IDLE;
            end
            else begin
              apb_st <= ACCESS;
            end
        end 
      endcase
      
      if(dif.transfer)
        begin 
          if(dif.wr)
            mem[dif.paddr] <= dif.pwdata;
          else
            dif.prdata <= mem[dif.paddr];
        end
    
    end
  end
/*
  always @(posedge dif.clock)
  begin
    `uvm_info("", $sformatf("DUT received cmd=%b, addr=%d, data=%d",
                            dif.cmd, dif.addr, dif.data), UVM_MEDIUM)
  end
*/  
endmodule
