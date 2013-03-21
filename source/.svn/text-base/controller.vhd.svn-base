LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity controller is

   port ( opcode: in STD_LOGIC_VECTOR(5 downto 0);
          function_code: in STD_LOGIC_VECTOR(5 downto 0);

          regDst: out STD_LOGIC;
          extOp: out STD_LOGIC;
          branch: out STD_LOGIC;
          memRead: out STD_LOGIC;
          memToReg: out STD_LOGIC;
          ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          memWrite: out STD_LOGIC;
          ALUSrc: out STD_LOGIC;
          regWrite: out STD_LOGIC;
          j_flag: out STD_LOGIC;
          jal_flag: out STD_LOGIC;
          jr_flag: out STD_LOGIC;
          lui_flag: out STD_LOGIC;
          slt_u_flag: out STD_LOGIC;
          pc_write_enable: out STD_LOGIC;
          bne_flag: out STD_LOGIC;
          lw_flag: out STD_LOGIC;
          halt_flag: out STD_LOGIC;
          shamt_flag: OUT STD_LOGIC;
          sign_flag: out STD_LOGIC
	) ;

end controller;

architecture arch_controller of controller is
begin

  process(opcode, function_code)
  begin
          regDst <= '0';
          ALUCtr <= "0000";
          regWrite <= '0';
          jr_flag <= '0';
          slt_u_flag <= '0';

    if(to_integer(unsigned(opcode)) /= 0) then -------- IF OPCODE IS NOT 0 then decode it!!!
        regDst <= '1';
        
        case to_integer(unsigned(opcode)) is
          when 9 => ALUCtr <= "0010";
          when 12 => ALUCtr <= "0100";
          when 4 => ALUCtr <= "0011";
          when 5 => ALUCtr <= "0011";
          when 35 => ALUCtr <= "0010";
          when 13 => ALUCtr <= "0110";
          when 10 => ALUCtr <= "0011";
          when 11 => ALUCtr <= "0011";
          when 43 => ALUCtr <= "0010";
          when 14 => ALUCtr <= "0111";
          when others => ALUCtr <= "0000";
        end case;
      
      if(to_integer(unsigned(opcode)) = 9 or to_integer(unsigned(opcode)) = 12 or to_integer(unsigned(opcode)) = 15 or to_integer(unsigned(opcode)) = 35 or to_integer(unsigned(opcode)) = 13 or to_integer(unsigned(opcode)) = 10 or to_integer(unsigned(opcode)) = 11 or to_integer(unsigned(opcode)) = 14 or to_integer(unsigned(opcode)) = 3) then
        regWrite <= '1';
      else
        regWrite <= '0';
      end if;

      if(to_integer(unsigned(opcode)) = 10 or to_integer(unsigned(opcode)) = 11 ) then
        slt_u_flag <= '1';
      else
        slt_u_flag <= '0';
      end if;
  
    else --------------------------------------- IF OPCODE = 000 AND NEED TO LOOK AT FUNCTION CODE
        case to_integer(unsigned(function_code)) is
          when 33 => ALUCtr <= "0010";
          when 36 => ALUCtr <= "0100";
          when 39 => ALUCtr <= "0101";
          when 37 => ALUCtr <= "0110";
          when 42 => ALUCtr <= "0011";
          when 43 => ALUCtr <= "0011";
          when 0 => ALUCtr <= "0000";
          when 2 => ALUCtr <= "0001";
          when 35 => ALUCtr <= "0011";
          when 38 => ALUCtr <= "0111";
          when others => ALUCtr <= "0000";
        end case;
        
      if(to_integer(unsigned(function_code)) = 8) then
        regWrite <= '0';
        jr_flag <= '1';
      --elsif(to_integer(unsigned(function_code)) = 0) then
      --  regWrite <= '0';
      else
        regWrite <= '1';
        jr_flag <= '0';
      end if;

      if(to_integer(unsigned(function_code)) = 42 or to_integer(unsigned(function_code)) =43) then
        slt_u_flag <= '1';
      else
        slt_u_flag <= '0';
      end if;
  
   end if;
  end process;


      with to_integer(unsigned(opcode)) select
        extOp  <= '1' when 9 | 35 | 10 | 11 | 43,
                  '0' when others;

      with to_integer(unsigned(opcode)) select
        branch <= '1' when 4 | 5,
                  '0' when others;

      with to_integer(unsigned(opcode)) select
        memRead <= '1' when 35,
                   '0' when others;


      with to_integer(unsigned(opcode)) select
        memToReg <= '1' when 35,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        memWrite <= '1' when 43,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        ALUSrc <= '1' when 9 | 12 | 35 | 13 | 10 | 11 | 43 | 14,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        j_flag <= '1' when 2,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        jal_flag <= '1' when 3,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        lw_flag <= '1' when 35,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        lui_flag <= '1' when 15,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        bne_flag <= '1' when 5,
                   '0' when others;

      with to_integer(unsigned(opcode)) select
        pc_write_enable <= '0' when 63 | 35,
                   '1' when others;
      
      shamt_flag <= '1' when (opcode="000000" and (function_code="000000" or function_code="000010")) else '0';
      
      halt_flag <= '1' when opcode="111111" and function_code="111111" else '0';
      
      sign_flag <= '0' when ( (opcode="000000" and (function_code="100001" or function_code="101011" or function_code="100011")) or opcode="001001" or opcode="001011") else '1';
end arch_controller;

