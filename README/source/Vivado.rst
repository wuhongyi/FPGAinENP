.. Vivado.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 5月 23 22:04:29 2020 (+0800)
.. Last-Updated: 三 6月  9 21:14:39 2021 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 5
.. URL: http://wuhongyi.cn 

##################################################
Vivado 软件
##################################################

============================================================
IP 核
============================================================

PLL


FIFO


RAMROM







============================================================
仿真
============================================================

DCP 文件不能直接用于仿真，需要转成可仿真的文件

转换的方法(在 tcl console 命令行输入转换命令)

.. code:: bash
	  
   open_checkpoint XXX.dcp
   write_vhdl -mode funcsim XXX.vhd
   write_verilog -mode funcsim XXX.v

============================================================
Verilog hdl 与 VHDL 混用
============================================================

由于在FPGA开发过程中，多人合作时可能遇到有人使用verilog hdl，有人使用VHDL的情况，这就涉及到了verilog hdl与VHDL的相互调用。

Verilog hdl调用VHDL很简单，只需要把VHDL的实体（entity）当成一个verilog模块（module）即可按verilog的格式调用。

  VHDL调用verilog hdl相对比较麻烦，需要先将verilog的模块（module）做成VHDL的元件（component），再进行调用。

总的来说，verilog与VHDL的混用也就是相互调用的方式，就是将对方当成自己的模块，然后按自己本身的语法来调用即可。即：

- Verilog调用VHDL是将VHDL的实体（entity）当成verilog中的模块（module）来调用；
- VHDL调用verilog是将verilog的模块(module)当成VHDL中的实体（entity）来调用，先元件化，再例化。

https://blog.csdn.net/u014586651/article/details/85076276



   
.. 
.. Vivado.rst ends here
