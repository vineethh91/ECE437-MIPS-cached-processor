-- $Id: $
-- File name:   tb_mux5Bit.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_mux5Bit is
end tb_mux5Bit;

architecture TEST of tb_mux5Bit is

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

  component mux5Bit
    PORT(
         val0 : IN STD_LOGIC_VECTOR (4 downto 0);
         val1 : IN STD_LOGIC_VECTOR (4 downto 0);
         muxEnable : IN STD_LOGIC;
         muxOutput : OUT STD_LOGIC_VECTOR (4 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal val0 : STD_LOGIC_VECTOR (4 downto 0);
  signal val1 : STD_LOGIC_VECTOR (4 downto 0);
  signal muxEnable : STD_LOGIC;
  signal muxOutput : STD_LOGIC_VECTOR (4 downto 0);

-- signal <name> : <type>;

begin
  DUT: mux5Bit port map(
                val0 => val0,
                val1 => val1,
                muxEnable => muxEnable,
                muxOutput => muxOutput
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    val0 <= "10101";
    val1 <= "01010";
    muxEnable <= '0';
    wait for 10 ns;
    
    val0 <= "10101";
    val1 <= "01010";
    muxEnable <= '1';
    wait for 10 ns;

  end process;
end TEST;