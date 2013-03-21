-- $Id: $
-- File name:   tb_controller.vhd
-- Created:     1/24/2013
-- Author:      Vineeth Harikumar
-- Lab Section: Wednesday 7:30-10:20
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_controller is
end tb_controller;

architecture TEST of tb_controller is

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

  component controller
    PORT(
         opcode : in STD_LOGIC_VECTOR(31 downto 26);
         function_code : in STD_LOGIC_VECTOR(5 downto 0);
         regDst : out STD_LOGIC;
         extOp : out STD_LOGIC;
         branch : out STD_LOGIC;
         memRead : out STD_LOGIC;
         memToReg : out STD_LOGIC;
         ALUCtr : out STD_LOGIC_VECTOR(2 downto 0);
         memWrite : out STD_LOGIC;
         ALUSrc : out STD_LOGIC;
         regWrite : out STD_LOGIC;
         j_flag : out STD_LOGIC;
         jal_flag : out STD_LOGIC;
         jr_flag : out STD_LOGIC;
         lui_flag : out STD_LOGIC;
         slt_u_flag : out STD_LOGIC;
         pc_write_enable : out STD_LOGIC;
         bne_flag : out STD_LOGIC;
         lw_flag : out STD_LOGIC
    );
  end component;

-- Insert signals Declarations here
  signal opcode : STD_LOGIC_VECTOR(31 downto 26);
  signal function_code : STD_LOGIC_VECTOR(5 downto 0);
  signal regDst : STD_LOGIC;
  signal extOp : STD_LOGIC;
  signal branch : STD_LOGIC;
  signal memRead : STD_LOGIC;
  signal memToReg : STD_LOGIC;
  signal ALUCtr : STD_LOGIC_VECTOR(2 downto 0);
  signal memWrite : STD_LOGIC;
  signal ALUSrc : STD_LOGIC;
  signal regWrite : STD_LOGIC;
  signal j_flag : STD_LOGIC;
  signal jal_flag : STD_LOGIC;
  signal jr_flag : STD_LOGIC;
  signal lui_flag : STD_LOGIC;
  signal slt_u_flag : STD_LOGIC;
  signal pc_write_enable : STD_LOGIC;
  signal bne_flag : STD_LOGIC;
  signal lw_flag : STD_LOGIC;

-- signal <name> : <type>;

begin
  DUT: controller port map(
                opcode => opcode,
                function_code => function_code,
                regDst => regDst,
                extOp => extOp,
                branch => branch,
                memRead => memRead,
                memToReg => memToReg,
                ALUCtr => ALUCtr,
                memWrite => memWrite,
                ALUSrc => ALUSrc,
                regWrite => regWrite,
                j_flag => j_flag,
                jal_flag => jal_flag,
                jr_flag => jr_flag,
                lui_flag => lui_flag,
                slt_u_flag => slt_u_flag,
                pc_write_enable => pc_write_enable,
                bne_flag => bne_flag,
                lw_flag => lw_flag
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
--------------------------- R-ttype instructions ------------------
    opcode <= "000000";
    function_code <= "100001"; -- ADDU
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "100100"; -- AND
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "001000"; -- JR
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "100111"; -- NOR
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "100101"; -- OR
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "101010"; -- SLT
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "101011"; -- SLTU
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "000000"; -- SLL
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "000010"; -- SRL
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "100011"; -- SUBU
    wait for 10 ns;
    
    opcode <= "000000";
    function_code <= "100110"; -- XOR
    wait for 10 ns;
    
--------------------------- I-type instructions ------------------
    opcode <= "001001";
    function_code <= "000000"; -- ADDIU
    wait for 10 ns;
    
    opcode <= "001100";
    function_code <= "000000"; -- ANDI
    wait for 10 ns;
    
    opcode <= "000100";
    function_code <= "000000"; -- BEQ
    wait for 10 ns;
    
    opcode <= "000101";
    function_code <= "000000"; -- BNE
    wait for 10 ns;
    
    opcode <= "001111";
    function_code <= "000000"; -- LUI
    wait for 10 ns;
    
    opcode <= "100011";
    function_code <= "000000"; -- LW
    wait for 10 ns;
    
    opcode <= "001101";
    function_code <= "000000"; -- ORI
    wait for 10 ns;
    
    opcode <= "001010";
    function_code <= "000000"; -- SLTI
    wait for 10 ns;
    
    opcode <= "001011";
    function_code <= "000000"; -- SLTIU
    wait for 10 ns;
    
    opcode <= "101011";
    function_code <= "000000"; -- SW
    wait for 10 ns;
    
    opcode <= "001110";
    function_code <= "000000"; -- XORI
    wait for 10 ns;
    
    opcode <= "000010";
    function_code <= "000000"; -- J
    wait for 10 ns;
    
    opcode <= "000011";
    function_code <= "000000"; -- JAL
    wait for 10 ns;
    
    opcode <= "111111";
    function_code <= "111111"; -- HALT
    wait for 10 ns;
    
    
  end process;
end TEST;