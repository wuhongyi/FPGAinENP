.. LPM.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 四 1月  7 22:06:16 2021 (+0800)
.. Last-Updated: 一 4月 15 21:33:00 2024 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 5
.. URL: http://wuhongyi.cn 

##################################################
LPM（library of parameterized mudules）
##################################################

- https://blog.csdn.net/next_fse/article/details/73864596
- http://blog.sina.com.cn/s/blog_6e350d8801011hfx.html

xilinx 文件位置，安装目录下 ids_lite/ISE/data/xportlib
Altera 文件位置，安装目录下 libraries/megafunctions

文件位置，安装目录下 quartus/eda/fv_lib/verilog quartus/eda/fv_lib/vhdl
参考 quartus/qdesigns

ALTERA在LPM（library of parameterized mudules）库中提供了参数可配置的单时钟FIFO（SCFIFO）和双时钟FIFO（DCFIFO）。FIFO主要应用在需要数据缓冲且数据符合先进先出规律的同步或异步场合。LPM中的FIFO包含以下几种：

- SCFIFO：单时钟FIFO；
- DCFIFO：双时钟FIFO，数据输入和输出的宽度相同；
- DCFIFO_MIXED_WIDTHS：双时钟FIFO，输入输出数据位宽可以不同。

https://www.cnblogs.com/rouwawa/p/7066635.html
  

.. code:: vhdl

  -- 以下模块需要研究明白参数 
  in_delay : altshift_taps
    generic map (
      intended_device_family => "unused",
      number_of_taps => 64,
      power_up_state => "CLEARED",
      tap_distance => 63,
      width => bitsize,
      lpm_hint => "UNUSED",
      lpm_type => "altshift_taps"
      )
    port map(
      aclr => RESET(0),
      clken => '1',
      clock => CLK_WRITE(0),
      shiftin => DATAIN,
      shiftout =>DATA_DELAY,
      taps => open
      );
  
  dcfifo_mixed_widths_component : dcfifo_mixed_widths
    GENERIC MAP (
      intended_device_family => "Cyclone V",
      lpm_numwords => fifolength,
      lpm_showahead => "ON",
      lpm_type => "dcfifo_mixed_widths",
      lpm_width => bitsize,
      lpm_widthu => wBits,
      lpm_widthu_r => rBits,
      lpm_width_r => 32,
      overflow_checking => "ON",
      rdsync_delaypipe => 4,
      read_aclr_synch => "OFF",
      underflow_checking => "ON",
      use_eab => "ON",
      write_aclr_synch => "OFF",
      wrsync_delaypipe => 4
      )
    PORT MAP (
      aclr => FifoClear,
      data => DATA_DELAY,
      rdclk => CLK_READ(0),
      rdreq => iREAD_NEXT,
      wrclk => CLK_WRITE(0),
      wrreq => EnableWrite,
      q => READ_DATA,
      rdempty => iEMPTY,
      wrfull => iFULL
      );


.. code:: vhdl

   GEN_INPUT_FIFO: 
   for I in 0 to InputCount-1 generate
	xpm_fifo_async_inst : xpm_fifo_async
	generic map (
		FIFO_MEMORY_TYPE => "auto", --string; "auto", "block", or "distributed";
		ECC_MODE => "no_ecc", --string; "no_ecc" or "en_ecc";
		RELATED_CLOCKS => 0, --positive integer; 0 or 1
		FIFO_WRITE_DEPTH => InputFifoSize, --positive integer
		WRITE_DATA_WIDTH => InputWordSize, --positive integer
		WR_DATA_COUNT_WIDTH => wBits, --positive integer
		PROG_FULL_THRESH => InputFifoSize-5, --positive integer
		FULL_RESET_VALUE => 0, --positive integer; 0 or 1;
		READ_MODE => "fwft", --string; "std" or "fwft";
		FIFO_READ_LATENCY => 1, --positive integer;
		READ_DATA_WIDTH => InputWordSize, --positive integer
		RD_DATA_COUNT_WIDTH => rBits, --positive integer
		PROG_EMPTY_THRESH => 5, --positive integer
		DOUT_RESET_VALUE => "0", --string
		CDC_SYNC_STAGES => 2, --positive integer
		WAKEUP_TIME => 0 --positive integer; 0 or 2;
	)
	port map (
		sleep => '0',
		rst => reset,
		wr_clk => clk,
		wr_en => DV_IN(I),
		din =>	DATA_IN(((I+1)*InputWordSize)-1 downto (I*InputWordSize)),
		full => BUSY_IN(I),
		overflow => open,
		wr_rst_busy => open,
		rd_clk => clk,
		rd_en => RDEN_FIFO(I),
		dout => DATA_IN_FIFO(((I+1)*InputWordSize)-1 downto (I*InputWordSize)),
		empty => EMPTY_FIFO(I),
		underflow => open,
		rd_rst_busy => open,
		prog_full => open,
		wr_data_count => open,
		prog_empty => open,
		rd_data_count => open,
		injectsbiterr => '0',
		injectdbiterr => '0',
		sbiterr => open,
		dbiterr => open
	);		 
   RDEN_FIFO(I) <= (not EMPTY_FIFO(I)) and (not BUSY_IN_FIFO(I));
   DV_IN_FIFO(I) <= RDEN_FIFO(I); 
   end generate GEN_INPUT_FIFO;




.. code:: vhdl

  COMPONENT dcfifo_mixed_widths
  GENERIC (
   	intended_device_family		: STRING;
   	lpm_numwords		: NATURAL;
   	lpm_showahead		: STRING;
   	lpm_type		: STRING;
   	lpm_width		: NATURAL;
   	lpm_widthu		: NATURAL;
   	lpm_widthu_r		: NATURAL;
   	lpm_width_r		: NATURAL;
   	overflow_checking		: STRING;
   	rdsync_delaypipe		: NATURAL;
   	read_aclr_synch		: STRING;
   	underflow_checking		: STRING;
   	use_eab		: STRING;
   	write_aclr_synch		: STRING;
   	wrsync_delaypipe		: NATURAL
  );
  PORT (
   		aclr	: IN STD_LOGIC ;
   		data	: IN STD_LOGIC_VECTOR (bitsize-1 DOWNTO 0);
   		rdclk	: IN STD_LOGIC ;
   		rdreq	: IN STD_LOGIC ;
   		wrclk	: IN STD_LOGIC ;
   		wrreq	: IN STD_LOGIC ;
   		q	: OUT STD_LOGIC_VECTOR (32-1 DOWNTO 0);
   		rdempty	: OUT STD_LOGIC ;
   		wrfull	: OUT STD_LOGIC 
  );
  END COMPONENT;


.. code:: vhdl

   xpm_fifo_async_inst : xpm_fifo_async
   generic map (
   FIFO_MEMORY_TYPE => "auto", --string; "auto", "block", or "distributed";
   ECC_MODE => "no_ecc", --string; "no_ecc" or "en_ecc";
   RELATED_CLOCKS => 0, --positive integer; 0 or 1
   FIFO_WRITE_DEPTH => fifolength, --positive integer
   WRITE_DATA_WIDTH => bitsize, --positive integer
   WR_DATA_COUNT_WIDTH => wBits, --positive integer
   PROG_FULL_THRESH => 5, --positive integer
   FULL_RESET_VALUE => 0, --positive integer; 0 or 1;
   READ_MODE => "std", --string; "std" or "fwft";
   FIFO_READ_LATENCY => 1, --positive integer;
   READ_DATA_WIDTH => 32, --positive integer
   RD_DATA_COUNT_WIDTH => rBits, --positive integer
   PROG_EMPTY_THRESH => 3, --positive integer
   DOUT_RESET_VALUE => "0", --string
   CDC_SYNC_STAGES => 2, --positive integer
   WAKEUP_TIME => 0 --positive integer; 0 or 2;
   )
   port map (
    	sleep => '0',
    	rst => RESET(0),
    	wr_clk => CLK_WRITE(0),
    	wr_en => iWRITE,
    	din =>	DATAIN,
    	full => iFULL,
    	overflow => open,
    	wr_rst_busy => open,
    	rd_clk => CLK_READ(0),
    	rd_en => iREAD_NEXT,
    	dout => READ_DATA,
    	empty => iEMPTY,
    	underflow => open,
    	rd_rst_busy => open,
    	prog_full => open,
    	wr_data_count => open,
    	prog_empty => open,
    	rd_data_count => open,
    	injectsbiterr => '0',
    	injectdbiterr => '0',
    	sbiterr => open,
    	dbiterr => open
   );



.. code:: vhdl

    xpm_memory_sdpram_inst : xpm_memory_sdpram
      generic map (
        -- Common module generics
        MEMORY_SIZE => maxDelay*busWidth, --positive integer
        MEMORY_PRIMITIVE => "auto", --string; "auto", "distributed", "block" or "ultra" ;
        CLOCKING_MODE => "common_clock",--string; "common_clock", "independent_clock"
        MEMORY_INIT_FILE => "none", --string; "none" or "<filename>.mem"
        MEMORY_INIT_PARAM => "", --string;
        USE_MEM_INIT => 1, --integer; 0,1
        WAKEUP_TIME => "disable_sleep",--string; "disable_sleep" or "use_sleep_pin"
        MESSAGE_CONTROL => 0, --integer; 0,1
        -- Port A module generics
        WRITE_DATA_WIDTH_A => busWidth, --positive integer
        BYTE_WRITE_WIDTH_A => busWidth, --integer; 8, 9, or WRITE_DATA_WIDTH_A value
        ADDR_WIDTH_A => maxDelayBits, --positive integer
        -- Port B module generics
        READ_DATA_WIDTH_B => busWidth, --positive integer
        ADDR_WIDTH_B => maxDelayBits, --positive integer
        READ_RESET_VALUE_B => "0", --string
        READ_LATENCY_B => 2, --non-negative integer
        WRITE_MODE_B => "no_change" --string; "write_first", "read_first", "no_change"
        )
      port map (
        -- Common module ports
        sleep => '0',
        -- Port A module ports
        clka => CLK(0),
        ena => '1',
        wea => "1",
        addra => WP,
        dina => iIN,
        injectsbiterra => '0', --do not change
        injectdbiterra => '0', --do not change
        -- Port B module ports
        clkb => CLK(0),
        rstb => RESET(0),
        enb => '1',
        regceb => '1',
        addrb => RP,
        doutb => memOut,
        sbiterrb => open, --do not change
        dbiterrb => open --do not change
        );
  end generate;
   

.. code:: vhdl

  xpm_memory_tdpram_inst : xpm_memory_tdpram
    generic map (
      -- Common module generics
      MEMORY_SIZE => memLength*wordWidth, --positive integer
      MEMORY_PRIMITIVE => "auto", --string; "auto", "distributed", "block" or "ultra" ;
      CLOCKING_MODE => "independent_clock",--string; "common_clock", "independent_clock"
      MEMORY_INIT_FILE => "none", --string; "none" or "<filename>.mem"
      MEMORY_INIT_PARAM => "", --string;
      USE_MEM_INIT => 0, --integer; 0,1
      WAKEUP_TIME => "disable_sleep",--string; "disable_sleep" or "use_sleep_pin"
      MESSAGE_CONTROL         => 0,               --integer;
      ECC_MODE                => "no_ecc",        --string; "no_ecc", "encode_only", "decode_only" or "both_encode_and_decode" 
      AUTO_SLEEP_TIME         => 0,               --Do not Change
      -- USE_EMBEDDED_CONSTRAINT => 0,               --integer: 0,1
      -- MEMORY_OPTIMIZATION     => "true",          --string; "true", "false" 

      -- Port A module generics
      WRITE_DATA_WIDTH_A => wordWidth, --positive integer
      READ_DATA_WIDTH_A => wordWidth, --positive integer
      BYTE_WRITE_WIDTH_A => wordWidth, --integer; 8, 9, or WRITE_DATA_WIDTH_A value
      ADDR_WIDTH_A => addressBits, --positive integer
      READ_RESET_VALUE_A => "0", --string
      READ_LATENCY_A => 1, --non-negative integer
      WRITE_MODE_A => "no_change", --string; "write_first", "read_first", "no_change"
      -- Port B module generics
      WRITE_DATA_WIDTH_B => wordWidth, --positive integer
      READ_DATA_WIDTH_B => wordWidth, --positive integer
      BYTE_WRITE_WIDTH_B => wordWidth, --integer; 8, 9, or WRITE_DATA_WIDTH_B value
      ADDR_WIDTH_B => addressBits, --positive integer
      READ_RESET_VALUE_B => "0", --string
      READ_LATENCY_B => 1, --non-negative integer
      WRITE_MODE_B => "read_first" --string; "write_first", "read_first", "no_change"
      )
    port map (
      -- Common module ports
      sleep => '0',
      -- Port A module ports
      clka => CLK_WRITE(0),
      rsta => RESET(0),
      ena => '1',
      regcea => '1',
      wea => wea,
      addra => addra,
      dina => dina,
      injectsbiterra => '0', --do not change
      injectdbiterra => '0', --do not change
      douta => douta,
      sbiterra => open, --do not change
      dbiterra => open, --do not change
      -- Port B module ports
      clkb => CLK_READ(0),
      rstb => RESET(0),
      enb => '1',
      regceb => '1',
      web => web,
      addrb => READ_ADDRESS(addressBits-1 downto 0),
      dinb => dinb,
      injectsbiterrb => '0', --do not change
      injectdbiterrb => '0', --do not change
      doutb => doutb,
      sbiterrb => open, --do not change
      dbiterrb => open --do not change
      );


 
   
.. 
.. LPM.rst ends here
