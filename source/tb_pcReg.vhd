-- $Id: $
-- File name:   tb_pcReg.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_pcReg is
generic (Period : Time := 10 ns);
end tb_pcReg;

architecture TEST of tb_pcReg is

  function INT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
    variable RES : STD_LOGIC_VECTOR(NumBits-1 downto 0);
    variable tmp : INTEGER;
  begin
    tmp := X;
    for i in 0 to NumBits-1 loop
      if (tmp mod 2)=1 then
        res(i) := '1';
      else
        res(i) := '0';
      end if;
      tmp := tmp/2;
    end loop;
    return res;
  end;

  component pcReg
    PORT(
         clk : in std_logic;
         rst_n : in std_logic;
         pcWriteEnable : in std_logic;
         nextPC : in std_logic_vector(31 downto 0);
         programCounter : out std_logic_vector(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal pcWriteEnable : std_logic;
  signal nextPC : std_logic_vector(31 downto 0);
  signal programCounter : std_logic_vector(31 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: pcReg port map(
                clk => clk,
                rst_n => rst_n,
                pcWriteEnable => pcWriteEnable,
                nextPC => nextPC,
                programCounter => programCounter
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst_n <= '0';
    wait for 3 ns;
    rst_n <= '1';
    wait for 3 ns;

    pcWriteEnable <= '1';
    nextPC <= x"f0f0f0f0";
    wait for 10 ns;
    
    nextPC <= x"ffffffff";
    wait for 10 ns;
    
    nextPC <= x"0f0f0f0f";
    wait for 10 ns;
    
    

  end process;
end TEST;