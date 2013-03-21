--This is to be used as a hardware counter for labs 8 and 9

--On every cache hit, update the counter. When executing the
--dump sequence for your cache on halt, store this counter 
--value at address 0x3100
--For instance, if you have a state machine search your cache
--for dirty blocks, let your last state dump this count

--**You will most likely need to add more logic for the counter
--to function correctly with your design.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hitcounter is
port(
	clk	:	in std_logic;	--just the clock
	nReset	:	in std_logic;	--just the reset
	we	:	in std_logic;	--write enable, if needed 
	hit	:	in std_logic;	--feed a hit signal here
	count	:	out std_logic_vector(31 downto 0); --the count
	addr	:	out std_logic_vector(15 downto 0) --addr to write count
		
);
end hitcounter;

architecture behavioral of hitcounter is

signal count_i : std_logic_vector(31 downto 0);

begin

process(clk,nReset,we,hit)
begin
	if(nReset = '0') then
		count_i <= (others=>'0');
	elsif(clk'event and clk='1') then
		if(we = '1' and hit = '1') then
			count_i <= std_logic_vector(unsigned(count_i) + 1);
		end if;
	end if;

end process;

count <= count_i;
addr <= x"3100";

end architecture;


--Issues to watch out for:
--1. Eventually your dcache 'hit' should go high even for cache misses
--   after the words are loaded into the cache. You do NOT
--   want this to increment your hit counter
--2. Any case of 'we' and 'hit' being high for multiple
--   cycles will increment your counter multiple times for
--   one hit. If this is the case in your processor, you 
--   will need additional logic to prevent multiple increments.
