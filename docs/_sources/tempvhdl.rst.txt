.. tempvhdl.rst --- 
.. 
.. Description: 
.. Author: Hongyi Wu(吴鸿毅)
.. Email: wuhongyi@qq.com 
.. Created: 一 5月 25 12:11:49 2020 (+0800)
.. Last-Updated: 一 5月 25 12:27:38 2020 (+0800)
..           By: Hongyi Wu(吴鸿毅)
..     Update #: 1
.. URL: http://wuhongyi.cn 

##################################################
VHDL temp
##################################################


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


   
.. 
.. tempvhdl.rst ends here
