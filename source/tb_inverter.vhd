-- $Id: $
-- File name:   tb_inverter.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_inverter is
end tb_inverter;

architecture TEST of tb_inverter is

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

  component inverter
    PORT(
         input : IN STD_LOGIC;
         invertedOutput : OUT STD_LOGIC
    );
  end component;

-- Insert signals Declarations here
  signal input : STD_LOGIC;
  signal invertedOutput : STD_LOGIC;

-- signal <name> : <type>;

begin
  DUT: inverter port map(
                input => input,
                invertedOutput => invertedOutput
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    input <= '1';
    wait for 10 ns;
    
    input <= '0';
    wait for 10 ns;

  end process;
end TEST;