.. README.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 五 7月 26 20:21:45 2019 (+0800)
.. Last-Updated: 六 8月 10 21:33:56 2019 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 3
.. URL: http://wuhongyi.cn 

##################################################
README
##################################################


国际上最大的两个 FPGA 厂家为 Xilinx 和 Altrea（已被Intel收购），Xilinx 公司的软件有 ISE(已停止更新，适用于早年推出的FPGA) 和 Vivado（适用于新推出的FPGA），Altera公司的软件为 Quartus。我们已有的 LUPO/DT5495/MZTIO 刚好对应三个软件.

编程语言 VHDL/verilog 两种, 本质上没有多大的区别。 我已经写好两种语言的关键模块的模版， 直接套用就可以。 整个编程的核心就是熟练掌握计数器\状态机以及FIFO的使用。


- ISE/Altera/Vivado 软件
        - 软件安装
	        - ISE
                - Vivado
                - Quartus
        - 刷固件
        - 工程使用案例
        - 仿真
        - 常用IP核介绍
- LUPO/DT5495/MZTIO 模块介绍
        - LUPO
        - DT5495
        - MZTIO
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
                - 基于PCIE的在线监视（将获取的数据直接发送到可编程PCIE板卡进行处理，可进行初步的处理后，再通过网络发送到下游的服务器存储。。。这个难度有点大）
        - FIFO
                - 信号延迟（简单）
        - 脉冲发生器
               - 基本波形的脉冲产生(简单)
               - 任意波形的脉冲产生(需要借助外部输入进行控制,因此需要利用 UART/SPI/IIC 等通讯技术)
        - ......



   
.. 
.. README.rst ends here
