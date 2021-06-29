// tmp.v --- 
// 
// Description: 
// Author: Hongyi Wu(吴鸿毅)
// Email: wuhongyi@qq.com 
// Created: 一 6月  7 20:22:45 2021 (+0800)
// Last-Updated: 二 6月 29 22:03:05 2021 (+0800)
//           By: Hongyi Wu(吴鸿毅)
//     Update #: 13
// URL: http://wuhongyi.cn 

xpm_cdc_single #(2, 0, 0, 1)
xpm_cdc_single_inst
  (
   .src_clk(src_clk),
   .src_in(src_in),
   .dest_clk(dest_clk),
   .dest_out(dest_out)
   );




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


  

module arbiter_roundrobin
  (
   clk,
   resetb,
   req_vec,
   end_access_vec,
   gnt_vec
   );
   
   input clk;
   input resetb;
   input [2:0] req_vec;
   input [2:0] end_access_vec;
   output [2:0] gnt_vec;

   reg [1:0] 	arbiter_state, arbiter_state_nxt;
   reg [2:0] 	gnt_vec, gnt_vec_nxt;
   reg [2:0] 	relative_req_vec;
   wire 	any_req_asserted;
   reg [1:0] 	grant_posn, grant_posn_nxt;


   parameter IDLE = 2'b01, END_ACCESS = 2'b10;
   parameter IDLE_ID = 0, END_ACCESS_ID = 1;

   assign any_req_asserted = (req_vec!='d0);

   always @(*)
     begin
	relative_req_vec = req_vec;
	case(grant_posn)
	  2'd0: relative_req_vec = {req_vec[0], req_vec[2:1]};
	  2'd1: relative_req_vec = {req_vec[1:0], req_vec[2]};
	  2'd2: relative_req_vec = {req_vec[2:0]};
	  default: begin end
	endcase
     end
   
   always @(*)
     begin
	arbiter_state_nxt = arbiter_state;
	grant_posn_nxt = grant_posn;
	gnt_vec_nxt = gnt_vec;

	case(1'b1)
	  arbiter_state[IDLE_ID]:
	    begin
	       if((gnt_vec=='d0)||(end_access_vec[0]&gnt_vec[0])||(end_access_vec[1]&gnt_vec[1])||(end_access_vec[2]&gnt_vec[2]))
		 begin
		    if(any_req_asserted) arbiter_state_nxt = END_ACCESS;
		    if(relative_req_vec[0])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b010;
			   2'd1: gnt_vec_nxt = 3'b100;
			   2'd2: gnt_vec_nxt = 3'b001;
			   default: begin end
			 endcase

			 case(grant_posn)
			   2'd0: gnt_pos_nxt = 'd1;
			   2'd1: gnt_pos_nxt = 'd2;
			   2'd2: gnt_pos_nxt = 'd0;
			   default: begin end
			 endcase
		      end
		    else if(relative_req_vec[1])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b100;
			   2'd1: gnt_vec_nxt = 3'b001;
			   2'd2: gnt_vec_nxt = 3'b010;
			   default: begin end
			 endcase

			 case(grant_posn)
			   2'd0: gnt_pos_nxt = 'd2;
			   2'd1: gnt_pos_nxt = 'd0;
			   2'd2: gnt_pos_nxt = 'd1;
			   default: begin end
			 endcase			 
		      end
		    else if(relative_req_vec[2])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b001;
			   2'd1: gnt_vec_nxt = 3'b010;
			   2'd2: gnt_vec_nxt = 3'b100;
			   default: begin end
			 endcase

			 case(grant_posn)
			   2'd0: gnt_pos_nxt = 'd0;
			   2'd1: gnt_pos_nxt = 'd1;
			   2'd2: gnt_pos_nxt = 'd2;
			   default: begin end
			 endcase
		      end
		    else
		      gnt_vec_nxt = 3'b000;
		 end
	    end
	  arbiter_state[END_ACCESS_ID]:
	    begin
	       if((end_access_vec[0]&gnt_vec[0])||(end_access_vec[1]&gnt_vec[1])||(end_access_vec[2]&gnt_vec[2]))
		 begin
		    arbiter_state_nxt = IDLE;

		    if(relative_req_vec[0])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b010;
			   2'd1: gnt_vec_nxt = 3'b100;
			   2'd2: gnt_vec_nxt = 3'b001;
			   default: begin end
			 endcase

			 case(grant_posn)
			   2'd0: gnt_pos_nxt = 'd1;
			   2'd1: gnt_pos_nxt = 'd2;
			   2'd2: gnt_pos_nxt = 'd0;
			   default: begin end
			 endcase
		      end
		    else if(relative_req_vec[1])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b100;
			   2'd1: gnt_vec_nxt = 3'b001;
			   2'd2: gnt_vec_nxt = 3'b010;
			   default: begin end
			 endcase

			 case(grant_posn)
			   2'd0: gnt_pos_nxt = 'd2;
			   2'd1: gnt_pos_nxt = 'd0;
			   2'd2: gnt_pos_nxt = 'd1;
			   default: begin end
			 endcase			 
		      end
		    else if(relative_req_vec[2])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b001;
			   2'd1: gnt_vec_nxt = 3'b010;
			   2'd2: gnt_vec_nxt = 3'b100;
			   default: begin end
			 endcase

			 case(grant_posn)
			   2'd0: gnt_pos_nxt = 'd0;
			   2'd1: gnt_pos_nxt = 'd1;
			   2'd2: gnt_pos_nxt = 'd2;
			   default: begin end
			 endcase
		      end
		    else
		      gnt_vec_nxt = 3'b000;
		 end
	    end
	endcase
     end

   always @(posedge clk or negedge resetb)
     begin
	if(!resetb)
	  begin
	     arbiter_state <= IDLE;
	     gnt_vec <= 'd0;
	     grant_posn <= 'd2;
	  end
	else
	  begin
	     arbiter_state <= arbiter_state_nxt;
	     gnt_vec <= gnt_vector_nxt;
	     grant_posn <= grant_posn_nxt;
	  end
     end

endmodule






module arbiter_wrr
  (
   clk,
   resetb,
   req_vec,
   // req_vec_wt,
   req_vec_wt_0,
   req_vec_wt_1,
   req_vec_wt_2,
   req_n_valid,
   end_access_vec,
   gnt_vec
   );

   input clk;
   input resetb;
   input [2:0] req_vec;
   // input [3:0] [2:0] req_vec_wt; //from software writable registers
   input [3:0] req_vec_wt_0;
   input [3:0] req_vec_wt_1;
   input [3:0] req_vec_wt_2;
   input       req_n_valid;// when 1,req_vec_wt_X are valid
   input [2:0] end_access_vec;
   output [2:0] gnt_vec;


   reg [2:0] 	arbiter_state, arbiter_state_nxt;
   reg [2:0] 	gnt_vec, gnt_vec_nxt;
   reg [3:0] 	count_req_vec [2:0];
   reg [3:0] 	count_req_vec_nxt [2:0];
   wire [3:0] 	req_vec_wt [2:0];
   reg [3:0] 	req_vec_wt_stored [2:0];
   reg [3:0] 	req_vec_wt_stored_nxt [2:0];
   wire [2:0] 	cnt_reqdone_vec;

   parameter IDLE = 3'b001, ARM_VALUE = 3'b010, END_ACCESS = 3'b100;
   parameter IDLE_ID = 0, ARM_VALUE_ID = 1, END_ACCESS_ID = 2;
   
   assign  req_vec_wt[0] = req_vec_wt_0;
   assign  req_vec_wt[1] = req_vec_wt_1;
   assign  req_vec_wt[2] = req_vec_wt_2;
   
   always @(*)
     begin
	arbiter_state_nxt = arbiter_state;
	gnt_vec_nxt = gnt_vec;
	count_req_vec_nxt[0] = count_req_vec[0];
	count_req_vec_nxt[1] = count_req_vec[1];
	count_req_vec_nxt[2] = count_req_vec[2];

	case(1'b1)
	  arbiter_state[IDLE_ID]:
	    begin
	       if(req_n_valid)
		 begin
		    arbiter_state_nxt = ARM_VALUE;
		    count_req_vec_nxt[0] = req_vec_wt[0];
		    count_req_vec_nxt[1] = req_vec_wt[1];
		    count_req_vec_nxt[2] = req_vec_wt[2];
		    req_vec_wt_stored_nxt[0] = req_vec_wt[0];
		    req_vec_wt_stored_nxt[1] = req_vec_wt[1];
		    req_vec_wt_stored_nxt[2] = req_vec_wt[2];
		    gnt_vec_nxt = 3'b000;
		 end
	    end
	  arbiter_state[ARM_VALUE_ID]:
	    begin
	       if((gnt_vec=='d0)||(end_access_vec[0]&gnt_vec[0])||(end_access_vec[1]&gnt_vec[1])||(end_access_vec[2]&gnt_vec[2]))
		 begin
		    if(req_vec[0]&!cnt_reqdone_vec[0])
		      begin
			 arbiter_state_nxt = END_ACCESS;
			 gnt_vec_nxt = 3'b001;
			 count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
		      end
		    else if(req_vec[1]&!cnt_reqdone_vec[1])
		      begin
			 arbiter_state_nxt = END_ACCESS;
			 gnt_vec_nxt = 3'b010;
			 count_req_vec_nxt[1] = count_req_vec[1]-1'b1;			 
		      end
		    else if(req_vec[2]&!cnt_reqdone_vec[2])
		      begin
			 arbiter_state_nxt = END_ACCESS;
			 gnt_vec_nxt = 3'b100;
			 count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
		      end
		    else
		      begin
			 count_req_vec_nxt[0] = req_vec_wt_stored[0];
			 count_req_vec_nxt[1] = req_vec_wt_stored[1];
			 count_req_vec_nxt[2] = req_vec_wt_stored[2];
			 gnt_vec_nxt = 3'b000;
		      end
		 end
	    end
	  arbiter_state[END_ACCESS_ID]:
	    begin
	       if((end_access_vec[0]&gnt_vec[0])||(end_access_vec[1]&gnt_vec[1])||(end_access_vec[2]&gnt_vec[2]))
		 begin
		    arbiter_state_nxt = ARM_VALUE;

		    if(req_vec[0]&!cnt_reqdone_vec[0])
		      begin
			 gnt_vec_nxt = 3'b001;
			 count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
		      end
		    else if(req_vec[1]&!cnt_reqdone_vec[1])
		      begin
			 gnt_vec_nxt = 3'b010;
			 count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
		      end
		    else if(req_vec[2]&!cnt_reqdone_vec[2])
		      begin
			 gnt_vec_nxt = 3'b100;
			 count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
		      end
		    else
		      begin
			 count_req_vec_nxt[0] = req_vec_wt_stored[0];
			 count_req_vec_nxt[1] = req_vec_wt_stored[1];
			 count_req_vec_nxt[2] = req_vec_wt_stored[2];
			 gnt_vector_nxt = 3'b000;
		      end
		 end
	    end
	endcase
     end

   assign cnt_reqdone_vec[0] = (count_req_vec[0]='d0);
   assign cnt_reqdone_vec[1] = (count_req_vec[1]='d0);
   assign cnt_reqdone_vec[2] = (count_req_vec[2]='d0);


   always @(posedge clk or negedge resetb)
     begin
	if(!resetb)
	  begin
	     arbiter_state <= IDLE;
	     gnt_vec <= 'd0;
	     count_req_vec[0] <= 'd0;
	     count_req_vec[1] <= 'd0;
	     count_req_vec[2] <= 'd0;
	     req_vec_wt_stored[0] <= 'd0;
	     req_vec_wt_stored[1] <= 'd0;
	     req_vec_wt_stored[2] <= 'd0;
	  end
	else
	  begin
	     arbiter_state <= arbiter_state_nxt;
	     gnt_vec <= gnt_vec_nxt;
	     count_req_vec[0] <= count_req_vec_nxt[0];
	     count_req_vec[1] <= count_req_vec_nxt[1];
	     count_req_vec[2] <= count_req_vec_nxt[2];
	     req_vec_wt_stored[0] <= req_vec_wt_stored_nxt[0];
	     req_vec_wt_stored[1] <= req_vec_wt_stored_nxt[1];
	     req_vec_wt_stored[2] <= req_vec_wt_stored_nxt[2];
	  end
     end
  
endmodule




module arbiter_wrr
  (
   clk,
   resetb,
   req_vec,
   // req_vec_wt,
   req_vec_wt_0,
   req_vec_wt_1,
   req_vec_wt_2,
   req_n_valid,
   end_access_vec,
   gnt_vec
   );

   input clk;
   input resetb;
   input [2:0] req_vec;
   // input [3:0] [2:0] req_vec_wt; //from software writable registers
   input [3:0] req_vec_wt_0;
   input [3:0] req_vec_wt_1;
   input [3:0] req_vec_wt_2;
   input       req_n_valid;// when 1,req_vec_wt_X are valid
   input [2:0] end_access_vec;
   output [2:0] gnt_vec;


   reg [2:0] 	arbiter_state, arbiter_state_nxt;
   reg [2:0] 	gnt_vec, gnt_vec_nxt;
   reg [3:0] 	count_req_vec [2:0];
   reg [3:0] 	count_req_vec_nxt [2:0];
   wire [2:0] 	cnt_reqdone_vec;
   reg [2:0] 	relative_req_vec;
   reg [1:0] 	grant_posn, grant_posn_nxt;
   reg [2:0] 	relative_cntdone_vec;
   reg [3:0] 	req_vec_wt_stored [2:0];
   reg [3:0] 	req_vec_wt_stored_nxt [2:0];
   wire [3:0] 	req_vec_wt [2:0];
   
   parameter IDLE = 3'b001, ARM_VALUE = 3'b010, END_ACCESS = 3'b100;
   parameter IDLE_ID = 0, ARM_VALUE_ID = 1, END_ACCESS_ID = 2;

   assign  req_vec_wt[0] = req_vec_wt_0;
   assign  req_vec_wt[1] = req_vec_wt_1;
   assign  req_vec_wt[2] = req_vec_wt_2;

   always @(*)
     begin
	relative_req_vec = req_vec;
	case(grant_posn)
	  2'd0: relative_req_vec = {req_vec[0], req_vec[2:1]};
	  2'd1: relative_req_vec = {req_vec[1:0], req_vec[2]};
	  2'd2: relative_req_vec = {req_vec[2:0]};
	  default : begin end
	endcase
     end

   always @(*)
     begin
	relative_cntdone_vec = cnt_reqdone_vec;
	case(grant_posn)
	  2'd0: relative_cntdone_vec = {cnt_reqdone_vec[0], cnt_reqdone_vec[2:1]};
	  2'd1: relative_cntdone_vec = {cnt_reqdone_vec[1:0], cnt_reqdone_vec[2]};
	  2'd2: relative_cntdone_vec = {cnt_reqdone_vec[2:0]};
	  default: begin end
	endcase
     end
   
   always @(*)
     begin
	arbiter_state_nxt = arbiter_state;
	gnt_vec_nxt = gnt_vec;
	count_req_vec_nxt[0] = count_req_vec[0];
	count_req_vec_nxt[1] = count_req_vec[1];
	count_req_vec_nxt[2] = count_req_vec[2];
	grant_posn_nxt = grant_posn;

	case(1'b1)
	  arbiter_state[IDLE_ID]:
	    begin
	       if(req_n_valid)
		 begin
		    arbiter_state_nxt = ARM_VALUE;
		    count_req_vec_nxt[0] = req_vec_wt[0];
		    count_req_vec_nxt[1] = req_vec_wt[1];
		    count_req_vec_nxt[2] = req_vec_wt[2];
		    req_vec_wt_stored_nxt[0] = req_vec_wt[0];
		    req_vec_wt_stored_nxt[1] = req_vec_wt[1];
		    req_vec_wt_stored_nxt[2] = req_vec_wt[2];
		    gnt_vec_nxt = 3'b000;
		 end
	    end	
	  arbiter_state[ARM_VALUE_ID]:
	    begin
	       if((gnt_vec=='d0)||(end_access_vec[0]&gnt_vec[0])||(end_access_vec[1]&gnt_vec[1])||(end_access_vec[2]&gnt_vec[2]))
		 begin
		    if(relative_req_vec[0]&!relative_cntdone_vec[0])
		      begin
			 arbiter_state_nxt = END_ACCESS;
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b010;
			   2'd1: gnt_vec_nxt = 3'b100;
			   2'd2: gnt_vec_nxt = 3'b001;
			   default: begin end
			 endcase 
			 case(grant_posn)
			   2'd0: count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
			   2'd1: count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
			   2'd2: count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
			   default: begin end
			 endcase
			 case(grant_posn)
			   2'd0: grant_posn_nxt = 'd1;
			   2'd1: grant_posn_nxt = 'd2;
			   2'd2: grant_posn_nxt = 'd0;
			   default: begin end
			 endcase 			   
		      end
		    else if(relative_req_vec[1]&!relative_cntdone_vec[1])
		      begin
			 arbiter_state_nxt = END_ACCESS;
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b100;
			   2'd1: gnt_vec_nxt = 3'b001;
			   2'd2: gnt_vec_nxt = 3'b010;
			   default: begin end
			 endcase 
			 case(grant_posn)
			   2'd0: count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
			   2'd1: count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
			   2'd2: count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
			   default: begin end
			 endcase
			 case(grant_posn)
			   2'd0: grant_posn_nxt = 'd2;
			   2'd1: grant_posn_nxt = 'd0;
			   2'd2: grant_posn_nxt = 'd1;
			   default: begin end
			 endcase 
		      end
		    else if(relative_req_vec[2]&!relative_cntdone_vec[2])
		      begin
			 arbiter_state_nxt = END_ACCESS;
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b001;
			   2'd1: gnt_vec_nxt = 3'b010;
			   2'd2: gnt_vec_nxt = 3'b100;
			   default: begin end
			 endcase 
			 case(grant_posn)
			   2'd0: count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
			   2'd1: count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
			   2'd2: count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
			   default: begin end
			 endcase
			 case(grant_posn)
			   2'd0: grant_posn_nxt = 'd0;
			   2'd1: grant_posn_nxt = 'd1;
			   2'd2: grant_posn_nxt = 'd2;
			   default: begin end
			 endcase 
		      end
		    else
		      begin
			 gnt_vec_nxt = 3'b000;
			 count_req_vec_nxt[0] = req_vec_wt_stored[0];
			 count_req_vec_nxt[1] = req_vec_wt_stored[1];
			 count_req_vec_nxt[2] = req_vec_wt_stored[2];
		      end
		 end
	    end	  
	  arbiter_state[END_ACCESS_ID]:
	    begin
	       if((end_access_vec[0]&gnt_vec[0])||(end_access_vec[1]&gnt_vec[1])||(end_access_vec[2]&gnt_vec[2]))
		 begin
		    arbiter_state_nxt = ARM_VALUE;
		    if(relative_req_vec[0]&!relative_cntdone_vec[0])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b010;
			   2'd1: gnt_vec_nxt = 3'b100;
			   2'd2: gnt_vec_nxt = 3'b001;
			   default: begin end			   
			 endcase
			 case(grant_posn)
			   2'd0: count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
			   2'd1: count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
			   2'd2: count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
			   default: begin end
			 endcase
			 case(grant_posn)
			   2'd0: grant_posn_nxt = 'd1;
			   2'd1: grant_posn_nxt = 'd2;
			   2'd2: grant_posn_nxt = 'd0;
			   default: begin end
			 endcase 			 
		      end
		    else if(relative_req_vec[1]&!relative_cntdone_vec[1])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b100;
			   2'd1: gnt_vec_nxt = 3'b001;
			   2'd2: gnt_vec_nxt = 3'b010;
			   default: begin end			   
			 endcase
			 case(grant_posn)
			   2'd0: count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
			   2'd1: count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
			   2'd2: count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
			   default: begin end
			 endcase
			 case(grant_posn)
			   2'd0: grant_posn_nxt = 'd2;
			   2'd1: grant_posn_nxt = 'd0;
			   2'd2: grant_posn_nxt = 'd1;
			   default: begin end
			 endcase
		      end
		    else if(relative_req_vec[2]&!relative_cntdone_vec[2])
		      begin
			 case(grant_posn)
			   2'd0: gnt_vec_nxt = 3'b001;
			   2'd1: gnt_vec_nxt = 3'b010;
			   2'd2: gnt_vec_nxt = 3'b100;
			   default: begin end			   
			 endcase
			 case(grant_posn)
			   2'd0: count_req_vec_nxt[0] = count_req_vec[0]-1'b1;
			   2'd1: count_req_vec_nxt[1] = count_req_vec[1]-1'b1;
			   2'd2: count_req_vec_nxt[2] = count_req_vec[2]-1'b1;
			   default: begin end
			 endcase
			 case(grant_posn)
			   2'd0: grant_posn_nxt = 'd0;
			   2'd1: grant_posn_nxt = 'd1;
			   2'd2: grant_posn_nxt = 'd2;
			   default: begin end
			 endcase
		      end
		    else
		      begin
			 gnt_vec_nxt = 3'b000;
			 count_req_vec_nxt[0] = req_vec_wt_stored[0];
			 count_req_vec_nxt[1] = req_vec_wt_stored[1];
			 count_req_vec_nxt[2] = req_vec_wt_stored[2];
		      end
		 end
	    end
	endcase
     end

   assign cnt_reqdone_vec[0] = (count_req_vec[0]='d0);
   assign cnt_reqdone_vec[1] = (count_req_vec[1]='d0);
   assign cnt_reqdone_vec[2] = (count_req_vec[2]='d0);

   always @(posedge clk or negedge resetb)
     begin
	if(!resetb)
	  begin
	     arbiter_state <= IDLE;
	     gnt_vec <= 'd0;
	     count_req_vec[0] <= 'd0;
	     count_req_vec[1] <= 'd0;
	     count_req_vec[2] <= 'd0;
	     req_vec_wt_stored[0] <= 'd0;
	     req_vec_wt_stored[1] <= 'd0;
	     req_vec_wt_stored[2] <= 'd0;
	     grant_posn <= 'd2;
	  end
	else
	  begin
	     arbiter_state <= arbiter_state_nxt;
	     gnt_vec <= gnt_vec_nxt;
	     count_req_vec[0] <= count_req_vec_nxt[0];
	     count_req_vec[1] <= count_req_vec_nxt[1];
	     count_req_vec[2] <= count_req_vec_nxt[2];
	     req_vec_wt_stored[0] <= req_vec_wt_stored_nxt[0];
	     req_vec_wt_stored[1] <= req_vec_wt_stored_nxt[1];
	     req_vec_wt_stored[2] <= req_vec_wt_stored_nxt[2];
	     grant_posn <= grant_posn_nxt;
	  end
     end
   
endmodule



// 
// tmp.v ends here
