.. exp.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 8月 10 22:02:10 2019 (+0800)
.. Last-Updated: 六 6月 12 21:51:56 2021 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 21
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
      output	r_ack;
    
      localparam IDLE_R = 1'b0, ASSERT_ACK = 1'b1;
      reg		r_hndshk_state, r_hndshk_state_nxt;
      reg		r_ack, r_ack_nxt;
      reg [31:0]	t_data_rclk, t_data_rclk_nxt;
      reg		t_rdy_d1, t_rdy_rclk;
      
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




**复位方法**

复位被用来将数字电路中的触发器强制设置到一个确定的初始值上，从而使状态机和其它的控制电路可以从一个已知的初始状态开始工作。带有复位引脚的触发器所占用的芯片面积比没有复位引脚的触发器略微大一些。在某些情况下，处于数据处理路径上的触发器的初始值无关紧要，此时可以使用不带复位引脚的触发器，以将低芯片的总面积。电路中有两种典型的复位方法，非同步复位和同步复位。


**非同步复位（异步复位）**

采用异步复位时，触发器中存在一个复位端。一般情况下，复位时低电平有效的，通常用 reset# 来表示。当 reset# 为低电平时，触发器输出立刻变成 0 或 1。 reset# 可以在任何时刻被置为低电平，它与时钟边沿之间可以没有任何关系，因此这种复位方式被称为异步复位。

需要注意的是，当 reset# 被置为高电平时，它必须与时钟的上升沿同步。 reset# 从 0 到 1 翻转时，不能离时钟的上升沿太近，不然会产生与违反建立时间/保持时间类似的输出不稳定问题，此时它被称为复位恢复错误。有时候一个复位信号会经过不同的时钟域，此时不能直接使用该复位信号。此时它的上升沿必须与新时钟域进行同步以免产生复位恢复错误。针对跨时钟域的同步，可以使用专门设计的复位同步电路。

**复位同步电路**

这里给出一种复位同步电路的代码：

.. code:: verilog 

   module reset_synchronizer
     (
      clkb,
      rstb_in,
      rstb_sync
      );
      
      input clkb;
      input rstb_in;
      output rstb_sync;
    
      reg	  rstb_in_pre, rstb_sync;
    
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



**同步复位**

采用同步复位时，没有专用的复位端。复位信号时决定触发器输入信号值的变量之一。由于复位信号被当成输入信号的一部分，因此它必须满足和一般数据输入一样的建立时间和保持时间要求。


**异步复位和同步复位的选择**

异步复位和同步复位都可以用于数字系统设计之中。异步复位信号必须直接来自触发器，并且复位信号中不能有毛刺。对于同步复位来说，复位信号可以容忍毛刺，前提是毛刺不能不现在建立时间和保持时间窗口内。由于异步复位不依赖于时钟，因此在时钟没有运行根本没有时钟的情况下可以使用。对于同步复位方法，必须在有时钟的情况下才能进行复位。另外，同步复位信号会出现在数据延迟路径中，可能会带来路径延迟的增加，对于告诉设计来说需要仔细考虑，可能会产生不良影响。




**仲裁**

**关于仲裁**

当多个源和用户需要共享同一资源时，需要某种仲裁形式，使得所有用户基于一定的规则或算法得到获取或访问资源的机会。例如，共享总线上可以连接多个总线用户。另一个例子司交换中的端口仲裁，当多个入口希望通过某一个出口输出数据时，需要使用一定的端口仲裁机制来选择某一时刻允许哪一个入口发送数据。最简单的仲裁方案是公平轮询方案，此时，仲裁器公平地对待所有的用户请求，不同用户具有均等的机会。然而，如果某些设备的速度快于其它设备，它需要更多的对共享资源的访问机会，或者某些用户具有更高的处理优先级，那么简单的循环方案是不够的。

在此情形下，使用严格优先级轮询或者权重轮询方案更为合适。也有一些方案将多种轮询方案结合起来使用。无论采用哪一种方案，都应该保证让某些用户始终得到资源。

**常规仲裁方案**

根据需要，设计者可以选择和设计自己所需要的仲裁（轮询）方案。下面讨论经常使用的经典方案。

- 严格优先级轮询
   - 根据优先级的差异，用户访问共享资源的机会也不同
   - 低优先级的用户可能始终无法得到资源
- 公平轮询
   - 公平地对待所有请求
   - 所有用户获得均等的访问机会，不会有用户始终无法得到资源
- 权重轮询
   - 兼顾了公平和差异性
   - 在一个轮询周期内，不同权重的用户会得到不同的访问次数
   - 在一个轮询周期内，不同权重的用户会得到不同的访问时间片
- 混合优先级（高优先级组和低优先级组）
   - 组间按照优先级轮询，组内采用公平轮询

**严格优先级轮询**

在严格优先级轮询方案中，发出请求的用户有固定的优先级。我们假设有8个用户（agent），agent0 具有最高优先级，agent7 具有最低优先级。在本方案中，优先级高的用户只要保持请求，就会持续得到授权。随着优先级不断降低，用户得到授权的机会也随之下降。该方案可以根据用户的重要性提供不同的服务，但低优先级用户可能长时间得不到服务。此时可以通过对高优先级用户增加一些请求约束的方法来避免低优先级用户被“饿死”。


严格优先级轮询代码如下：

.. code:: verilog 

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
    
      reg [1:0]		arbiter_state, arbiter_state_nxt;
      reg [3:0]		gnt_vector, gnt_vector_nxt;
      wire	any_request;
    
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


**公平轮询**

在公平轮询方案中，所有用户优先级相等，每个用户依次获得授权。一开始，选择用户的顺序可以是任意的，但在一个轮询周期内，所有发出请求的用户都有公平得到授权的机会。以具有个用户的总线为例，它们全部将请求信号置为有效（高电平）。request0 将首先被授权，紧跟着 request1、request2，最后是 request3。当循环完成后，request0 才会被重新授权。仲裁器每次仲裁时，依次查看每个用户的请求信号是否有效，如果一个用户的请求无效，那么将按序查看下一个用户。仲裁器会记住上一次被授权的用户，当该用户的操作完成后，仲裁器会按序轮询其它用户是否有请求。

一旦某个用户得到了授权，它可以长时间使用总线或占用资源，直到当前数据包传送结束或一个访问过程结束后，仲裁器才会授权其它用户进行操作。这种方案的一个特点是仲裁器没有对用户获得授权后使用总线或访问资源的时间进行约束。该方案适用于基于数据包的协议，例如，以太网交换或 PCIe 交换机，当多个入口的包希望从一个端口输出时，可以采用这种机制。此外还有一种机制，每个用户获得授权后，可以占用资源的时间片长度是受约束的，每个用户可以占用资源的时间不能超过规定的长度。如果一个用户在所分配的时间结束之前完成了操作，仲裁器将轮询后续的用户。如果在分配的时间内用户没有完成操作，则仲裁器收回授权并轮询后续用户。此方案适用于突发操作，每次处理一个突发（一个数据块），此时没有数据包的概念。传统的 PCI 总线或 AMBA 、AHB 总线采用的就是这种方案。在 PCI 中，仲裁器会给当前获得授权的主机留出一个或多个时钟周期的时间供主机保存当前操作信息，下一次再获得授权时，该主机可以接着传输数据。

公平轮询的代码如下：

.. code:: verilog 

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
    
      reg [1:0]		arbiter_state, arbiter_state_nxt;
      reg [2:0]		gnt_vec, gnt_vec_nxt;
      reg [2:0]		relative_req_vec;
      wire	any_req_asserted;
      reg [1:0]		grant_posn, grant_posn_nxt;
    
    
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


**公平轮询（仲裁w/o死周期）**

再前面公平轮询仲裁器的 verilog 代码中，每个用户有三个信号：request（请求）、grant（授权）和 end_access（结束访问）。为了满足定时要求，


	  
.. 
.. exp.rst ends here
