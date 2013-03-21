-- $Id: $
-- File name:   tb_pcUpdate.vhd
-- Created:     1/26/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_pcUpdate is
end tb_pcUpdate;

architecture TEST of tb_pcUpdate is

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

  component pcUpdate
    PORT(
         programCounter : IN STD_LOGIC_VECTOR (31 downto 0);
         jlabel : IN STD_LOGIC_VECTOR (25 downto 0);
         updatedPC : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal programCounter : STD_LOGIC_VECTOR (31 downto 0);
  signal jlabel : STD_LOGIC_VECTOR (25 downto 0);
  signal updatedPC : STD_LOGIC_VECTOR(31 downto 0);

-- signal <name> : <type>;

begin
  DUT: pcUpdate port map(
                programCounter => programCounter,
                jlabel => jlabel,
                updatedPC => updatedPC
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    programCounter <= x"dfffffff";
    jlabel <= "10101010101010101010101010";
    wait for 10 ns;
    

  end process;
end TEST;