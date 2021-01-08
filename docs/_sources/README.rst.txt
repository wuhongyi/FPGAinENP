.. README.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 五 7月 26 20:21:45 2019 (+0800)
.. Last-Updated: 五 1月  8 22:28:32 2021 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 11
.. URL: http://wuhongyi.cn 

##################################################
README
##################################################


国际上最大的两个 FPGA 厂家为 Xilinx 和 Altrea（已被Intel收购），Xilinx 公司的软件有 ISE(已停止更新，适用于早年推出的FPGA) 和 Vivado（适用于新推出的FPGA），Altera公司的软件为 Quartus。我们已有的 LUPO/DT5495/MZTIO 可编程逻辑刚好对应三个软件。对于数字信号处理模块，已有的 DT5550/R5560SE 已经在测试中。

编程语言 VHDL/verilog 两种, 本质上没有多大的区别。 我已经写好两种语言的关键模块的模版， 直接套用就可以。 整个编程的核心就是熟练掌握计数器/状态机以及FIFO的使用。


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
	- R5560SE
- 计数器
- 状态机
- FIFO
- 项目实践
        - 计数器
                - 时钟降频（很简单）
                - LED灯（很简单）
                - scaler（很简单）
                - 信号展宽（很简单）
                - UART(有个不错的verilog模版，需要进一步优化，提高普适性)
                - IIC
                - 显示器实现示波器功能
        - 状态机
                - SPI(CAEN DT5495 有个VHDL模版，需要按照我们的规范重新优化)
                - 基于FPGA的在线监视（将获取的数据直接发送到可编程板卡进行处理，可进行初步的处理后，再通过网络发送到下游的服务器存储）
        - FIFO
                - 信号延迟（简单）
        - 脉冲发生器
               - 基本波形的脉冲产生(简单)
               - 任意波形的脉冲产生
        - ......
	- 数字信号触发算法
	       - XIA fast filter
	       - RC-CR2
	       - 前沿甄别
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

  
   
.. 
.. README.rst ends here
