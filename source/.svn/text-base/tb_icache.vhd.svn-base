-- $Id: $
-- File name:   tb_icache.vhd
-- Created:     3/7/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_icache is
  	generic (Period : Time := 100 ns;
             Debug : Boolean := False);
end tb_icache;

architecture TEST of tb_icache is

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

  component icache
    PORT(
         clk : in std_logic;
         nReset : in std_logic;
         iMemRead : in std_logic;
         iMemAddr : in std_logic_vector (31 downto 0);
         iMemWait : out std_logic;
         iMemData : out std_logic_vector (31 downto 0);
         aiMemWait : in std_logic;
         aiMemData : in std_logic_vector (31 downto 0);
         aiMemRead : out std_logic;
         aiMemAddr : out std_logic_vector (31 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal nReset : std_logic;
  signal iMemRead : std_logic;
  signal iMemAddr : std_logic_vector (31 downto 0);
  signal iMemWait : std_logic;
  signal iMemData : std_logic_vector (31 downto 0);
  signal aiMemWait : std_logic;
  signal aiMemData : std_logic_vector (31 downto 0);
  signal aiMemRead : std_logic;
  signal aiMemAddr : std_logic_vector (31 downto 0);

-- signal <name> : <type>;

begin
  DUT: icache port map(
                clk => clk,
                nReset => nReset,
                iMemRead => iMemRead,
                iMemAddr => iMemAddr,
                iMemWait => iMemWait,
                iMemData => iMemData,
                aiMemWait => aiMemWait,
                aiMemData => aiMemData,
                aiMemRead => aiMemRead,
                aiMemAddr => aiMemAddr
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

clkgen: process
    variable clk_tmp : std_logic := '0';
  begin
    clk_tmp := not clk_tmp;
    clk <= clk_tmp;
    wait for Period/2;
  end process;


process

  begin

-- Insert TEST BENCH Code Here

    nReset <= '0';
    iMemRead <= '1';
    iMemAddr <= x"00000000";
    aiMemWait <= '1';
    aiMemData <= x"00000000";
    wait for Period;
    nReset <= '1';
    
    wait for Period;
    iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"00000000";
    aiMemData <= x"0108DDFA";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    
     wait for Period;
     iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"00000007";
    aiMemData <= x"0108CCCC";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    
     wait for Period;
     iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"00000008";
    aiMemData <= x"DEADBEEF";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    
    wait for Period;
    iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"00000000";
    aiMemData <= x"0108DDFA";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    
    wait for Period;
     iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"00000AAA";
    aiMemData <= x"DEADDEAD";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    
    wait for Period;
     iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"00000BAD";
    aiMemData <= x"EEAA8700";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    
    wait for Period;
     iMemRead <= '0';
    aiMemWait <= '1';
    iMemAddr <= x"FFFFFFFF";
    aiMemData <= x"FAD0FAD1";
    wait for Period;
    iMemRead <= '1';
    aiMemWait <= '0';
    wait;

  end process;
end TEST;