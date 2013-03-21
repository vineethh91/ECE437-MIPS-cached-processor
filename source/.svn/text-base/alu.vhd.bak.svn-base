library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity alu is
    port ( 
        opcode: IN STD_LOGIC_VECTOR (3 downto 0);
        A, B: IN STD_LOGIC_VECTOR (31 downto 0);
        signFlag: IN STD_LOGIC;
        aluout: OUT STD_LOGIC_VECTOR (31 downto 0);
        negative: OUT STD_LOGIC;
        overflow, zero: OUT STD_LOGIC);
end alu;

architecture alu_arch of alu is

    signal addRes, subRes, andRes, norRes, orRes, xorRes, sllRes, srlRes : STD_LOGIC_VECTOR(31 downto 0);
    signal val1, val2, extendedAddRes, extendedSubRes : STD_LOGIC_VECTOR(32 downto 0);
    signal addNeg, subNeg, andNeg, norNeg, orNeg, xorNeg, sllNeg, srlNeg, addOverflow, subOverflow, addZero, subZero, andZero, norZero, orZero, xorZero, sllZero, srlZero : STD_LOGIC;
    
begin
    -- AND operation
    andRes <= A and B;
    with andRes select
        andZero <= '1' when x"00000000",
                   '0' when OTHERS;
    with andRes(31) select
        andNeg <= '1' when '1',
                  '0' when OTHERS;               
    
    -- NOR operation
    norRes <= A nor B;
    with norRes select
        norZero <= '1' when x"00000000",
                   '0' when OTHERS;
    with norRes(31) select
        norNeg <= '1' when '1',
                  '0' when OTHERS;
                  
    -- OR operation
    orRes  <= A or  B;
    with orRes select
        orZero <= '1' when x"00000000",
                  '0' when OTHERS;
    with orRes(31) select
        orNeg <= '1' when '1',
                 '0' when OTHERS;
                  
    -- XOR operation
    xorRes <= A xor B;
    with xorRes select
        xorZero <= '1' when x"00000000",
                   '0' when OTHERS;
    with xorRes(31) select
        xorNeg <= '1' when '1',
                  '0' when OTHERS;
                  
    val1 <= (A(31) and signFlag) & A;
    val2 <= (B(31) and signFlag) & B;
                                        --------- ADD CHECK FOR 33rd and 32nd bit both being 1, in which case no overflow
    ---- Add operations
    extendedAddRes <= std_logic_vector(signed(val1) + signed(val2));
    addRes <= extendedAddRes(31 downto 0);
    
    with addRes select
        addZero <= '1' when "00000000000000000000000000000000",
                   '0' when OTHERS;
    
    addOverflow <= extendedAddRes(32) xor extendedAddRes(31);
    
    with extendedAddRes(31) select
        addNeg <= '1' when '1',
                  '0' when OTHERS;               
    
    --- Subtract operations
    extendedSubRes <= std_logic_vector(signed(val1) - signed(val2));
    subRes <= extendedSubRes(31 downto 0);
    
    with subRes select
        subZero <= '1' when "00000000000000000000000000000000",
                   '0' when OTHERS;
    
    subOverflow <= extendedSubRes(32) xor extendedSubRes(31);
    
    with extendedSubRes(31) select
        subNeg <= '1' when '1',
                  '0' when OTHERS;               
    
        
    with B(4 downto 0) select   --- cases for left shift
	      sllRes <=	A when "00000",
                  A(30 downto 0) & '0' when "00001",
                  A(29 downto 0) & "00" when "00010",
                  A(28 downto 0) & "000" when "00011",
                  A(27 downto 0) & "0000" when "00100",
                  A(26 downto 0) & "00000" when "00101",
                  A(25 downto 0) & "000000" when "00110",
                  A(24 downto 0) & "0000000" when "00111",
                  A(23 downto 0) & "00000000" when "01000",
                  A(22 downto 0) & "000000000" when "01001",
                  A(21 downto 0) & "0000000000" when "01010",
                  A(20 downto 0) & "00000000000" when "01011",
                  A(19 downto 0) & "000000000000" when "01100",
                  A(18 downto 0) & "0000000000000" when "01101",
                  A(17 downto 0) & "00000000000000" when "01110",
                  A(16 downto 0) & "000000000000000" when "01111",
                  A(15 downto 0) & "0000000000000000" when "10000",
                  A(14 downto 0) & "00000000000000000" when "10001",
                  A(13 downto 0) & "000000000000000000" when "10010",
                  A(12 downto 0) & "0000000000000000000" when "10011",
                  A(11 downto 0) & "00000000000000000000" when "10100",
                  A(10 downto 0) & "000000000000000000000" when "10101",
                  A(9 downto 0)  & "0000000000000000000000" when "10110",
                  A(8 downto 0)  & "00000000000000000000000" when "10111",
                  A(7 downto 0)  & "000000000000000000000000" when "11000",
                  A(6 downto 0)  & "0000000000000000000000000" when "11001",
                  A(5 downto 0)  & "00000000000000000000000000" when "11010",
                  A(4 downto 0)  & "000000000000000000000000000" when "11011",
                  A(3 downto 0)  & "0000000000000000000000000000" when "11100",
                  A(2 downto 0)  & "00000000000000000000000000000" when "11101",
                  A(1 downto 0)  & "000000000000000000000000000000" when "11110",
                  A(0 downto 0)  & "0000000000000000000000000000000" when "11111",
                  A when others; 
    
    with sllRes select
        sllZero <= '1' when x"00000000",
                   '0' when OTHERS;
    with sllRes(31) select
        sllNeg <= '1' when '1',
                  '0' when OTHERS;
                  
    with B(4 downto 0) select  --- cases for right shift
	      srlRes <=	A when "00000",
                  '0' & A(31 downto 1) when "00001",
                  "00" & A(31 downto 2) when "00010",
                  "000" & A(31 downto 3) when "00011",
                  "0000" & A(31 downto 4) when "00100",
                  "00000" & A(31 downto 5) when "00101",
                  "000000" & A(31 downto 6) when "00110",
                  "0000000" & A(31 downto 7) when "00111",
                  "00000000" & A(31 downto 8) when "01000",
                  "000000000" & A(31 downto 9) when "01001",
                  "0000000000" & A(31 downto 10) when "01010",
                  "00000000000" & A(31 downto 11) when "01011",
                  "000000000000" & A(31 downto 12) when "01100",
                  "0000000000000" & A(31 downto 13) when "01101",
                  "00000000000000" & A(31 downto 14) when "01110",
                  "000000000000000" & A(31 downto 15) when "01111",
                  "0000000000000000" & A(31 downto 16) when "10000",
                  "00000000000000000" & A(31 downto 17) when "10001",
                  "000000000000000000" & A(31 downto 18) when "10010",
                  "0000000000000000000" & A(31 downto 19) when "10011",
                  "00000000000000000000" & A(31 downto 20) when "10100",
                  "000000000000000000000" & A(31 downto 21) when "10101",
                  "0000000000000000000000" & A(31 downto 22) when "10110",
                  "00000000000000000000000" & A(31 downto 23) when "10111",
                  "000000000000000000000000" & A(31 downto 24) when "11000",
                  "0000000000000000000000000" & A(31 downto 25) when "11001",
                  "00000000000000000000000000" & A(31 downto 26) when "11010",
                  "000000000000000000000000000" & A(31 downto 27) when "11011",
                  "0000000000000000000000000000" & A(31 downto 28) when "11100",
                  "00000000000000000000000000000" & A(31 downto 29) when "11101",
                  "000000000000000000000000000000" & A(31 downto 30) when "11110",
                  "0000000000000000000000000000000" & A(31 downto 31) when "11111",
                  A when others; 
    
    with srlRes select
        srlZero <= '1' when x"00000000",
                   '0' when OTHERS;
    with srlRes(31) select
        srlNeg <= '1' when '1',
                  '0' when OTHERS;
                  
    with opcode select
        aluout   <= sllRes when "0000",
                    srlRes when "0001",
                    addRes when "0010",
                    subRes when "0011",
                    andRes when "0100",
                    norRes when "0101",
                    orRes  when "0110",
                    xorRes when "0111",
                    x"00000000" when OTHERS;
               
    with opcode select
        negative <= sllNeg when "0000",
                    srlNeg when "0001",
                    addNeg when "0010",
                    subNeg when "0011",
                    andNeg when "0100",
                    norNeg when "0101",
                    orNeg  when "0110",
                    xorNeg when "0111",
                    '0' when OTHERS;
    
    with opcode select
        overflow <= addOverflow when "0010",
                    subOverflow when "0011",
                    '0' when OTHERS;
     
    with opcode select
        zero     <= sllZero when "0000",
                    srlZero when "0001",
                    addZero when "0010",
                    subZero when "0011",
                    andZero when "0100",
                    norZero when "0101",
                    orZero  when "0110",
                    xorZero when "0111",
                    '0' when OTHERS;
     
end alu_arch;
