.. FSM.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 8月 10 21:50:39 2019 (+0800)
.. Last-Updated: 一 12月 28 20:17:01 2020 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 4
.. URL: http://wuhongyi.cn 

##################################################
状态机
##################################################

============================================================
状态机规则
============================================================


----------------------------------------------------------------------
状态机规则1： 使用四段式写法
----------------------------------------------------------------------

四段式不是指四个 always 代码，而是四段代码。另外需要注意的是，四段式状态机并非固定不变。如果没有输出信号就只有三段代码（两个always）；如果有多个输出信号，那么就会有多个always。

第一段，同步时序的 always 模块，格式化描述次态迁移到现态寄存器。

**VHDL**

.. code-block:: vhdl

  -- code here
  xxxxx;
  

**verilog**

.. code-block:: verilog

  always@(posedge clk or negedge rst_n)begin
     if(!rst_n)begin
      	state_c<= IDLE;
     end
     else begin
      	state_c<= state_n;
     end
  end


第二段，组合逻辑的 always 模块，描述状态转移判断条件。注意，转移条件用信号来表示，信号名要按规则来命名。


**VHDL**

.. code-block:: vhdl

  -- code here
  xxxxx;
  

**verilog**

.. code-block:: verilog

  always@(*)begin
      case(state_c)
          IDLE:begin
              if(idle2s1_start)begin
		state_n = S1;
              end
              else begin
		state_n = state_c;
              end
          end
          S1:begin
              if(s12s2_start)begin
		state_n = S2;
              end
              else begin
		state_n = state_c;
              end
          end
          S2:begin
              if(s22idl)begin
		state_n = IDLE;
              end
              else begin
		state_n = state_c;
              end
          end
	  default:begin
	      state_n = IDLE;
          end
      endcase
  end
   


第三段，用 assign 定义转移条件。注意，条件一定要加上现态。


**VHDL**

.. code-block:: vhdl

  -- code here
  xxxxx;
  

**verilog**

.. code-block:: verilog

  assign idle2s1_start =  state_c==IDLE && ;
  assign  s12s2_start  =state_c==S1   && ;
  assign  s22idl_start  =state_c==S2   && ;


第四段，设计输出信号。规范要求一段 always 代码设计一个信号，因此有多少个输出信号就有多少段 always 代码。

		
**VHDL**

.. code-block:: vhdl

  -- code here
  xxxxx;
  

**verilog**

.. code-block:: verilog

  always  @(posedge clk or negedge rst_n)begin
       if(!rst_n)begin
          out1 <=1'b0   
       end
       else if(state_c==S1)begin
          out1 <= 1'b1;
       end
       else begin
          out1 <= 1'b0;
       end
  end
		



----------------------------------------------------------------------
状态机规则2：四段式状态机第一段写法不变
----------------------------------------------------------------------

设计状态机时所有四段式状态机模板的第一段除了名字外的代码都可以直接用，不需要进行改动。

----------------------------------------------------------------------
状态机规则3：第二段的状态转移条件用信号来表示
----------------------------------------------------------------------

设计状态机时，要求四段式状态机的第二段中用信号名来表示转移条件，而无须直接写出具体的转移条件。

用信号名表示的好处是后续修改时只需改动信号的名字，并且方便根据状态机的命名修改对应的跳转条件。


----------------------------------------------------------------------
状态机规则4：用 assign 将状态转移条件写成 XX2XX_start 的形式
----------------------------------------------------------------------

状态机规则 3 要求转移条件用信号名来表示，这样一来设计就要编写很多信号名称，这也是设计工作中的一大困扰。因此制定此规则：将状态转移的条件信号用 xx2xx_start 的形式表示。

例如有三个状态 IDLE、READ、WRITE，若从 IDLE 跳转到 READ 状态，其跳转条件可以命名为：idle2read_start；若从 IDLE 跳转到 WRITE，其跳转条件可以命名为：idle2write_start。

这个命名方式既能够解决命名的困扰，又能直接从信号名看出信号的作用。

----------------------------------------------------------------------
状态机规则5：assign 定义状态转移条件信号时，必须加上当前状态
----------------------------------------------------------------------

状态机的第二段代码中使用信号名来表示转移条件，在代码后则需用 assign 对相应信号进行定义。注意，定义这个转移条件信号时必须加上当前状态，以避免因两个不同状态由同一种变化条件发生转移而导致错误。

**VHDL**

.. code-block:: vhdl

  -- code here
  xxxxx;
  

**verilog**

.. code-block:: verilog

  assign idle2s1_start = state_c==IDLE  && XX;
  assign s12s2_start  =state_c==S1   && XX;
  assign s22idl_start  =state_c==S2   && XX;


		
----------------------------------------------------------------------
状态机规则6：状态不变时使用state_n = state_c
----------------------------------------------------------------------

编写状态机代码时有很大一部分错误是复制粘贴过程出错造成的，很多会出现复制其它状态的代码时忘记修改状态的错误。此外，也有一部分写第二段状态机时，容易把状态保持不变写成 state_n=state_n。这个写法是错误的，因为组合逻辑只有锁存器才能有保持电路，而数字电路中通常不希望出现锁存器。

为此，这里规定，其四段式状态机的第二段，状态不变时使用 state_n=state_c。如下所示，可以自行对比。这样写不但可以减少出错的可能，还可以减少调试的时间。

**VHDL**

.. code-block:: vhdl

  -- code here
  xxxxx;
  

**verilog**

.. code-block:: verilog

  IDLE:begin
     if(idle2s1_start)begin
       state_n = S1;
     end
     else begin
       state_n = state_c;
     end
  end
   
  IDLE:begin
     if(idle2s1_start)begin
       state_n = S1;
     end
     else begin
       state_n = IDLE;
     end
  end




.. 
.. FSM.rst ends here
