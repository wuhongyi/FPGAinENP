.. Altera.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 5月 23 22:02:25 2020 (+0800)
.. Last-Updated: 三 6月 30 18:24:18 2021 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 8
.. URL: http://wuhongyi.cn 

##################################################
Altera 软件
##################################################


============================================================
Quartus
============================================================

.. image:: /_static/img/Quartus_use0.png

.. image:: /_static/img/Quartus_use1.png

.. image:: /_static/img/Quartus_use2.png

.. image:: /_static/img/Quartus_use3.png	   

.. image:: /_static/img/Quartus_use4.png   
	   
刷固件方式

.. image:: /_static/img/Quartus_use5.png

.. image:: /_static/img/Quartus_use6.png

.. image:: /_static/img/Quartus_use7.png
	   
.. image:: /_static/img/Quartus_use8.png

----------------------------------------------------------------------
IP 核
----------------------------------------------------------------------

PLL

.. image:: /_static/img/Quartus_IP_PLL0.png

.. image:: /_static/img/Quartus_IP_PLL1.png

.. image:: /_static/img/Quartus_IP_PLL2.png

.. image:: /_static/img/Quartus_IP_PLL3.png

.. image:: /_static/img/Quartus_IP_PLL4.png

.. image:: /_static/img/Quartus_IP_PLL5.png

.. image:: /_static/img/Quartus_IP_PLL6.png

.. image:: /_static/img/Quartus_IP_PLL7.png

.. image:: /_static/img/Quartus_IP_PLL8.png

.. image:: /_static/img/Quartus_IP_PLL9.png


	
FIFO

.. image:: /_static/img/Quartus_IP_FIFO0.png

.. image:: /_static/img/Quartus_IP_FIFO1.png

.. image:: /_static/img/Quartus_IP_FIFO2.png

.. image:: /_static/img/Quartus_IP_FIFO3.png

.. image:: /_static/img/Quartus_IP_FIFO4.png

.. image:: /_static/img/Quartus_IP_FIFO5.png

.. image:: /_static/img/Quartus_IP_FIFO6.png

.. image:: /_static/img/Quartus_IP_FIFO7.png




RAMROM

.. image:: /_static/img/Quartus_IP_RAMROM0.png

.. image:: /_static/img/Quartus_IP_RAMROM1.png

.. image:: /_static/img/Quartus_IP_RAMROM2.png

.. image:: /_static/img/Quartus_IP_RAMROM3.png
	   
.. image:: /_static/img/Quartus_IP_RAMROM4.png

.. image:: /_static/img/Quartus_IP_RAMROM5.png

	   
	   
DDRSDRAM

.. image:: /_static/img/Quartus_IP_DDRSDRAM0.png

.. image:: /_static/img/Quartus_IP_DDRSDRAM1.png

.. image:: /_static/img/Quartus_IP_DDRSDRAM2.png

.. image:: /_static/img/Quartus_IP_DDRSDRAM3.png

.. image:: /_static/img/Quartus_IP_DDRSDRAM4.png
	   
.. image:: /_static/img/Quartus_IP_DDRSDRAM5.png
	   
.. image:: /_static/img/Quartus_IP_DDRSDRAM6.png

	   
IP 核生成后会有一个测试用的顶层文件,该文件可以用来测试硬件是否有问题

.. image:: /_static/img/Quartus_IP_DDRSDRAM7.png



============================================================
ModelSim
============================================================

.. image:: /_static/img/ModelSim_use0.png

.. image:: /_static/img/ModelSim_use1.png

.. image:: /_static/img/ModelSim_use2.png

.. image:: /_static/img/ModelSim_use3.png



============================================================
SignalTapII
============================================================

.. image:: /_static/img/SignalTapII_use0.png


============================================================
综合属性
============================================================

在一些应用中，有些特定的信号我们需要保留，用于进行采集检测，而综合器会自动优化把它综合掉，因此需要告诉综合器，不让它优化掉需要保留的信号。

**需要保留的信号是引线**

verilog HDL 定义的时候在后面增加

.. code:: verilog

   /* synthesis keep */

   // 例如
   wire keep_wire /* synthesis keep */;

VHDL 需要麻烦些，多写几行定义约束

.. code:: vhdl   

   signal keep_wire : std_logic;
   attribute keep : boolean;
   attribute keep of keep_wire : signal is true;

**需要保留的是寄存器**

verilog HDL 定义的时候在后面增加

.. code:: verilog

   /* synthesis noprune */  避免优化掉没output的reg
   /* synthesis preserve */ 避免將reg优化为常数，或者合并重复的reg。

   // 例如
   reg reg1 /* synthesis preserve */;

VHDL 同样需要麻烦些，多写几行定义约束
   
.. code:: vhdl  

   signal reg1 : std_logic;
   attribute preserve : boolean;
   attribute preserve of reg1 : signal is true;





   
	  
	   
.. 
.. Altera.rst ends here
