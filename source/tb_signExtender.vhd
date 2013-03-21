-- $Id: $
-- File name:   tb_signExtender.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_signExtender is
end tb_signExtender;

architecture TEST of tb_signExtender is

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

  component signExtender
    PORT(
         imm16 : IN STD_LOGIC_VECTOR (15 downto 0);
         extOp : IN STD_LOGIC
    );
  end component;

-- Insert signals Declarations here
  signal imm16 : STD_LOGIC_VECTOR (15 downto 0);
  signal extOp : STD_LOGIC;

-- signal <name> : <type>;

begin
  DUT: signExtender port map(
                imm16 => imm16,
                extOp => extOp
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    imm16 <= x"ffff";
    extOp <= '0';
    wait for 10 ns;

    imm16 <= x"ffff";
    extOp <= '1';
    wait for 10 ns;

    imm16 <= x"1fff";
    extOp <= '1';
    wait for 10 ns;
    
    
  end process;
end TEST;