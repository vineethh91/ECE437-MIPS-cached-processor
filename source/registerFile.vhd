-- 32 bit version register file
-- evillase

library ieee;
use ieee.std_logic_1164.all;

entity registerFile is
	port
	(
		-- Write data input port
		wdat		:	in	std_logic_vector (31 downto 0);
		-- Select which register to write
		wsel		:	in	std_logic_vector (4 downto 0);
		-- Write Enable for entire register file
		wen			:	in	std_logic;
		-- clock, positive edge triggered
		clk			:	in	std_logic;
		-- REMEMBER: nReset-> '0' = RESET, '1' = RUN
		nReset	:	in	std_logic;
		-- Select which register to read on rdat1 
		rsel1		:	in	std_logic_vector (4 downto 0);
		-- Select which register to read on rdat2
		rsel2		:	in	std_logic_vector (4 downto 0);
		-- read port 1
		rdat1		:	out	std_logic_vector (31 downto 0);
		-- read port 2
		rdat2		:	out	std_logic_vector (31 downto 0)
		);
end registerFile;

architecture regfile_arch of registerFile is

	constant BAD1	:	std_logic_vector		:= x"BAD1BAD1";

	type REGISTER32 is array (1 to 31) of std_logic_vector(31 downto 0);
	signal reg	:	REGISTER32;				-- registers as an array

  -- enable lines... use en(x) to select
  -- individual lines for each register
	signal en		:	std_logic_vector(31 downto 0);

begin

	-- registers process
	registers : process (clk, nReset, en, wen, wdat)
  begin
    -- one register if statement
    if (nReset = '0') then
			-- Reset here
        reg <= (OTHERS => x"00000000");

    elsif (falling_edge(clk)) then
      if(wen = '1') then    -------- If wen is enabled then check for each one of the respective enables and if enabled then store word in wdat into that register
        if(en(1) = '1') then
            reg(1) <= wdat;
        elsif(en(2) = '1') then
            reg(2) <= wdat;
        elsif(en(3) = '1') then
            reg(3) <= wdat;
        elsif(en(4) = '1') then
            reg(4) <= wdat;
        elsif(en(5) = '1') then
            reg(5) <= wdat;
        elsif(en(6) = '1') then
            reg(6) <= wdat;
        elsif(en(7) = '1') then
            reg(7) <= wdat;
        elsif(en(8) = '1') then
            reg(8) <= wdat;
        elsif(en(9) = '1') then
            reg(9) <= wdat;
        elsif(en(10) = '1') then
            reg(10) <= wdat;
        elsif(en(11) = '1') then
            reg(11) <= wdat;
        elsif(en(12) = '1') then
            reg(12) <= wdat;
        elsif(en(13) = '1') then
            reg(13) <= wdat;
        elsif(en(14) = '1') then
            reg(14) <= wdat;
        elsif(en(15) = '1') then
            reg(15) <= wdat;
        elsif(en(16) = '1') then
            reg(16) <= wdat;
        elsif(en(17) = '1') then
            reg(17) <= wdat;
        elsif(en(18) = '1') then
            reg(18) <= wdat;
        elsif(en(19) = '1') then
            reg(19) <= wdat;
        elsif(en(20) = '1') then
            reg(20) <= wdat;
        elsif(en(21) = '1') then
            reg(21) <= wdat;
        elsif(en(22) = '1') then
            reg(22) <= wdat;
        elsif(en(23) = '1') then
            reg(23) <= wdat;
        elsif(en(24) = '1') then
            reg(24) <= wdat;
        elsif(en(25) = '1') then
            reg(25) <= wdat;
        elsif(en(26) = '1') then
            reg(26) <= wdat;
        elsif(en(27) = '1') then
            reg(27) <= wdat;
        elsif(en(28) = '1') then
            reg(28) <= wdat;
        elsif(en(29) = '1') then
            reg(29) <= wdat;
        elsif(en(30) = '1') then
            reg(30) <= wdat;
        elsif(en(31) = '1') then
            reg(31) <= wdat;
        end if;
      end if;
			-- Set register here
    end if;
  end process;


    fiveToThirtyTwoDemux : process(clk, wsel) -- process to decode wsel and enable the respective en bit corresponding to the value in wsel
    begin
  	--decoder for assigning en:
	en <= x"00000000";
        
	case wsel is
            when "00000" => en(0) <= '1';
            when "00001" => en(1) <= '1';
            when "00010" => en(2) <= '1';
            when "00011" => en(3) <= '1';
            when "00100" => en(4) <= '1';
            when "00101" => en(5) <= '1';
            when "00110" => en(6) <= '1';
            when "00111" => en(7) <= '1';
            when "01000" => en(8) <= '1';
            when "01001" => en(9) <= '1';
            when "01010" => en(10) <= '1';
            when "01011" => en(11) <= '1';
            when "01100" => en(12) <= '1';
            when "01101" => en(13) <= '1';
            when "01110" => en(14) <= '1';
            when "01111" => en(15) <= '1';
            when "10000" => en(16) <= '1';
            when "10001" => en(17) <= '1';
            when "10010" => en(18) <= '1';
            when "10011" => en(19) <= '1';
            when "10100" => en(20) <= '1';
            when "10101" => en(21) <= '1';
            when "10110" => en(22) <= '1';
            when "10111" => en(23) <= '1';
            when "11000" => en(24) <= '1';
            when "11001" => en(25) <= '1';
            when "11010" => en(26) <= '1';
            when "11011" => en(27) <= '1';
            when "11100" => en(28) <= '1';
            when "11101" => en(29) <= '1';
            when "11110" => en(30) <= '1';
            when "11111" => en(31) <= '1';
            when OTHERS => en <= BAD1;
        end case;
    end process;
                
	--rsel muxes:
	with rsel1 select      ---- based on the rsel1 value assigns the output from the respective register to rdat1 output
		rdat1 <=	x"00000000" when "00000",
                                reg(1) when "00001",
                                reg(2) when "00010",
                                reg(3) when "00011",
                                reg(4) when "00100",
                                reg(5) when "00101",
                                reg(6) when "00110",
                                reg(7) when "00111",
                                reg(8) when "01000",
                                reg(9) when "01001",
                                reg(10) when "01010",
                                reg(11) when "01011",
                                reg(12) when "01100",
                                reg(13) when "01101",
                                reg(14) when "01110",
                                reg(15) when "01111",
                                reg(16) when "10000",
                                reg(17) when "10001",
                                reg(18) when "10010",
                                reg(19) when "10011",
                                reg(20) when "10100",
                                reg(21) when "10101",
                                reg(22) when "10110",
                                reg(23) when "10111",
                                reg(24) when "11000",
                                reg(25) when "11001",
                                reg(26) when "11010",
                                reg(27) when "11011",
                                reg(28) when "11100",
                                reg(29) when "11101",
                                reg(30) when "11110",
                                reg(31) when "11111",
                                BAD1 when others;

	with rsel2 select     ---- based on the rsel2 value assigns the output from the respective register to rdat2 output
		rdat2 <=	x"00000000" when "00000",
                                reg(1) when "00001",
                                reg(2) when "00010",
                                reg(3) when "00011",
                                reg(4) when "00100",
                                reg(5) when "00101",
                                reg(6) when "00110",
                                reg(7) when "00111",
                                reg(8) when "01000",
                                reg(9) when "01001",
                                reg(10) when "01010",
                                reg(11) when "01011",
                                reg(12) when "01100",
                                reg(13) when "01101",
                                reg(14) when "01110",
                                reg(15) when "01111",
                                reg(16) when "10000",
                                reg(17) when "10001",
                                reg(18) when "10010",
                                reg(19) when "10011",
                                reg(20) when "10100",
                                reg(21) when "10101",
                                reg(22) when "10110",
                                reg(23) when "10111",
                                reg(24) when "11000",
                                reg(25) when "11001",
                                reg(26) when "11010",
                                reg(27) when "11011",
                                reg(28) when "11100",
                                reg(29) when "11101",
                                reg(30) when "11110",
                                reg(31) when "11111",
                                BAD1 when others;

end regfile_arch;
