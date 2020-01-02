.. Install.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 六 8月 10 21:23:32 2019 (+0800)
.. Last-Updated: 四 1月  2 20:16:42 2020 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 5
.. URL: http://wuhongyi.cn 

##################################################
软件安装
##################################################

============================================================
ISE 安装
============================================================

.. code-block:: bash
		
  tar -xvf Xilinx_ISE_DS_Lin_14.7_1015_1.tar 
  cd Xilinx_ISE_DS_Lin_14.7_1015_1
  ./xsetup



.. image:: /_static/img/ISE_install0.png
	   
.. image:: /_static/img/ISE_install1.png
	   
.. image:: /_static/img/ISE_install2.png
	   
.. image:: /_static/img/ISE_install3.png
	   
.. image:: /_static/img/ISE_install4.png
	   
.. image:: /_static/img/ISE_install5.png
	   
.. image:: /_static/img/ISE_install6.png
	   
.. image:: /_static/img/ISE_install7.png

  
  

============================================================
Altera 安装
============================================================

下载需要的所有文件，放在一个目录下

.. code-block:: text
		
  arria10-19.2.0.57.qdz                 ModelSimProSetup-19.2.0.57-linux.run
  cyclone10gx-19.2.0.57.qdz             QuartusProSetup-19.2.0.57-linux.run
  modelsim-part2-19.2.0.57-linux.qdz    stratix10-19.2.0.57.qdz


.. code-block:: bash

  chmod +x QuartusProSetup-19.2.0.57-linux.run
  ./QuartusProSetup-19.2.0.57-linux.run


.. image:: /_static/img/Quartus_install0.png
	   
.. image:: /_static/img/Quartus_install1.png
	   
.. image:: /_static/img/Quartus_install2.png
	   
.. image:: /_static/img/Quartus_install3.png
	   
.. image:: /_static/img/Quartus_install4.png
	   
.. image:: /_static/img/Quartus_install5.png
	   
.. image:: /_static/img/Quartus_install6.png


在安装路径下有以下文件

.. code-block:: bash

  devdata  licenses  modelsim_ase  qsys     syscon
  ip           logs        nios2eds         quartus  uninstall

quartus/bin 文件夹内存放quartus启动的脚本

.. code-block:: bash
		
  ./quartus

modelsim_ase/bin 文件夹内存放modelsim启动的脚本

.. code-block:: bash
		
  ./vsim 
  

----------------------------------------------------------------------
linux usb blaster权限的设置
----------------------------------------------------------------------

对于错误 error (209053): unexpected error in jtag server -- error code 89，它产生的原因在于，在linux系统下，Quartus ii 的驱动 USB-Blaster 只能有 root 用户使用，而普通用户是无权使用的。解决思路是更改 USB-Blaster 的使用权限，使得普通用户也能使用。

因为usb 默认只有root才有权限访问，所以只要把权限修改一下即可，usb blaster 链接上电脑

.. code-block:: bash

  [root@localhost 003]# lsusb
  Bus 002 Device 002: ID 8087:8000 Intel Corp. 
  Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
  Bus 001 Device 002: ID 8087:8008 Intel Corp. 
  Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
  Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
  Bus 003 Device 004: ID 0bda:0184 Realtek Semiconductor Corp. RTS5182 Card Reader
  Bus 003 Device 013: ID 09fb:6001 Altera Blaster
  Bus 003 Device 003: ID 046d:c077 Logitech, Inc. M105 Optical Mouse
  Bus 003 Device 002: ID 413c:2107 Dell Computer Corp. 
  Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

说明 /dev/bus/usb/003/013 这个文件现在就是我们的 Altera Blaster 设备

.. code-block:: bash
		
  cd /dev/bus/usb/003
  chmod 666 013


  
============================================================
Vivado 安装
============================================================

.. code-block:: bash

  tar   -zxvf   Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz
  cd    Xilinx_Vivado_SDK_2018.3_1207_2324
  ./xsetup


.. image:: /_static/img/Vivado_install0.png

点击 continue选择不下载最新版本，然后点击Next进入下一步  

.. image:: /_static/img/Vivado_install1.png

点击三个可选框，然后点击Next进入下一步  

.. image:: /_static/img/Vivado_install2.png

选择 Vinado HL Design Edition，然后点击Next进入下一步  

.. image:: /_static/img/Vivado_install3.png

直接点击Next进入下一步  

.. image:: /_static/img/Vivado_install4.png

选择安装目录，这里我选择安装到 /home/wuhongyi/Xilinx ，然后点击Next进入下一步  

.. image:: /_static/img/Vivado_install5.png

等待安装完成

.. image:: /_static/img/Vivado_install6.png

将 vivadoLicence.lic 文件复制到 安装目录，这里为  /home/wuhongyi/Xilinx 

安装完成之后会弹出以下界面

.. image:: /_static/img/Vivado_install7.png

点击左上方的 Load License，选择我们的 vivadoLicence.lic 文件

然后点击左上方的 View License Status 可查看破解的IP核

.. image:: /_static/img/Vivado_install8.png

  
		
   
.. 
.. Install.rst ends here
