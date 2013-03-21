library ieee;
use ieee.std_logic_1164.all;

entity memoryArbiter is
  port(
    clk : in std_logic;
    rst_n : in std_logic;
    
    pipelineIFIDStall : out std_logic;
    pipelineIDEXStall : out std_logic;
    pipelineEXMEMStall : out std_logic;
    pipelineMEMWBStall : out std_logic;
    pcEnable : out std_logic;
    --- iCache
    aiMemWait : out  std_logic;                       -- arbitrator side
    aiMemRead : in std_logic;                       -- arbitrator side
    aiMemAddr : in std_logic_vector (31 downto 0);  -- arbitrator side
    aiMemData : out  std_logic_vector (31 downto 0);   -- arbitrator side

    --- dCache
    adMemRead      : in std_logic;                       -- arbitrator side
    adMemWrite     : in std_logic;                       -- arbitrator side
    adMemWait      : out std_logic;                       -- arbitrator side
    adMemAddr      : in std_logic_vector (31 downto 0);  -- arbitrator side
    adMemDataRead  : out  std_logic_vector (31 downto 0);  -- arbitrator side
    adMemDataWrite : in std_logic_vector (31 downto 0);   -- arbitrator side
    
    --- RAM signals
                address         : out std_logic_vector (15 DOWNTO 0);
                data            : out std_logic_vector (31 DOWNTO 0);
                wren            : out std_logic ;
                rden            : out std_logic ;
                latency_override: out std_logic ; 
                q               : in std_logic_vector (31 DOWNTO 0);
                memstate        : in std_logic_vector (1 DOWNTO 0)

    );

end memoryArbiter;

architecture arch_memoryArbiter of memoryArbiter is
  type state_type is (IDLE, FETCH_INSTRUCTION_BUSY, FETCH_INSTRUCTION_ACCESS, LOAD_WORD_BUSY, LOAD_WORD_ACCESS, STORE_WORD_BUSY, STORE_WORD_ACCESS);
  signal state, nextState : state_type;
begin

  arbiterFSM: process(clk, rst_n, aiMemRead, aiMemAddr, adMemRead, adMemWrite, adMemAddr, adMemDataWrite, q, memstate)
  begin
    if(rst_n = '0') then
      state <= IDLE;
    elsif(rising_edge(clk)) then
      nextState <= state;
      case state is
        
        when IDLE => 
            latency_override <= '0';
--            adMemWait <= '0';
        
            if(adMemRead = '1') then
              state <= LOAD_WORD_BUSY;
              nextState <= LOAD_WORD_BUSY;
--              adMemWait <= '1';
            elsif(adMemWrite = '1') then
              state <= STORE_WORD_BUSY;
              nextState <= STORE_WORD_BUSY;
--              adMemWait <= '1';
            elsif(aiMemRead = '1') then
              state <= FETCH_INSTRUCTION_BUSY;
              nextState <= FETCH_INSTRUCTION_BUSY;
            end if;
            
        when LOAD_WORD_BUSY =>
          if(memstate = "10") then
            state <= IDLE;--LOAD_WORD_ACCESS;
          end if;
          
        when LOAD_WORD_ACCESS =>
          state <= IDLE;
          
        when STORE_WORD_BUSY =>
          if(memstate = "10") then
            state <= IDLE;--STORE_WORD_ACCESS;
            --state <= STORE_WORD_ACCESS;
          end if;
          
        when STORE_WORD_ACCESS =>
            if(adMemRead = '1') then
              state <= LOAD_WORD_BUSY;
--              adMemWait <= '1';
            elsif(adMemWrite = '1') then
              state <= STORE_WORD_BUSY;
--              adMemWait <= '1';
            elsif(aiMemRead = '1') then
              state <= FETCH_INSTRUCTION_BUSY;
            else 
              state <= IDLE;
            end if;
          
        when FETCH_INSTRUCTION_BUSY =>

          if(memstate = "10") then
            state <= IDLE;--FETCH_INSTRUCTION_ACCESS;

          end if;
          
          
        when FETCH_INSTRUCTION_ACCESS =>
          state <= IDLE;
        
          
        when OTHERS =>
          state <= IDLE;
          
          
      end case; 
    end if;
  end process;

    aiMemData <= q when (state = FETCH_INSTRUCTION_BUSY) else x"00000000";
    adMemDataRead  <= q when (state = LOAD_WORD_BUSY) else x"00000000";

--    pipelineIFIDStall <= '1' when (((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE)) or ((state = LOAD_WORD_BUSY) and (memstate = "10")) or ((state = STORE_WORD_BUSY) and (memstate = "10"))) else '0';
--    pipelineIDEXStall <= '1' when (((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE)) or ((state = LOAD_WORD_BUSY) and (memstate = "10")) or ((state = STORE_WORD_BUSY) and (memstate = "10"))) else '0';
--    pipelineEXMEMStall <= '1' when (((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE)) or ((state = LOAD_WORD_BUSY) and (memstate = "10")) or ((state = STORE_WORD_BUSY) and (memstate = "10"))) else '0';
--    pipelineMEMWBStall <= '1' when (((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE)) or ((state = LOAD_WORD_BUSY) and (memstate = "10")) or ((state = STORE_WORD_BUSY) and (memstate = "10"))) else '0';

    pipelineIFIDStall <= '1' when ((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE))   else '0';
    pipelineIDEXStall <= '1' when ((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE))   else '0';
    pipelineEXMEMStall <= '1' when ((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE))  else '0';
    pipelineMEMWBStall <= '1' when ((nextState = FETCH_INSTRUCTION_BUSY) and (state = IDLE)) else '0';
    
    pcEnable <= '0' when (((state = IDLE) and ((adMemRead = '1') or (adMemWrite = '1'))) or ((state = LOAD_WORD_BUSY) and (memstate /= "10")) or ((state = STORE_WORD_BUSY) and (memstate /= "10"))) else '1';

     aiMemWait <= '0' when ( (state = FETCH_INSTRUCTION_BUSY) and memstate = "10")  else '1' when ((state = LOAD_WORD_BUSY) or (state = STORE_WORD_BUSY)) else '0' when (aiMemRead = '0') else '1' when ((state = IDLE) or ((state = FETCH_INSTRUCTION_BUSY) and memstate /= "10")) else '0';

    adMemWait <= '1' when (((state = IDLE) and ((adMemRead = '1') or (adMemWrite = '1'))) or (state = FETCH_INSTRUCTION_BUSY) or ( (state = LOAD_WORD_BUSY) and (memstate /= "10")) or ( (state = STORE_WORD_BUSY) and (memstate /= "10") ) ) else '0';
    address <= adMemAddr(15 downto 0) when (((state = IDLE) and ((adMemRead = '1') or (adMemWrite = '1'))) or (state = LOAD_WORD_BUSY) or (state = STORE_WORD_BUSY)) else aiMemAddr(15 downto 0);
    data <= adMemDataWrite;
    wren <= '1' when ((state = STORE_WORD_BUSY) or ((state = IDLE) and (adMemWrite = '1'))) else '0';
--    rden <= '0' when ((state = STORE_WORD_BUSY) or ((state = IDLE) and (adMemWrite = '1'))) else '1';
    rden <= '1' when ((state = FETCH_INSTRUCTION_BUSY) or (state = LOAD_WORD_BUSY) or ((state = IDLE) and ((adMemRead = '1') or (aiMemRead = '1')))) else '0';
end arch_memoryArbiter;
