.. Vivado.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 5月 23 22:04:29 2020 (+0800)
.. Last-Updated: 二 8月 18 20:40:53 2020 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 2
.. URL: http://wuhongyi.cn 

##################################################
Vivado 软件
##################################################

zheli


============================================================
仿真
============================================================

DCP 文件不能直接用于仿真，需要转成可仿真的文件

转换的方法(在 tcl console 命令行输入转换命令)

.. code:: bash
	  
   open_checkpoint XXX.dcp
   write_vhdl -mode funcsim XXX.vhd
   write_verilog -mode funcsim XXX.v

   
.. 
.. Vivado.rst ends here
