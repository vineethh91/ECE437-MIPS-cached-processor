-- $Id: $
-- File name:   tb_ander.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_ander is
end tb_ander;

architecture TEST of tb_ander is

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

  component ander
    PORT(
         input1 : IN STD_LOGIC;
         input2 : IN STD_LOGIC;
         andOutput : OUT STD_LOGIC
    );
  end component;

-- Insert signals Declarations here
  signal input1 : STD_LOGIC;
  signal input2 : STD_LOGIC;
  signal andOutput : STD_LOGIC;

-- signal <name> : <type>;

begin
  DUT: ander port map(
                input1 => input1,
                input2 => input2,
                andOutput => andOutput
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

                            -- run for 50ns
    input1 <= '1';
    input2 <= '1';
    wait for 10 ns;

    input1 <= '1';
    input2 <= '0';
    wait for 10 ns;
    
    input1 <= '0';
    input2 <= '1';
    wait for 10 ns;
    
    input1 <= '0';
    input2 <= '0';
    wait for 10 ns;
    
  end process;
end TEST;