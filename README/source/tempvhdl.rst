.. tempvhdl.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 一 5月 25 12:11:49 2020 (+0800)
.. Last-Updated: 五 1月  1 13:58:35 2021 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 3
.. URL: http://wuhongyi.cn 

##################################################
VHDL temp
##################################################


============================================================
循环
============================================================

.. code:: vhdl
	  
  for i in 0 to N_HISTOGRAM_REGS-1 loop
    tmp_histogram(i) <= std_logic_vector(to_unsigned(0,N_HISTOGRAM_BIT));
  end loop;

  
.. code:: vhdl

  dettrigA: for i in 0 to 31 generate
    process(clk100)
    begin
      if(clk100'event and clk100 = '1')then
	if(A0(i)='1' and A1(i)='0')then
	  triggerA(i) <= '1';
	else
	  triggerA(i) <= '0';
	end if;
      end if;
    end process;
  end generate;




  
============================================================
信号处理
============================================================




----------------------------------------------------------------------
HLS 生成模块
----------------------------------------------------------------------



.. code:: vhdl

  entity BaselineRestorer is
    port (
      CLK : IN STD_LOGIC;
      TRIGGER: IN STD_LOGIC;--原始波形触发信号
      DATA_IN: IN STD_LOGIC_VECTOR(15 DOWNTO 0);--输入原始波形
      M_LENGTH: IN INTEGER;--2^n 参与基线计算的时间窗长度 
      BL_HOLD: IN INTEGER;--触发之后禁止基线计算的点的个数
      FLUSH: IN STD_LOGIC;
      BASELINE: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);--输出基线
      BASELINE_VALID: OUT STD_LOGIC;--基线有效标记
      HOLD_TIME: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--不计算基线的时间
      RUNNING_NOT_HOLD: OUT STD_LOGIC--正在计算基线的标记
      );
  end;


.. code:: vhdl
  
  entity moving_average is
  port (
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      adc_data_V : IN STD_LOGIC_VECTOR (15 downto 0);
      adc_data_V_ap_vld : IN STD_LOGIC;
      hold : IN STD_LOGIC;
      length_V : IN STD_LOGIC_VECTOR (15 downto 0);
      dataout_V : OUT STD_LOGIC_VECTOR (15 downto 0);
      dataout_V_ap_vld : OUT STD_LOGIC );
  end;


.. code:: vhdl

  entity charge_integration is
  port (
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      in1_V : IN STD_LOGIC_VECTOR (15 downto 0);--输入波形
      in1_V_ap_vld : IN STD_LOGIC;-- '1' 
      base_line_V : IN STD_LOGIC_VECTOR (15 downto 0);--输入基线
      trigger_signal : IN STD_LOGIC;--输入触发
      p_int_length_V : IN STD_LOGIC_VECTOR (15 downto 0);--积分门宽
      p_pre_length_V : IN STD_LOGIC_VECTOR (15 downto 0);--积分起始点，触发前 
      p_gain_V : IN STD_LOGIC_VECTOR (15 downto 0);--增益
      p_offset_V : IN STD_LOGIC_VECTOR (15 downto 0);--偏置
      p_pileup_inib_V : IN STD_LOGIC_VECTOR (15 downto 0);--堆积拒绝的事件间隔
      enable : IN STD_LOGIC;-- '1' 
      energy_out_V : OUT STD_LOGIC_VECTOR (15 downto 0);--输出积分结果
      energy_trigger : OUT STD_LOGIC;-- 标记输出积分有效 
      energy_trigger_ap_vld : OUT STD_LOGIC;-- open 
      p_integrate : OUT STD_LOGIC;-- 积分门
      p_pileup : OUT STD_LOGIC;-- 堆积标记
      p_busy : OUT STD_LOGIC ); 
  end;


.. code:: vhdl

  entity trapezio is
    port (
      ap_clk : in STD_LOGIC;
      ap_rst : in STD_LOGIC;
      adc_data_V : in STD_LOGIC_VECTOR ( 15 downto 0 );
      adc_data_V_ap_vld : in STD_LOGIC;
      baseline_V : in STD_LOGIC_VECTOR ( 15 downto 0 );
      k_V : in STD_LOGIC_VECTOR ( 15 downto 0 );
      m_V : in STD_LOGIC_VECTOR ( 15 downto 0 );
      M_V_r : in STD_LOGIC_VECTOR ( 31 downto 0 );
      G_V : in STD_LOGIC_VECTOR ( 31 downto 0 );
      dataout_V : out STD_LOGIC_VECTOR ( 15 downto 0 );
      dataout_V_ap_vld : out STD_LOGIC
    );
    attribute NotValidForBitStream : boolean;
    attribute NotValidForBitStream of trapezio : entity is true;
  end trapezio;


.. code:: vhdl

  entity MCAHP_512 is
  port (
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      adc_data_V : IN STD_LOGIC_VECTOR (15 downto 0);
      positive_r : IN STD_LOGIC;
      digital_offset_V : IN STD_LOGIC_VECTOR (15 downto 0);
      threshold_V : IN STD_LOGIC_VECTOR (31 downto 0);
      trig_k_V : IN STD_LOGIC_VECTOR (15 downto 0);--快速滤波梯形上升时间
      trig_m_V : IN STD_LOGIC_VECTOR (15 downto 0);--快速滤波梯形上升+平台时间
      e_k_V : IN STD_LOGIC_VECTOR (15 downto 0);--梯形上升时间
      e_m_V : IN STD_LOGIC_VECTOR (15 downto 0);--梯形上升+平台时间
      e_MDec_V : IN STD_LOGIC_VECTOR (23 downto 0);-- int(256/(exp(clock_sampling_time/tau)-1))
      e_G_V : IN STD_LOGIC_VECTOR (23 downto 0);--int(gain*0x10000)  gain为浮点数
      e_MDec2_V : IN STD_LOGIC_VECTOR (15 downto 0);
      e_G2_V : IN STD_LOGIC_VECTOR (15 downto 0);
      e_sample_delay_V : IN STD_LOGIC_VECTOR (15 downto 0);
      baseline_len_V : IN STD_LOGIC_VECTOR (3 downto 0);--2^n	 5->32	6->64  7->128 8->256  9->512  10->1024	11->2048
      baseline_inib_V : IN STD_LOGIC_VECTOR (15 downto 0);--触发之后抑制基线计算的时间，需要大于两倍能量梯形的上升和平台之和
      run_cfg : IN STD_LOGIC;-- '1'
      deconv2_sig_V : OUT STD_LOGIC_VECTOR (31 downto 0);--open
      deconv2_sig_V_ap_vld : OUT STD_LOGIC;--open
      trigger_delta_monitor_V : OUT STD_LOGIC_VECTOR (31 downto 0);--open
      trigger_delta_monitor_V_ap_vld : OUT STD_LOGIC;--open
      trigger_trap_monitor_V : OUT STD_LOGIC_VECTOR (31 downto 0);--触发滤波
      trigger_trap_monitor_V_ap_vld : OUT STD_LOGIC;
      trap_V : OUT STD_LOGIC_VECTOR (31 downto 0);--梯形滤波
      trap_V_ap_vld : OUT STD_LOGIC;
      trap_minus_baseline_V : OUT STD_LOGIC_VECTOR (31 downto 0);--梯形滤波减基线滤波
      trap_minus_baseline_V_ap_vld : OUT STD_LOGIC;
      baseline_out_V : OUT STD_LOGIC_VECTOR (31 downto 0);--基线滤波
      baseline_out_V_ap_vld : OUT STD_LOGIC;
      energy_V : OUT STD_LOGIC_VECTOR (31 downto 0);--能量滤波
      energy_V_ap_vld : OUT STD_LOGIC;
      energy_strobe : OUT STD_LOGIC;--能量采集标记
      trigger_sig : OUT STD_LOGIC;--触发信号
      baseline_hold : OUT STD_LOGIC;
      GIN_SELECT_V : IN STD_LOGIC_VECTOR (3 downto 0);
      gin : IN STD_LOGIC );
  end;



.. code:: vhdl

  entity gated_integrator is
  port (
      ap_clk : IN STD_LOGIC;--时钟
      ap_rst : IN STD_LOGIC;--重置，高电平有效
      data_in_V : IN STD_LOGIC_VECTOR (31 downto 0);--输入数据
      data_in_V_ap_vld : IN STD_LOGIC;--输入数据有效标记
      gate_len_V : IN STD_LOGIC_VECTOR (15 downto 0);--积分门宽，最大到1024
      gain_V : IN STD_LOGIC_VECTOR (31 downto 0);--增益，65536表示增益为1。算法为 gain/65536
      clear : IN STD_LOGIC;--从高电平到低电平时，重新初始化。初始化时间与积分门宽成正比。这期间 data_out_V_ap_vld/ready为低电平
      data_out_V : OUT STD_LOGIC_VECTOR (31 downto 0);--数据输出，当前时钟之前的积分门结果输出延迟4个时钟
      data_out_V_ap_vld : OUT STD_LOGIC;--输出数据有效标记
      ready : OUT STD_LOGIC --高电平表示输出有效，低电平表示在初始化
      );		
  end;

 
.. code:: vhdl

  -- 数值导数/微分
  -- OUT[n] = DATA_IN[n]  - DATA_IN[n-WINDOW])
  entity differenziator is
  port (
      ap_clk : IN STD_LOGIC;--时钟
      ap_rst : IN STD_LOGIC;--重置，高电平有效
      data_in_V : IN STD_LOGIC_VECTOR (31 downto 0);--输入数据
      data_in_V_ap_vld : IN STD_LOGIC;--输入数据有效标记
      diff_len_V : IN STD_LOGIC_VECTOR (15 downto 0);--前后做差两个点的间隔，最大为999
      clear : IN STD_LOGIC;----从高电平到低电平时，重新初始化。初始化时间最小为WINDOW。这期间 data_out_V_ap_vld/ready为低电平
      data_out_V : OUT STD_LOGIC_VECTOR (31 downto 0);--当前时钟输入数据与之前数据的差输出延迟两个时钟
      data_out_V_ap_vld : OUT STD_LOGIC;--数据输出，当前时钟输入数据的输出延迟2个时钟
      ready : OUT STD_LOGIC;--输出数据有效标记
      ready_ap_vld : OUT STD_LOGIC --输出常为1, open
      );		
  end;
	

.. code:: vhdl
  
  entity PSD_INTDUAL is
  port (
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      data_in_V : IN STD_LOGIC_VECTOR (15 downto 0);
      data_in_V_ap_vld : IN STD_LOGIC;
      trigger : IN STD_LOGIC;
      int_short_V : IN STD_LOGIC_VECTOR (15 downto 0);
      int_long_V : IN STD_LOGIC_VECTOR (15 downto 0);
      pileup_inib_V : IN STD_LOGIC_VECTOR (15 downto 0);
      psd_out_V : OUT STD_LOGIC_VECTOR (31 downto 0);
      psd_out_V_ap_vld : OUT STD_LOGIC;
      q_long_out_V : OUT STD_LOGIC_VECTOR (31 downto 0);
      q_long_out_V_ap_vld : OUT STD_LOGIC;
      q_short_out_V : OUT STD_LOGIC_VECTOR (31 downto 0);
      q_short_out_V_ap_vld : OUT STD_LOGIC );
  end;


  


----------------------------------------------------------------------
手写模块
----------------------------------------------------------------------

.. code:: vhdl

  -- 1,2,4,8 个点平均
  entity NoiseFilter is
    Generic (data_bit : integer := 16);
    port (
      CLK : IN STD_LOGIC;
      MODE : IN STD_LOGIC_VECTOR (1 downto 0);-- "00"=>1  "01"=>2  "10"=>4  "11"=>8 
      DATA_IN : IN STD_LOGIC_VECTOR (data_bit-1 DOWNTO 0);
      DATA_OUT : OUT STD_LOGIC_VECTOR (data_bit-1 DOWNTO 0)
      );
  end;


.. code:: vhdl

  entity TriggerDerivative is
    Generic (
      data_bit : integer := 16;--输入波形位数
      noise_filter : integer := 2;--计算两个间隔为n的点的差值为滤波结果
      data_delay : integer := 3--输入波形的延迟输出
      );
    port (
      CLK : IN STD_LOGIC;
      POLARITY: IN STD_LOGIC;-- 1=>pos 0=>neg
      DATA_IN: IN STD_LOGIC_VECTOR(data_bit-1 DOWNTO 0);
      THRESHOLD: IN STD_LOGIC_VECTOR(data_bit-1 DOWNTO 0);
      DELAYED_DATA: OUT STD_LOGIC_VECTOR(data_bit-1 DOWNTO 0);
      TRIGGER: OUT STD_LOGIC
      );
  end;


.. code:: vhdl

  entity TriggerLeading is
    Generic (
      data_bit : integer := 16;--输入波形位数
      data_delay : integer := 3--输入波形的延迟输出
      );
    port (
      CLK : IN STD_LOGIC;
      POLARITY: IN STD_LOGIC;--1=>pos 0=>neg
      DATA_IN: IN STD_LOGIC_VECTOR(data_bit-1 DOWNTO 0);
      THRESHOLD: IN STD_LOGIC_VECTOR(data_bit-1 DOWNTO 0);
      DELAYED_DATA: OUT STD_LOGIC_VECTOR(data_bit-1 DOWNTO 0);
      TRIGGER: OUT STD_LOGIC
      );
  end;



  
   
.. 
.. tempvhdl.rst ends here
