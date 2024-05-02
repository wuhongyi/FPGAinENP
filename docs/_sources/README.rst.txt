.. README.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 五 7月 26 20:21:45 2019 (+0800)
.. Last-Updated: 四 5月  2 16:20:58 2024 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 16
.. URL: http://wuhongyi.cn 

##################################################
FPGA 在中低能实验核物理中的应用
##################################################

http://wuhongyi.cn/FPGAinENP/

本教程主要面向中低能实验核物理方向

有问题请联系 吴鸿毅（wuhongyi@qq.com / wuhongyi@pku.edu.cn）


----

国际上最大的两个 FPGA 厂家为 Xilinx 和 Altrea（已被Intel收购），Xilinx 公司的软件有 ISE(已停止更新，适用于早年推出的FPGA) 和 Vivado（适用于新推出的FPGA），Altera公司的软件为 Quartus。本教程已有的 LUPO/DT5495/MZTIO 可编程逻辑刚好对应三个软件。对于数字信号处理模块，已有的 CAEN DT5550/R5560/DT5560/V2740/V2745/V2730/DT1260 已经在测试中。

编程语言 VHDL/verilog 两种, 本质上没有多大的区别。 本教程提供两种语言的关键模块的模版， 直接套用就可以。 整个开发的核心就是熟练掌握计数器/状态机以及 FIFO 的使用。


- ISE/Altera/Vivado 软件
        - 软件安装
	        - ISE
                - Vivado
                - Quartus
        - 刷固件
        - 工程使用案例
        - 仿真
        - 常用IP核介绍
- 语法
        - VHDL
	- verilog
- LUPO/DT5495/MZTIO 模块介绍
        - LUPO
        - DT5495
        - MZTIO
	- DT5550
	- R5560
	- DT5560
        - 2740/2745
	- 2730
	- DT1260  
- 计数器
- 状态机
- FIFO
- 项目实践
        - 计数器
                - 时钟降频
                - LED灯
                - scaler
                - 信号展宽
                - UART(有个不错的verilog模版，需要进一步优化，提高普适性)
                - IIC
                - 显示器实现示波器功能
        - 状态机
                - SPI(CAEN DT5495 有个VHDL模版，需要按照规范重新优化)
                - 基于FPGA的在线监视（将获取的数据直接发送到可编程板卡进行处理，可进行初步的处理后，再通过网络发送到下游的服务器存储）
        - FIFO
                - 信号延迟
        - 脉冲发生器
               - 基本波形的脉冲产生
               - 任意波形的脉冲产生
        - ......
	- 数字信号触发算法
	       - XIA fast filter
	       - RC-CR2
	       - LE 
	       - ......
	- 数字能量算法
	       - XIA 梯形算法
	       - GAMMASPHERE 梯形算法
	       - Semi-Gaussian
	       - QDC 算法
	- 数字时间算法
	       - CFD 算法
	       - 高精度时间算法
		 

**参考文献**

- 手把手教你学FPGA设计--基于大道至简的至简设计法
- VHDL 入门-解惑-经典实例-经验总结  
- Verilog 数字系统设计教程
- https://verilogguide.readthedocs.io/en/latest/verilog/vhdl.html
  
   
.. 
.. README.rst ends here
