.. exp.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 8月 10 22:02:10 2019 (+0800)
.. Last-Updated: 二 6月  8 20:45:33 2021 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 9
.. URL: http://wuhongyi.cn 

##################################################
经验总结
##################################################

============================================================
计数器
============================================================

- 画出输入、输出波形（根据功能要求、画出输入和输出的波形）
- 画出计数器结构
- 确定加1条件（计数器数什么，加1条件不足则加flag_add）
- 确定计数器结束条件（数多少个，个数不同时，用变量法，即用x代替；x不足以区分时则加flag_sel）
- 如果有更新波形
- 其它信号变化点条件（其它信号：即输出或内部信号；变化点：0变1、1变0）
- 写出计数器代码
- 写出其它信号代码



============================================================
状态机
============================================================

- 明确功能
- 输出分析
- 状态合并
- 状态转移条件
- 转移条件
- 完整性检查
- 状态机代码
- 功能代码

============================================================
FIFO
============================================================

- FIFO的写使能写数据，同时用组合逻辑或者同时用时序逻辑。
- FIFO的读使能，用组合逻辑。
- 数据的输出用组合逻辑。

============================================================
波形
============================================================

- 时序逻辑的波形观看方法：时钟上升沿前看输入，时钟上升沿后看输出。
- 组合逻辑的波形观看方法：输入变输出即刻变。


============================================================
抄书
============================================================

**与门**

与门是具有两个或多个输入端和一个输入端的逻辑门。当所有的输入都是逻辑1时，与门输出为逻辑1.换句话说，如果任何输出为0则输出为0。

从原理上说，我们可以定义具有许多输入输入端口的与门，但在具体实现时还是有实际限制的。一般来说与门的输入端最多为4个或5个，如果需要更多的输入端口，那么可以将多个与门级联起来。另外，在实际应用中，通常更倾向于使用与非门，其逻辑功能端进行逻辑与后再取反输出，主要原因是采用CMOS工艺实现的与非门工作速度比与门快得多。

**扇入扇出**
  
逻辑门的扇入指的是一个逻辑门正常工作时输入端的数量，例如，理论上一个与门可以有20个输入端，但是包含20个输入端的与门在工作时可能会因为输入负荷过大而出现逻辑错误或者速度下降的情况，此时扇出就不能选为20。门电路的扇出与具体的电路制造工艺和电路结构有密切关系，进行集成电路设计时，电路单元库中会给出扇入的具体参数。

扇出是在不降低输出电平的情况下逻辑门能够驱动的负载的数量。例如，从理论上讲一个与门可以驱动20个以上的输入端，但此时门电路的输出电容负载非常大，电路的工作速度会严重下降。集成电路单元库中会给出不同类型门电路的扇出。综合工具进行RTL代码综合时，会从单元库中读取扇入和扇出参数，以确保不超过最大值要求。

**通用D触发器**

D触发器有数据、时钟、和 RST# 输入端以及 Q 和 ！Q 两个输出端。在每一个时钟的上升沿，输出 Q 将输入D 的值锁存，直到下一个时钟上升沿出现时才继续锁存当前 D 端的值。！Q 输出的值与 Q 输出的值相反。在时钟上升沿进行输出数据更新时，D 端的输入数据必须满足称为建立时间的定时要求，否则输出端 Q 可能会出现不确定值。

**建立时间**

在时钟上升沿值之前 D 需要保持稳定的最短时间称为建立时间。如果在建立时间内 D 的值发生了变化，那么将无法确定 Q 的电平，其可能为一个不确定的电平值。

**保持时间**

在时钟的上升沿之后的一段时间内，D 的输入值也不允许改变，否则也会造成 Q 输出的不稳定，这个窗口被称为保持时间。

**亚稳态**

当输入 D 在建立时间和保持时间窗口内发生变化时，在此后的几乎一个时钟周期内。输出电平既不是 0 也不是 1，处于不确定值。这种不稳定的状态也被称为亚稳态。亚稳态的输出将在下一个时钟的上升沿之前稳定为 0 或 1。如果亚稳态输出被用于其它逻辑门的输入，那么将会造成难以预计的不良影响，可能会造成连锁反应，使整个数字系统工作不稳定。因此，必须采取一定的设计手段避免 D 触发器进入亚稳态，或者避免亚稳态被传递，影响整个系统的稳定性。

当触发器的输入不满足建立时间和保持时间要求时，输出为亚稳态。为了使系统正常工作，必须采取一定的手段避免或消除其影响。在只有一个时钟的数字系统中（称为单时钟域数字系统），通过控制一个 D 触发器的输出到另一个 D 触发器输入之间组合逻辑门的数量。可以减少其带来的延迟从而避免 D 触发器的输入在建立时间和保持时间窗口内发生波动。但是，当一个数字系统中有两个或两个以上时钟时（称为多时钟域系统），会出现一个时钟域的 D 触发器的输出作为另一个时钟域的 D 触发器输入的情况，当两个时钟之间没有任何关联时，亚稳态的出现时无法避免的。

**信号同步规则**

当信号从一个时钟域进入另一个时钟域时，为了使信号正确传递同时保持系统工作稳定，必须遵循以下几条设计规则。

- 跨时钟域的信号必须直接来自源时钟域的寄存器输出。
   - 如果信号l来自组合逻辑 ，而不时直接来自触发器，可能会造成信号在目标时钟域中出现难以预料的不稳定情况，从而造成整个系统出现无法预测的问题。
- 使用逻辑单元库中的专用触发器实现两级同步器。
   - 这里所说的专用触发器与普通触发器有所不同，它们具有高驱动能力和高增益，这会使它们比常规的触发器更快地进入稳定状态。根据前面的分析，将两个或多个触发器级联起来可以减少亚稳态出现的概率，那么采用这种专用触发器，可以大大提高电路从亚稳态中摆脱出来的速度。
- 在一个点而不是在多个点上进行跨时钟域信号的同步。
   - 同步电路可以消除亚稳态及其传递，但得到的结果可能是 1 也可能是 0，当只有一个连接点时，最多是信号延迟不同的问题，如果是多个点，那么这些信号组合之后的结果可能性非常多，这会造成信号传递的错误，可能会导致下游系统出错。


**事件/边沿检测**

同步上升沿检测

.. code:: verilog
	  
  input sig_a;
  reg sig_a_d1;
  wire sig_a_risedge;
   
  always @(posedge clk or negedge rstb)
    begin
       if(!rstb) sig_a_d1 <= 1'b0;
       else sig_a_d1 <= sig_a;
    end
   
  assign sig_a_risedge = sig_a & !sig_a_d1;


同步下降沿检测

.. code:: verilog

  input sig_a;
  reg sig_a_d1;
  wire sig_a_faledge;
   
  always @(posedge clk or negedge rstb)
    begin
       if(!rstb) sig_a_d1 <= 1'b0;
       else sig_a_d1 <= sig_a;
    end
   
  assign sig_a_faledge = !sig_a & sig_a_d1;
   



同步上升/下降沿检测

.. code:: verilog

  input sig_a;
  reg sig_a_d1;
  wire sig_a_anyedge;
   
  always @(posedge clk or negedge rstb)
    begin
       if(!rstb) sig_a_d1 <= 1'b0;
       else sig_a_d1 <= sig_a;
    end
   
  assign sig_a_anyedge = (!sig_a & sig_a_d1) | (sig_a & !sig_a_d1);


异步输入上升沿检测

.. code:: verilog

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



**同步技术**

数据同步和在不同时钟域之间进行数据传输会经常出现。为避免任何差错、系统故障和数据破坏，正确的同步和数据传输就显得格外重要。这些问题的出现往往比较隐蔽，不易被发现，因此正确进行跨时钟域处理就显得极为重要。实现数据同步有许多种方式，在不同的情况下进行恰当的同步方式选择非常重要。这里简单介绍目前常用的两种同步技术。

**使用FIFO进行的数据同步**

当存在两个异步时钟域并且二者之间进行数据包传输时，双端口FIFO最为合适。FIFO有两个端口，一个端口写入输入数据，另一个端口读出数据。两个端口工作在相互独立的时钟域内，通过各自的指针（地址）来读写数据。由于每个端口工作在相互独立的时钟域内，因此读写操作可以独立实现并且不会出现任何差错。当FIFO变满时，应停止写操作，直到FIFO中出现空闲空间，同样，当FIFO为空时，应停止读操作，直到有新的数据被写入FIFO中。FIFO有满标记和空标记，有关FIFO操作的详细描述在相应章节给出。

**握手同步方式**

FIFO可用于在不同的时钟域之间进行数据包的传输，但是在一些应用中需要在不同时钟域之间进行少量数据传输。FIFO占用的硬件资源较大，此时可以考虑使用握手同步机制。

以下是握手同步机制的工作步骤：

- 用后缀 _t 表示发送端，用后缀 _r 表示接收端。发送时钟用 tclk 表示，接收时钟用 rclk 表示。数据从 tclk 域向 rclk 域传输；
- 当需要发送的数据准备好后，发送端将 t_rdy 信号置为有效，该信号必须在 tclk 下降沿时采样输出；
- 在 t_rdy 有效期间，t_data 必须保持稳定；
- 接收端在 rclk 域中采用双同步器同步 t_rdy 控制信号，并把同步后的信号命名为 t_rdy_rclk；
- 接收端在发现 t_rdy_rclk 信号有效时，t_data 已经安全地进入了 rclk 域，使用 rclk 对其进行采样，可以得到 t_data_rclk。由于数据已经在 rclk 域进行了正确采样，所以此后在 rclk 域使用该数据是安全的；
- 接收端将 r_ack 信号置为 1，信号必须在 rclk 下降沿输出；
- 发送端通过双同步器在 tclk 域内同步 r_ack 信号，同步后的信号称为 r_ack_tclk；
- 以上所有步骤称为“半握手”。这是因为发送端在输出下一数据之前，不会等到 r_ack_rclk 被置为 0；
- 半握手机制工作速度快，但是，使用半握手机制时需要谨慎，一旦使用不当，会导致操作错误；
- 从低频时钟域向高频时钟域传数据时，半握手机制较为适用，这是由于接收端可以更快地完成操作。然而，如果从高频时钟域向低频时钟域传输数据，则需要采用全握手机制；
- 当 r_ack_tclk 为高电平时，发送端将 t_rdy 置为 0；
- 当 t_rdy_rclk 为低电平时，接收端将 r_ack 置为 0；
- 当发送端发现 r_ack_tclk 为低电平后，全握手过程结束，传输端可以发送新的数据；  
- 显然，权握手过程耗时较长，数据传输速度较慢。然而，全握手机制稳定可靠，可以在两个任意频率的时钟域内安全地进行数据传输。

全握手机制代码如下：

.. code:: verilog

   // Verilog RTL for Full Handshake -Transmit
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
      output	t_rdy;								   
      output [31:0] t_data;							   
										   
      localparam IDLE_T = 2'd0, ASSERT_TRDY = 2'd1, DEASSERT_TRDY = 2'd2;	   
										   
      reg [1:0]		 t_hndshk_state, t_hndshk_state_nxt;				   
      reg		 t_rdy, t_rdy_nxt;						   
      reg [31:0]	 t_data, t_data_nxt;						   
      reg		 r_ack_d1, r_ack_tclk;						   
										   
										   
      always @(*)									   
	begin									   
	t_hndshk_state_nxt = t_hndshk_state;					   
	t_rdy_nxt = 1'b0;							   
	t_data_nxt = t_data;							   
										   
	case(t_hndshk_state)							   
	  IDLE_T:								   
	    begin								   
	       if(data_avail) // if the data is available in transmit s ide	   
		 begin								   
		    t_hndshk_state_nxt = ASSERT_TRDY;				   
		    t_rdy_nxt = 1'b1;						   
		    t_data_nxt = transmit_data;// data to be transferre d	   
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



.. code:: verilog 

   // Verilog RTL for Full Handshake - Receive
















	  
.. 
.. exp.rst ends here
