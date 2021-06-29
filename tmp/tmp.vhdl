--tmp.vhdl --- 
--
--Description: 
--Author: Hongyi Wu(吴鸿毅)
--Email: wuhongyi@qq.com 
--Created: 二 6月 29 16:35:03 2021 (+0800)
--Last-Updated: 二 6月 29 16:37:47 2021 (+0800)
--          By: Hongyi Wu(吴鸿毅)
--    Update #: 1
--URL: http://wuhongyi.cn 

xpm_cdc_single_inst : xpm_cdc_single
  generic map
  (
    DEST_SYNC_FF => 2,
    INIT_SYNC_FF => 0,
    SIM_ASSERT_CHK => 0,
    SRC_INPUT_REG => 1
    )
  port map
  (
    src_clk => src_clk,
    src_in => src_in,
    dest_clk => dest_clk,
    dest_clk => dest_out
    );





--
--tmp.vhdl ends here
