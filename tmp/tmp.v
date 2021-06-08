// tmp.v --- 
// 
// Description: 
// Author: Hongyi Wu(吴鸿毅)
// Email: wuhongyi@qq.com 
// Created: 一 6月  7 20:22:45 2021 (+0800)
// Last-Updated: 二 6月  8 20:57:19 2021 (+0800)
//           By: Hongyi Wu(吴鸿毅)
//     Update #: 4
// URL: http://wuhongyi.cn 

input sig_a;
reg sig_a_d1;
wire sig_a_risedge;

always @(posedge clk or negedge rstb)
  begin
     if(!rstb) sig_a_d1 <= 1'b0;
     else sig_a_d1 <= sig_a;
  end

assign sig_a_risedge = sig_a & !sig_a_d1;
   




input sig_a;
reg sig_a_d1;
wire sig_a_faledge;

always @(posedge clk or negedge rstb)
  begin
     if(!rstb) sig_a_d1 <= 1'b0;
     else sig_a_d1 <= sig_a;
  end

assign sig_a_faledge = !sig_a & sig_a_d1;
   

   

input sig_a;
reg sig_a_d1;
wire sig_a_anyedge;

always @(posedge clk or negedge rstb)
  begin
     if(!rstb) sig_a_d1 <= 1'b0;
     else sig_a_d1 <= sig_a;
  end

assign sig_a_anyedge = (!sig_a & sig_a_d1) | (sig_a & !sig_a_d1);
  



   input sig_a;//domain clka
   input clkb;
   input rstb;
   reg 	 sig_a_d1, sig_a_d2, sig_a_d3;
   wire  sig_a_posedge;

   assign sig_a_posedge = sig_a_d2 & !sig_a_d3;

   always @(posedge clkb or negedge rstb)
     begin
	if(!rstb)
	  begin
	     sig_a_d1 <= 1'b0;
	     sig_a_d2 <= 1'b0;
	     sig_a_d3 <= 1'b0;
	  end
	else
	  begin
	     sig_a_d1 <= sig_a;
	     sig_a_d2 <= sig_a_d1;
	     sig_a_d3 <= sig_a_d2;
	  end
     end


   
   
module handshake_tclk
  (
   tclk,
   resetb_tclk,
   t_rdy,
   data_avail,
   transmit_data,
   t_data,
   r_ack
   );

   input tclk;
   input resetb_tclk;

   input r_ack;
   input data_avail;
   input [31:0] transmit_data;
   output 	t_rdy;
   output [31:0] t_data;
   
   localparam IDLE_T = 2'd0, ASSERT_TRDY = 2'd1, DEASSERT_TRDY = 2'd2;
   
   reg [1:0] 	 t_hndshk_state, t_hndshk_state_nxt;
   reg 		 t_rdy, t_rdy_nxt;
   reg [31:0] 	 t_data, t_data_nxt;
   reg 		 r_ack_d1, r_ack_tclk;
   

   always @(*)
     begin
	t_hndshk_state_nxt = t_hndshk_state;
	t_rdy_nxt = 1'b0;
	t_data_nxt = t_data;

	case(t_hndshk_state)
	  IDLE_T: 
	    begin
	       if(data_avail) // if the data is available in transmit side
		 begin
		    t_hndshk_state_nxt = ASSERT_TRDY;
		    t_rdy_nxt = 1'b1;
		    t_data_nxt = transmit_data;// data to be transferred
		 end
	    end
	  ASSERT_TRDY:
	    begin
	       if(r_ack_tclk)
		 begin
		    t_rdy_nxt = 1'b0;
		    t_hndshk_state_nxt = DEASSERT_TRDY;
		    t_data_nxt = 'd0;
		 end
	       else
		 begin
		    t_rdy_nxt = 1'b1;// keep driving until r_ack_tclk=1
		    t_data_nxt = t_data;// keep supplying data
		 end
	    end
	  DEASSERT_TRDY:
	    begin
	       if(!r_ack_tclk)
		 begin
		    if(data_avail)
		      begin
			 t_hndshk_state_nxt = ASSERT_TRDY;
			 t_rdy_nxt = 1'b1;
			 t_data_nxt = transmit_data;
		      end
		    else
		      t_hndshk_state_nxt = IDLE_T;
		 end
	    end
	  default: 
	    begin
	    end
	endcase
     end

   always @(posedge tclk or negedge resetb_tclk)
     begin
	if(!resetb_tclk)
	  begin
	     t_hndshk_state <= IDLE_T;
	     t_rdy <= 1'b0;
	     t_data <= 'd0;
	     r_ack_d1 <= 1'b0;
	     r_ack_tclk <= 1'b0;
	  end
	else
	  begin
	     t_hndshk_state <= t_hndshk_state_nxt;
	     t_rdy <= t_rdy_nxt;
	     t_data <= t_data_nxt;
	     r_ack_d1 <= r_ack;
	     r_ack_tclk <= r_ack_d1;
	  end
     end

endmodule
   




module handshake_rclk
  (
   rclk,
   resetb_rclk,
   t_rdy,
   t_data,
   r_ack
   );

   input rclk;
   input resetb_rclk;
   input t_rdy;
   input [31:0] t_data;
   output 	r_ack;


   



endmodule   














// 
// tmp.v ends here
