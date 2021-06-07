// tmp.v --- 
// 
// Description: 
// Author: Hongyi Wu(吴鸿毅)
// Email: wuhongyi@qq.com 
// Created: 一 6月  7 20:22:45 2021 (+0800)
// Last-Updated: 一 6月  7 20:48:39 2021 (+0800)
//           By: Hongyi Wu(吴鸿毅)
//     Update #: 2
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


   
   

   




// 
// tmp.v ends here
