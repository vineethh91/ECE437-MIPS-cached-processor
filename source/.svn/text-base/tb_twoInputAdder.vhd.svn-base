-- $Id: $
-- File name:   tb_twoInputAdder.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_twoInputAdder is
end tb_twoInputAdder;

architecture TEST of tb_twoInputAdder is

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

  component twoInputAdder
    PORT(
         val1 : IN STD_LOGIC_VECTOR (31 downto 0);
         val2 : IN STD_LOGIC_VECTOR (31 downto 0);
         addRes : OUT STD_LOGIC_VECTOR (31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal val1 : STD_LOGIC_VECTOR (31 downto 0);
  signal val2 : STD_LOGIC_VECTOR (31 downto 0);
  signal addRes : STD_LOGIC_VECTOR (31 downto 0);

-- signal <name> : <type>;

begin
  DUT: twoInputAdder port map(
                val1 => val1,
                val2 => val2,
                addRes => addRes
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    val1 <= x"0000ffff";
    val2 <= x"00000001";
    wait for 10 ns;

    val1 <= x"0000f0f0";
    val2 <= x"00000f0f";
    wait for 10 ns;
    
  end process;
end TEST;