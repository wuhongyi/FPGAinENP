.. temp.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 10月  5 19:14:02 2019 (+0800)
.. Last-Updated: 六 10月  5 19:37:16 2019 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 1
.. URL: http://wuhongyi.cn 

##################################################
临时存放
##################################################


============================================================
Verilog $random用法 随机数
============================================================

$random函数调用时返回一个32位的随机数，它是一个带符号的整形数.

.. code:: verilog
	  
   reg[23:0] rand;
   //产生一个在 -59 — 59 范围的随机数
   rand=$random%60; 

   // 产生 0~59 之间的随机数的例子
   rand={$random} %60; //通过位拼接操作{}

   // 产生一个在 min, max 之间随机数
   rand = min+{$random}%(max-min+1);


============================================================
verilog数组定义及其初始化
============================================================

这里的内存模型指的是内存的行为模型。Verilog 中提供了两维数组来帮助我们建立内存的行为模型。具体来说，就是可以将内存宣称为一个reg类型的数组，这个数组中的任何一个单元都可以通过一个下标去访问。这样的数组的定义方式如下：

.. code:: verilog
	  
   reg [wordsize : 0] array_name [0 : arraysize];

   // 例如：
   reg [7:0] my_memory [0:255];
   // 其中 [7:0] 是内存的宽度，而[0:255]则是内存的深度（也就是有多少存储单元），其中宽度为8位，深度为256。地址0对应着数组中的0存储单元。

   // 如果要存储一个值到某个单元中去，可以这样做：
   my_memory [address] = data_in;

   // 而如果要从某个单元读出值，可以这么做：
   data_out = my_memory [address];

   // 但要是只需要读一位或者多个位，就要麻烦一点，因为Verilog不允许读/写一个位。这时，就需要使用一个变量转换一下：
   // 例如：
   data_out = my_memory[address];
   data_out_it_0 = data_out[0];
   // 这里首先从一个单元里面读出数据，然后再取出读出的数据的某一位的值。

----------------------------------------------------------------------
 初始化内存
----------------------------------------------------------------------

初始化内存有多种方式，这里介绍的是使用$readmemb 和 $readmemh系统任务来将保存在文件中的数据填充到内存单元中去。$readmemb 和 $readmemh 是类似的，只不过 $readmemb 用于内存的二进制表示，而 $readmemh 则用于内存内容的 16 进制表示。这里以 $readmemh 系统任务来介绍。

语法

.. code:: verilog
	  
   $readmemh("file_name", mem_array, start_addr, stop_addr);

   // 注意的是：
   // file_name是包含数据的文本文件名，mem_array是要初始化的内存单元数组名，start_addr 和 stop_addr 是可选的，指示要初始化单元的起始地址和结束地址。

下面是一个简单的例子：

.. code:: verilog
	  
   module  memory ();
   reg [7:0] my_memory [0:255];

   initial begin
   $readmemh("memory.list", my_memory);
   end
   endmodule

   // 这里使用内存文件 memory.list 来初始化 my_memory 数组。

============================================================
组合逻辑for循环和generate生成块for循环
============================================================

例1：给一个100位的输入向量，颠倒它的位顺序输出

只需要将in[0]赋值给out[99]、in[1]赋值给out[98]......也可以直接用for循环，其规范格式如下：

.. code:: verilog
	  
   for（循环变量赋初值；循环执行条件；循环变量增值） 循环体语句块；

通过 for 循环赋值很方便：

.. code:: verilog
	  
  module top_module (
      input [99:0] in,
      output reg [99:0] out
  );
      
      always @(*) begin
          for (int i=0;i<$bits(out);i++)      // $bits() is a system function that returns the width of a signal.
              out[i] = in[$bits(out)-i-1];    // $bits(out) is 100 because out is 100 bits wide.
      end
      
  endmodule

例2：建立一个“人口计数器”来统计一个256位输入向量中1的数量

统计1的个数可以直接将每一bit位加起来，得到的数值即为1的个数。缩减运算符只有与或非，由于加法不是一个简单地逻辑门就可以计算，所以只能一位一位的提取出来相加，因此用for语句

.. code:: verilog
	  
  module top_module (
   	input [254:0] in,
   	output reg [7:0] out
  );
   
   	always @(*) begin	// Combinational always block
   		out = 0;        // if don't assign initial value zero,simulate errors will emerge
   		for (int i=0;i<255;i++)
   			out = out + in[i];
   	end
   	
  endmodule  


例3：通过实例化100个一位全加器制造一个100位的脉冲进位加法器

这个加法器将两个100位的输入信号和一个进位进位加起来产生一个100位的输出信号和进位信号。我们依旧用for循环语句，只是这次循环内容是另一个模块，在这里就要引入一个新的概念generate生成块。

.. code:: text
	  
  Verilog-2001添加了generate循环，允许产生module和primitive的多个实例化，同时也可以产生多个variable，net，task，function，continous assignment，initial和always。在generate语句中可以引入if-else和case语句，根据条件不同产生不同的实例化。
  用法：
  1. generate语法有generate for, genreate if和generate case三种
  2. generate for语句必须有genvar关键字定义for的变量
  3. for 的内容必须加begin和end
  4. 必须给for语段起个名字，这个名字会作为generate循环的实例名称。

标准格式：

.. code:: verilog
	  
  generate
  genvar i；//定义变量
  for(循环变量赋初值；循环执行条件；循环变量增值) begin：gfor  //生成后的例化名，gfor[1].ui(实例化)、gfor[2].ui(实例化)......
  //需要循环的实例模块
  end 
  endgenerate

因为第一个实例的输入是cin，其他的都是上一级的cout，因此把第一个单独例化。

.. code:: verilog
	  
  module top_module( 
      input [99:0] a, b,
      input cin,
      output [99:0] cout,
      output [99:0] sum );
      fadd u0(.a(a[0]),
              .b(b[0]),
              .cin(cin),
              .cout(cout[0]),
              .sum(sum[0])
              );   
      generate 
          genvar	i;	
          for(i=1;i<100;i++)begin: gfor						
                  fadd ui(.a(a[i]),        //this i of ui won't be replaced
                          .b(b[i]),
                          .cin(cout[i-1]),
                          .cout(cout[i]),
                          .sum(sum[i])
                          );
              end
          endgenerate
  endmodule
  module fadd( 
      input a, b, cin,
      output cout, sum );
      assign {cout,sum} = a+b+cin; 
  endmodule


https://blog.csdn.net/weixin_38197667/article/details/90401400


.. 
.. temp.rst ends here
