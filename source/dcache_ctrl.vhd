-- cache tempalte
-- this is provided as a guide to build your cache. It is by no means unfallable.
-- you may need to update vector bit ranges to match specifications in lab handout.
--
-- THIS IS NOT ERROR FREE CODE, YOU MUST UPDATE AND VERIFY SANITY OF LOGIC/INTERFACES
--
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity dcache_ctrl is
	port(
		CLK					:	in	std_logic;
		nReset			:	in	std_logic;
		
		poop : in std_logic; -- dump logic
		pooped : out std_logic; -- finished dumping
		
		WAY0_Hit					:	in	std_logic;
		WAY1_Hit					:	in	std_logic;
		WAY0_Dirty					:	in	std_logic;
		WAY1_Dirty					:	in	std_logic;
		WAY0_Valid					:	in	std_logic;
		WAY1_Valid					:	in	std_logic;
		WAY0_WriteEnable				:	out	std_logic;	
    WAY1_WriteEnable    : out std_logic;
		WAY0_outputWord					:	in	std_logic_vector(31 downto 0);
		WAY1_outputWord					:	in	std_logic_vector(31 downto 0);
    WAY0_currentTag					:	in	std_logic_vector(24 downto 0);
		WAY1_currentTag					:	in	std_logic_vector(24 downto 0);

    CACHE_StoreWordOffset : out std_logic;
		CACHE_WordToStore : out std_logic_vector(31 downto 0);
		CACHE_Index : out std_logic_vector(3 downto 0);
		CACHE_WordOffset : out std_logic;
		
		HIT_COUNTER_WE : out std_logic;
		HIT_COUNTER_NEW_HIT : out std_logic;
		HIT_COUNTER_COUNT : in std_logic_vector(31 downto 0);
		HIT_COUNTER_STORE_ADDRESS : in std_logic_vector(15 downto 0);
		
		MEMStage_Addr   : in std_logic_vector (31 downto 0);
		MEMStage_Word			:	in	std_logic_vector (31 downto 0);
		MEMStage_memRead				:	in	std_logic;
		MEMStage_memWrite				:	in	std_logic;
    MEMStage_memWait : out std_logic;
    
		arbiterMemRead			:	out	std_logic;
		arbiterMemWrite		:	out	std_logic;
		arbiterMemAddr   : out std_logic_vector (31 downto 0);
		arbiterMemDataWrite   : out std_logic_vector (31 downto 0);
		arbiterMemWait			:	in	std_logic;
		arbiterMemDataRead			:	in	std_logic_vector (31 downto 0)
		
	);
end dcache_ctrl;

architecture struct of dcache_ctrl is 
  type state_type is (IDLE, WRITE_WORD0, WRITE_WORD1, FETCH_WORD0, FETCH_WORD1, DUMP_WAY0_WORD0, DUMP_WAY0_WORD1, DUMP_WAY1_WORD0, DUMP_WAY1_WORD1, DUMP_HIT_COUNT, DUMP_FINISHED);
  signal state, nextState : state_type;
  signal LEAST_RECENTLY_USED, NEXT_LRU : std_logic_vector(15 downto 0); -- If LRU(index) = '0' then that means WAY0 will be written to, else if its = '1' then WAY1 will be written to
  signal indexInteger : integer range 0 to 15;
  signal WORD0_Addr, WORD1_Addr : std_logic_vector(31 downto 0);
  signal WRITEWORD0_Addr, WRITEWORD1_Addr : std_logic_vector(31 downto 0);
  signal DUMP_WAY0_WORD0_AddrSignal, DUMP_WAY0_WORD1_AddrSignal, DUMP_WAY1_WORD0_AddrSignal, DUMP_WAY1_WORD1_AddrSignal : std_logic_vector(31 downto 0);
  signal dumpIndexCount, nextDumpIndexCount : std_logic_vector(3 downto 0);
  signal hitCounterStoreAddress : std_logic_vector(31 downto 0);
  signal prevMemStageAddr : std_logic_vector(28 downto 0);
  signal prevMemStageFullAddr : std_logic_vector(31 downto 0);
  signal prevMemStageMemWrite, prevMemStageMemRead : std_logic;
  signal hitCounterEn, nextHitCounterEn : std_logic;
begin

cctrl_state: process(CLK, nReset)
begin
	if nReset = '0' then
    state <= IDLE;
    LEAST_RECENTLY_USED <= x"0000";
    dumpIndexCount <= (others => '0');
    prevMemStageAddr <= (others => '0');
    prevMemStageMemWrite <= '0';
    prevMemStageMemRead <= '0';
    hitCounterEn <= '0';
	elsif rising_edge(CLK) then
    state <= nextState;
    LEAST_RECENTLY_USED <= NEXT_LRU;
    dumpIndexCount <= nextDumpIndexCount;
    prevMemStageAddr <= MEMStage_Addr(31 downto 3);
    prevMemStageFullAddr <= MEMStage_Addr;
    prevMemStageMemWrite <= MEMStage_memWrite;
    prevMemStageMemRead <= MEMStage_memRead;
    hitCounterEn <= nextHitCounterEn;
	end if;
end process cctrl_state;

cctrl_ns: process(CLK, WAY0_Hit, WAY1_Hit, poop, WAY0_Dirty, WAY1_Dirty, WAY0_Valid, WAY1_Valid, WAY0_outputWord, WAY1_outputWord, WAY0_currentTag, WAY1_currentTag, MEMStage_Addr, MEMStage_Word, MEMStage_memRead, MEMStage_memWrite, arbiterMemWait, arbiterMemDataRead)
begin
	--case state is
		-- read data from memory to fill cache block
		-- write data from cache block to memory when dirty
--	end case;
  nextState <= state;
  NEXT_LRU <= LEAST_RECENTLY_USED;
  nextDumpIndexCount <= dumpIndexCount;
  
  case state is
    when IDLE =>
      nextHitCounterEn <= '1';
      if(((WAY0_Hit = '0') and (WAY1_Hit = '0')) and ((MEMStage_memRead = '1') or (MEMStage_memWrite = '1'))) then
        if( ((WAY0_Valid = '1') and (WAY0_Dirty = '1') and (LEAST_RECENTLY_USED(indexInteger) = '0')) or ((WAY1_Valid = '1') and (WAY1_Dirty = '1') and (LEAST_RECENTLY_USED(indexInteger) = '1')) ) then
          nextState <= WRITE_WORD0;
        else
          nextState <= FETCH_WORD0;
        end if;
      --elsif( ((MEMStage_memWrite = '1') and ((prevMemStageMemWrite /= MEMStage_memWrite) or (prevMemStageAddr /= MEMStage_Addr(31 downto 3)))) or ((MEMStage_memRead = '1') and ((prevMemStageMemRead /= MEMStage_memRead)  or (prevMemStageAddr /= MEMStage_Addr(31 downto 3))))) then
      elsif( ((MEMStage_memWrite = '1') and ((prevMemStageAddr /= MEMStage_Addr(31 downto 3)))) or ((MEMStage_memRead = '1') and ((prevMemStageAddr /= MEMStage_Addr(31 downto 3))))) then
        if(WAY0_Hit = '1') then
          NEXT_LRU(indexInteger) <= '1';
        else
          NEXT_LRU(indexInteger) <= '0';
        end if;
      elsif(poop = '1') then
        nextState <= DUMP_WAY0_WORD0;
      end if;

    when WRITE_WORD0 =>
      if(arbiterMemWait = '0') then
        nextState <= WRITE_WORD1;
      end if;
      
    when WRITE_WORD1 =>
      if(arbiterMemWait = '0') then
        nextState <= FETCH_WORD0;
      end if;
            
    when FETCH_WORD0 =>
      if(arbiterMemWait = '0') then
        nextState <= FETCH_WORD1;
      end if;
      
    when FETCH_WORD1 =>
      if(arbiterMemWait = '0') then
        nextState <= IDLE;
        NEXT_LRU(indexInteger) <= not (LEAST_RECENTLY_USED(indexInteger));
        nextHitCounterEn <= '0';
      end if;
      
    when DUMP_WAY0_WORD0 =>
      if(WAY0_Dirty = '0') then
        nextState <= DUMP_WAY1_WORD0;
      elsif(arbiterMemWait = '0') then
        nextState <= DUMP_WAY1_WORD0;
      end if;
      
    when DUMP_WAY1_WORD0 =>
      if(WAY1_Dirty = '0') then
        nextState <= DUMP_WAY0_WORD1;
      elsif(arbiterMemWait = '0') then
        nextState <= DUMP_WAY0_WORD1;
      end if;
    
    when DUMP_WAY0_WORD1 =>
      if(WAY0_Dirty = '0') then
        nextState <= DUMP_WAY1_WORD1;
      elsif(arbiterMemWait = '0') then
        nextState <= DUMP_WAY1_WORD1;
      end if;
      
    when DUMP_WAY1_WORD1 =>
      if((arbiterMemWait = '0') and (dumpIndexCount /= "1111")) then
        nextDumpIndexCount <= std_logic_vector(unsigned(dumpIndexCount) + 1);
        nextState <= DUMP_WAY0_WORD0;
      elsif((arbiterMemWait = '0') and (dumpIndexCount = "1111")) then
        nextState <= DUMP_HIT_COUNT;
      elsif((WAY1_Dirty = '0') and (dumpIndexCount /= "1111")) then
        nextDumpIndexCount <= std_logic_vector(unsigned(dumpIndexCount) + 1);
        nextState <= DUMP_WAY0_WORD0;
      elsif((WAY1_Dirty = '0') and (dumpIndexCount = "1111")) then
        nextState <= DUMP_HIT_COUNT;
      end if;
      
    when DUMP_HIT_COUNT => 
      if(arbiterMemWait = '0') then
        nextState <= DUMP_FINISHED;
      end if;
      
    when DUMP_FINISHED =>
      nextState <= DUMP_FINISHED;
      
    when OTHERS =>
      nextState <= IDLE;
      
  end case;
end process cctrl_ns;

indexInteger <= to_integer(unsigned(MEMStage_Addr(6 downto 3))); -- convert the index to a integer so we can use it to look up values in the array

		WAY0_WriteEnable	<= '1' when ((((state = FETCH_WORD0) and (arbiterMemWait = '0')) or ((state = FETCH_WORD1) and (arbiterMemWait = '0'))) and (LEAST_RECENTLY_USED(indexInteger) = '0'))
		                    else '1' when ((WAY0_Hit = '1') and (MEMStage_memWrite = '1'))
		                    else '0';
    WAY1_WriteEnable <= '1' when ((((state = FETCH_WORD0) and (arbiterMemWait = '0')) or ((state = FETCH_WORD1) and (arbiterMemWait = '0'))) and (LEAST_RECENTLY_USED(indexInteger) = '1')) 
                        else '1' when ((WAY1_Hit = '1') and (MEMStage_memWrite = '1'))
                        else '0';
    CACHE_StoreWordOffset <= '0' when (state = FETCH_WORD0) 
                             else '1' when (state = FETCH_WORD1)
                             else MEMStage_Addr(2);
    CACHE_WordToStore <= MEMStage_Word when (state = IDLE) else arbiterMemDataRead;

    DUMP_WAY0_WORD0_AddrSignal <= WAY0_currentTag & dumpIndexCount & "000";
    DUMP_WAY0_WORD1_AddrSignal <= WAY0_currentTag & dumpIndexCount & "100";
    DUMP_WAY1_WORD0_AddrSignal <= WAY1_currentTag & dumpIndexCount & "000";
    DUMP_WAY1_WORD1_AddrSignal <= WAY1_currentTag & dumpIndexCount & "100";
    
    CACHE_Index <= dumpIndexCount when ((state = DUMP_WAY0_WORD0) or (state = DUMP_WAY0_WORD1) or (state = DUMP_WAY1_WORD0) or (state = DUMP_WAY1_WORD1)) 
                   else MEMStage_Addr(6 downto 3);
    
    CACHE_WordOffset <= '0' when ((state = WRITE_WORD0) or (state = DUMP_WAY0_WORD0) or (state = DUMP_WAY1_WORD0)) else '1' when ((state = WRITE_WORD1) or (state = DUMP_WAY0_WORD1) or (state = DUMP_WAY1_WORD1) ) 
                        else MEMStage_Addr(2);
    
		arbiterMemRead	<= '1' when (((state = IDLE) and (nextState = FETCH_WORD0)) or (state = FETCH_WORD0) or (state = FETCH_WORD1)) else '0';
		arbiterMemWrite	<= '1' when (((state = IDLE) and (nextState = WRITE_WORD0)) or (state = WRITE_WORD0) or (state = WRITE_WORD1) or ((state = DUMP_WAY0_WORD0) and (WAY0_Dirty = '1')) or ((state = DUMP_WAY0_WORD1) and (WAY0_Dirty = '1')) or ((state = DUMP_WAY1_WORD0) and (WAY1_Dirty = '1')) or ((state = DUMP_WAY1_WORD1)  and (WAY1_Dirty = '1')) or (state = DUMP_HIT_COUNT)) else '0';

    MEMStage_memWait <= '1' when (((((state = IDLE) and (nextState = FETCH_WORD0)) or (state = FETCH_WORD0) or (state = FETCH_WORD1)))   or    (((state = IDLE) and (nextState = WRITE_WORD0)) or (state = WRITE_WORD0) or (state = WRITE_WORD1))) 
                        else '0';

    WORD0_Addr <= MEMStage_Addr(31 downto 3) & "000";
    WORD1_Addr <= MEMStage_Addr(31 downto 3) & "100";
    
    WRITEWORD0_Addr <= (WAY0_currentTag & MEMStage_Addr(6 downto 3) & "000") when (LEAST_RECENTLY_USED(indexInteger) = '0') 
                       else (WAY1_currentTag & MEMStage_Addr(6 downto 3) & "000");
                         
    WRITEWORD1_Addr <= (WAY0_currentTag & MEMStage_Addr(6 downto 3) & "100") when (LEAST_RECENTLY_USED(indexInteger) = '0') 
                       else (WAY1_currentTag & MEMStage_Addr(6 downto 3) & "100");
    
		arbiterMemAddr <= WORD0_Addr when (state = FETCH_WORD0) 
		                  else WORD1_Addr when (state = FETCH_WORD1) 
		                  else WRITEWORD0_Addr when (state = WRITE_WORD0)
		                  else WRITEWORD1_Addr when (state = WRITE_WORD1)
		                  else DUMP_WAY0_WORD0_AddrSignal when (state = DUMP_WAY0_WORD0)
		                  else DUMP_WAY0_WORD1_AddrSignal when (state = DUMP_WAY0_WORD1)
		                  else DUMP_WAY1_WORD0_AddrSignal when (state = DUMP_WAY1_WORD0)
		                  else DUMP_WAY1_WORD1_AddrSignal when (state = DUMP_WAY1_WORD1)
		                  else hitCounterStoreAddress when (state = DUMP_HIT_COUNT)
		                  else MEMStage_Addr;
		
		arbiterMemDataWrite <= WAY0_outputWord when (((state = WRITE_WORD0) or (state = WRITE_WORD1)) and (LEAST_RECENTLY_USED(indexInteger) = '0')) 
		                       else WAY1_outputWord when (((state = WRITE_WORD0) or (state = WRITE_WORD1))  and (LEAST_RECENTLY_USED(indexInteger) = '1')) 
		                       else WAY0_outputWord when ((state = DUMP_WAY0_WORD0) or (state = DUMP_WAY0_WORD1)) 
		                       else WAY1_outputWord when ((state = DUMP_WAY1_WORD0) or (state = DUMP_WAY1_WORD1))
		                       else HIT_COUNTER_COUNT when (state = DUMP_HIT_COUNT)
		                       else MEMStage_Word;
    

    
		pooped <= '1' when (state = DUMP_FINISHED) else '0';
    
		HIT_COUNTER_WE <= '0' when ((state = FETCH_WORD1) and (nextState = IDLE)) 
		                  --else '1' when ((hitCounterEn = '1') and ((state = IDLE) and ((WAY0_Hit = '1') or (WAY1_Hit = '1')) and ((prevMemStageAddr /= MEMStage_Addr) or ((MEMStage_memRead = '1') and (prevMemStageMemRead /= MEMStage_memRead)) or ((MEMStage_memWrite = '1') and (prevMemStageMemWrite /= MEMStage_memWrite))) and ((MEMStage_memRead = '1') or (MEMStage_memWrite = '1'))))
		                  -- THIS WORKS FOR FIBSEARCHMULT
		                  else '1' when ((state = IDLE) and ((WAY0_Hit = '1') or (WAY1_Hit = '1')) and ((prevMemStageFullAddr /= MEMStage_Addr) or ((MEMStage_memRead = '1') and (prevMemStageMemRead /= MEMStage_memRead)) or ((MEMStage_memWrite = '1') and (prevMemStageMemWrite /= MEMStage_memWrite))) and ((MEMStage_memRead = '1') or (MEMStage_memWrite = '1')))
		                  else '0';
		                    
		HIT_COUNTER_NEW_HIT <= '0' when ((state = FETCH_WORD1) and (nextState = IDLE)) 
		                       else '1' when ((state = IDLE) and ((WAY0_Hit = '1') or (WAY1_Hit = '1')) and ((prevMemStageFullAddr /= MEMStage_Addr) or ((MEMStage_memRead = '1') and (prevMemStageMemRead /= MEMStage_memRead)) or ((MEMStage_memWrite = '1') and (prevMemStageMemWrite /= MEMStage_memWrite))) and ((MEMStage_memRead = '1') or (MEMStage_memWrite = '1')))
		                       else '0';
		--'1';
		hitCounterStoreAddress <= x"0000" & HIT_COUNTER_STORE_ADDRESS;
end;

