-- cache tempalte
-- this is provided as a guide to build your cache. It is by no means unfallable.
-- you may need to update vector bit ranges to match specifications in lab handout.
--
-- THIS IS NOT ERROR FREE CODE, YOU MUST UPDATE AND VERIFY SANITY OF LOGIC/INTERFACES
--

library ieee;
use ieee.std_logic_1164.all;

entity dcache is
  port(
    CLK       : in  std_logic;
    nReset    : in  std_logic;

		Halt			:	in	std_logic;											 -- CPU side
		donePooping : out std_logic; -- finished dumping to MEMORY
		
    dMemRead		: in  std_logic;                       -- CPU side
		dMemWrite	:	in	std_logic;											 -- CPU side
    dMemWait		: out std_logic;                       -- CPU side
    dMemAddr		: in  std_logic_vector (31 downto 0);  -- CPU side
    dMemDataRead	: out	std_logic_vector (31 downto 0);  -- CPU side
    dMemDataWrite	: in	std_logic_vector (31 downto 0);  -- CPU side

    adMemRead	: out std_logic;                       -- arbitrator side
    adMemWrite	: out std_logic;                       -- arbitrator side
    adMemWait	: in  std_logic;                       -- arbitrator side
    adMemAddr	: out std_logic_vector (31 downto 0);  -- arbitrator side
    adMemDataWrite	: out  std_logic_vector (31 downto 0);   -- arbitrator side
    adMemDataRead	: in  std_logic_vector (31 downto 0)   -- arbitrator side
	);
end dcache;

architecture struct of dcache is
	component dcache_ram
	port(
		CLK					:	in	std_logic;
		nReset			:	in	std_logic;
		WrEn				:	in	std_logic;
		Tag					:	in	std_logic_vector (24 downto 0);
		Index				:	in	std_logic_vector (03 downto 0);
		WordOffset : in std_logic;
		InputWord	:	in 	std_logic_vector (31 downto 0);
		InputWordOffset : in std_logic;
		MEM_memWrite : in std_logic;
		OutputWord	:	out std_logic_vector (31 downto 0);
		currentTag	:	out std_logic_vector (24 downto 0);
		Dirty				:	out	std_logic;
		Valid    : out std_logic;
		Hit					:	out	std_logic
  );
	end component;

	component dcache_ctrl
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
		WAY0_WriteEnable    : out std_logic;
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
	end component;

  component hitcounter
  port(
  	clk	:	in std_logic;	--just the clock
  	nReset	:	in std_logic;	--just the reset
  	we	:	in std_logic;	--write enable, if needed 
  	hit	:	in std_logic;	--feed a hit signal here
  	count	:	out std_logic_vector(31 downto 0); --the count
  	addr	:	out std_logic_vector(15 downto 0) --addr to write count		
  );
  end component;
  
	-- internal singals
	signal WAY0_tValid, WAY0_tWrEn, WAY0_tHit, WAY0_tDirty					: std_logic; 
	signal WAY1_tValid, WAY1_tWrEn, WAY1_tHit, WAY1_tDirty					: std_logic; 
	signal hit : std_logic;
	signal WAY0_readWord, WAY1_readWord		: std_logic_vector (31 downto 0);
	signal WAY0currentTag, WAY1currentTag		: std_logic_vector (24 downto 0);
  signal storeWordOffset : std_logic;
  signal dcache_WordToStore : std_logic_vector(31 downto 0);
  signal cacheIndex : std_logic_vector(3 downto 0);
  signal cacheWordOffset : std_logic;
  
  -- hit counter signals
  signal	hitCounterWriteEnable : std_logic;
  signal	newHitForHitCounter : std_logic;
  signal	hitCounterCount : std_logic_vector(31 downto 0);
  signal	hitCounterAddr : std_logic_vector(15 downto 0);
  	
begin
--  dMemWait       <= adMemWait;
--  adMemRead      <= dMemRead;
--  adMemWrite     <= dMemWrite;
--  adMemAddr      <= dMemAddr;
--  dMemDataRead   <= adMemDataRead;
--  adMemDataWrite <= dMemDataWrite;


	DCACHERAM_WAY0: dcache_ram port map(
		CLK,
		nReset,
		WAY0_tWrEn,
		dMemAddr (31 downto 7),		-- tag to look for
		cacheIndex,			-- set to look in
		cacheWordOffset,
		dcache_WordToStore,
		storeWordOffset,
		dmemWrite,
		WAY0_readWord,
		WAY0currentTag,
		WAY0_tDirty,
		WAY0_tValid,
		WAY0_tHit
  );
  
	DCACHERAM_WAY1: dcache_ram port map(
		CLK,
		nReset,
		WAY1_tWrEn,
		dMemAddr (31 downto 7),		-- tag to look for
		cacheIndex,			-- set to look in
		cacheWordOffset,
		dcache_WordToStore,
		storeWordOffset,
		dmemWrite,
		WAY1_readWord,
		WAY1currentTag,
		WAY1_tDirty,
		WAY1_tValid,
		WAY1_tHit
  );
 
	DCACHECTRL: dcache_ctrl port map(
   	CLK,
		nReset,
		
		Halt,
    donePooping,
		
		WAY0_tHit,
		WAY1_tHit,
		WAY0_tDirty,
		WAY1_tDirty,
		WAY0_tValid,
		WAY1_tValid,
		WAY0_tWrEn,
    WAY1_tWrEn,
    WAY0_readWord,
    WAY1_readWord,
    WAY0currentTag,
    WAY1currentTag,
    
		storeWordOffset,
		dcache_WordToStore,
		cacheIndex,
		cacheWordOffset,
		
		hitCounterWriteEnable,
		newHitForHitCounter,
		hitCounterCount,
		hitCounterAddr,
		
		dMemAddr,
		dMemDataWrite,
		dMemRead,
    dMemWrite,
    dMemWait,
    
		adMemRead,
		adMemWrite,
		adMemAddr,
		adMemDataWrite,
		adMemWait,
		adMemDataRead
	);
  
  hitCounterBlock : hitcounter
  port map(
  	CLK,
  	nReset,
  	hitCounterWriteEnable,
  	newHitForHitCounter,
  	hitCounterCount,
  	hitCounterAddr
  );
  
  hit <= WAY0_tHit or WAY1_tHit;		
	
	-- return word from block 
	dMemDataRead <= WAY0_readWord when (WAY0_tHit = '1') else WAY1_readWord when (WAY1_tHit = '1') else x"BAD2BAD2";

	-- on halt: flush the cache blocks that are dirty
	-- put that logic here

end struct;
