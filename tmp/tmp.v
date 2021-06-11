// tmp.v --- 
// 
// Description: 
// Author: Hongyi Wu(吴鸿毅)
// Email: wuhongyi@qq.com 
// Created: 一 6月  7 20:22:45 2021 (+0800)
// Last-Updated: 五 6月 11 20:56:57 2021 (+0800)
//           By: Hongyi Wu(吴鸿毅)
//     Update #: 8
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

   localparam IDLE_R = 1'b0, ASSERT_ACK = 1'b1;
   reg 		r_hndshk_state, r_hndshk_state_nxt;
   reg 		r_ack, r_ack_nxt;
   reg [31:0] 	t_data_rclk, t_data_rclk_nxt;
   reg 		t_rdy_d1, t_rdy_rclk;
   
   always @(*)
     begin
	r_hndshk_state_nxt = r_hndshk_state;
	r_ack_nxt = 1'b0;
	t_data_rclk_nxt = t_data_rclk;

	case(r_hndshk_state)
	  IDLE_R:
	    begin
	       if(t_rdy_rclk)
		 begin
		    r_hndshk_state_nxt = ASSERT_ACK;
		    r_ack_nxt = 1'b1;
		    t_data_rclk_nxt = t_data;
		 end
	    end
	  ASSERT_ACK:
	    begin
	       if(!t_rdy_rclk)
		 begin
		    r_ack_nxt = 1'b0;
		    r_hndshk_state_nxt = IDLE_R;
		 end
	       else
		 r_ack_nxt = 1'b1;
	    end
	  default:
	    begin
	    end
	endcase
     end

   always @(posedge rclk or negedge resetb_rclk)
     begin
	if(!resetb_rclk)
	  begin
	     r_hndshk_state <= IDLE_R;
	     r_ack <= 1'b0;
	     t_data_rclk <= 'd0;
	     t_rdy_d1 <= 1'b0;
	     t_rdy_rclk <= 1'b0;
	  end
	else
	  begin
	     r_hndshk_state <= r_hndshk_state_nxt;
	     r_ack <= r_ack_nxt;
	     t_data_rclk <= t_data_rclk_nxt;
	     t_rdy_d1 <= t_rdy;
	     t_rdy_rclk <= t_rdy_d1;
	  end
     end

endmodule   






module reset_synchronizer
  (
   clkb,
   rstb_in,
   rstb_sync
   );
   
   input clkb;
   input rstb_in;
   output rstb_sync;

   reg 	  rstb_in_pre, rstb_sync;

   always @(posedge clkb or negedge rstb_in)
     begin
	if(!rstb_in)
	  begin
	     rstb_in_pre <= 1'b0;
	     rstb_sync <= 1'b0;
	  end
	else
	  begin
	     rstb_in_pre <= 1'b1;
	     rstb_sync <= rstb_in_pre;
	  end
     end
   
endmodule







module arbiter_strict_priority
  (
   clk,
   resetb,
   req_vector,
   end_access_vector,
   gnt_vector
   );
   
   input clk;
   input resetb;
   input [3:0] req_vector;
   input [3:0] end_access_vector;
   output [3:0] gnt_vector;
   
   reg [1:0] 	arbiter_state, arbiter_state_nxt;
   reg [3:0] 	gnt_vector, gnt_vector_nxt;
   wire 	any_request;
   
   parameter IDLE = 2'b01, END_ACCESS = 2'b10;
   parameter IDLE_ID = 0, END_ACCESS_ID = 1;
   
   
   assign any_request = (req_vector!='d0);
   
   always @(*)
     begin
  	arbiter_state_nxt = arbiter_state;
  	gnt_vector_nxt = gnt_vector;
  	case(1'b1)
  	  arbiter_state[IDLE_ID]:
  	    begin
  	       if(any_request) arbiter_state_nxt = END_ACCESS;
  	       if(req_vector[0]) gnt_vector_nxt = 4'b0001;
  	       else if(req_vector[1]) gnt_vector_nxt = 4'b0010;
  	       else if(req_vector[2]) gnt_vector_nxt = 4'b0100;
  	       else if(req_vector[3]) gnt_vector_nxt = 4'b1000;
  	    end
  	  arbiter_state[END_ACCESS_ID]:
  	    begin
  	       if((end_access_vector[0]&gnt_vector[0])||(end_access_vector[1]&gnt_vector[1])||(end_access_vector[2]&gnt_vector[2])||(end_access_vector[3]&gnt_vector[3]))
  		 begin
  		    if(any_request) arbiter_state_nxt = END_ACCESS;
  		    else arbiter_state_nxt = IDLE;
		    
  		    if(req_vector[0]) gnt_vector_nxt = 4'b0001;
  		    else if(req_vector[1]) gnt_vector_nxt = 4'b0010;
  		    else if(req_vector[2]) gnt_vector_nxt = 4'b0100;
  		    else if(req_vector[3]) gnt_vector_nxt = 4'b1000;
  		    else gnt_vector_nxt = 4'b0000;
  		 end
  	    end
  	endcase
     end
   
   always @(posedge clk or negedge resetb)
     begin
  	if(!resetb)
  	  begin
  	     arbiter_state <= IDLE;
  	     gnt_vector <= 'd0;
  	  end
  	else
  	  begin
  	     arbiter_state <= arbiter_state_nxt;
  	     gnt_vector <= gnt_vector_nxt;
  	  end
     end
   
endmodule


  












// 
// tmp.v ends here
