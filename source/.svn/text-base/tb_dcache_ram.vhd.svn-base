-- $Id: $
-- File name:   tb_dcache_ram.vhd
-- Created:     3/13/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_dcache_ram is
generic (Period : Time := 10 ns);
end tb_dcache_ram;

architecture TEST of tb_dcache_ram is

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

  component dcache_ram
    PORT(
         CLK : in std_logic;
         nReset : in std_logic;
         WrEn : in std_logic;
         Tag : in std_logic_vector (24 downto 0);
         Index : in std_logic_vector (03 downto 0);
         WordOffset : in std_logic;
         InputWord : in std_logic_vector (31 downto 0);
         InputWordOffset : in std_logic;
         OutputWord : out std_logic_vector (31 downto 0);
         Dirty : out std_logic;
         Valid : out std_logic;
         Hit : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal CLK : std_logic;
  signal nReset : std_logic;
  signal WrEn : std_logic;
  signal Tag : std_logic_vector (24 downto 0);
  signal Index : std_logic_vector (03 downto 0);
  signal WordOffset : std_logic;
  signal InputWord : std_logic_vector (31 downto 0);
  signal InputWordOffset : std_logic;
  signal OutputWord : std_logic_vector (31 downto 0);
  signal Dirty : std_logic;
  signal Valid : std_logic;
  signal Hit : std_logic;

-- signal <name> : <type>;

begin

CLKGEN: process
  variable CLK_tmp: std_logic := '0';
begin
  CLK_tmp := not CLK_tmp;
  CLK <= CLK_tmp;
  wait for Period/2;
end process;

  DUT: dcache_ram port map(
                CLK => CLK,
                nReset => nReset,
                WrEn => WrEn,
                Tag => Tag,
                Index => Index,
                WordOffset => WordOffset,
                InputWord => InputWord,
                InputWordOffset => InputWordOffset,
                OutputWord => OutputWord,
                Dirty => Dirty,
                Valid => Valid,
                Hit => Hit
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    nReset <= '0';

    WrEn <= '0';

    Tag <= (others => '0');

    Index <= (others => '0');

    WordOffset <= '0';

    InputWord <= x"00000000";

    InputWordOffset <= '0';

    wait for 3.5 ns;
    
    nReset <= '1';

    wait for 15 ns;
    
    WrEn <= '1';

    Tag <= "0000000000000000000000000";

    Index <= "0001";

    WordOffset <= '0';

    InputWord <= x"12345678";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '1';

    Tag <= "0000000000000000000000000";

    Index <= "0010";

    WordOffset <= '1';

    InputWord <= x"87654321";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
   
   
    
    WrEn <= '1';

    Tag <= "0000000000000000000000001";

    Index <= "0011";

    WordOffset <= '0';

    InputWord <= x"11111111";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '1';

    Tag <= "0000000000000000000000001";

    Index <= "0100";

    WordOffset <= '1';

    InputWord <= x"11111110";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
   
    WrEn <= '1';

    Tag <= "0000001000000000000000010";

    Index <= "0101";

    WordOffset <= '0';

    InputWord <= x"11111111";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '1';

    Tag <= "0010000000000000000000001";

    Index <= "0110";

    WordOffset <= '1';

    InputWord <= x"11111110";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
 
 
------------------------------------------------------------------------------------- 
 
     WrEn <= '1';

    Tag <= "0000000000000000000000000";

    Index <= "0110";

    WordOffset <= '0';

    InputWord <= x"12345678";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '1';

    Tag <= "0000000000000000000000000";

    Index <= "0101";

    WordOffset <= '1';

    InputWord <= x"87654321";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
   
   
    
    WrEn <= '1';

    Tag <= "0000000000000000000000001";

    Index <= "0100";

    WordOffset <= '0';

    InputWord <= x"11111111";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '1';

    Tag <= "0000000000000000000000001";

    Index <= "0011";

    WordOffset <= '1';

    InputWord <= x"11111110";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
   
    WrEn <= '1';

    Tag <= "0000001000000000000000010";

    Index <= "0010";

    WordOffset <= '0';

    InputWord <= x"11111111";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '1';

    Tag <= "0010000000000000000000001";

    Index <= "0001";

    WordOffset <= '1';

    InputWord <= x"11111110";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
------------------------------ end of writes ------- now start reading---------------

    WrEn <= '0';

    Tag <= "0010000000000000000000001";

    Index <= "0001";

    WordOffset <= '1';

    InputWord <= x"11111110";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
        
    WrEn <= '0';

    Tag <= "0000000000000000000000001";

    Index <= "0100";

    WordOffset <= '0';

    InputWord <= x"11111111";

    InputWordOffset <= '0';
    
    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
    
    WrEn <= '0';

    Tag <= "0010000000000000000000000";

    Index <= "0001";

    WordOffset <= '1';

    InputWord <= x"11111110";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;

    WrEn <= '0';

    Tag <= "0000000000000000000000000";

    Index <= "0010";

    WordOffset <= '1';

    InputWord <= x"87654321";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;


    WrEn <= '0';

    Tag <= "0000000000000000000000000";

    Index <= "0101";

    WordOffset <= '1';

    InputWord <= x"87654321";

    InputWordOffset <= '1';

    wait for 10 ns;
    WrEn <= '0';
    wait for 10 ns;
 
  end process;
end TEST;