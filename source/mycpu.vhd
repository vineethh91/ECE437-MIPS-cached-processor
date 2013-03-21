LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity mycpu is
		port ( 
			-- clock signal
			CLK							:		in	std_logic;
			-- reset for processor
			nReset					:		in	std_logic;
			-- halt for processor
			halt						:		out	std_logic;
            ramAddr : out std_logic_vector(15 downto 0);
            ramData : out std_logic_vector(31 downto 0);
            ramWen  : out std_logic;
            ramRen  : out std_logic;
            ramQ    : in  std_logic_vector(31 downto 0);
            ramState : in std_logic_vector(1 downto 0)
		);
end mycpu;

architecture arch_mycpu of mycpu is

  --- CPU Staller ---
  component cpuStaller

   port ( 
    arbiterPipelineIFIDStall  : in std_logic;
    arbiterPipelineIDEXStall  : in std_logic;
    arbiterPipelineEXMEMStall : in std_logic;
    arbiterPipelineMEMWBStall : in std_logic;
    
    iMemWait : in std_logic;
    dMemWait : in std_logic;
    memState : in std_logic_vector(1 downto 0);

    hazardDetectionIFIDWriteEnable : in std_logic;
    hazardDetectionIDEXWriteEnable : in std_logic;
    hazardDetectionEXMEMWriteEnable : in std_logic;
    hazardDetectionMEMWBWriteEnable : in std_logic;

    hazardDetectionPCWriteEnable : in std_logic; 
    
    stallIFID  : out std_logic;
    stallIDEX  : out std_logic;
    stallEXMEM : out std_logic;
    stallMEMWB : out std_logic;
    stallPC    : out std_logic
	) ;
  end component;
  
  ------------------------ COMPONENTS FOR INSTRUCTION FETCH BLOCK -------------------------          
    
  component pcWriteEnableControl
  port(
    clk : in std_logic;
    rst_n : in std_logic;
    iMemWait: in std_logic;
    dMemWait: in std_logic;
    halt_flag : in std_logic;

    arbiterPCWE : in std_logic;
        
    dMemRead : in std_logic;
    dMemWrite : in std_logic;
    
    iMemRead : out std_logic;    
    halt_output_flag : out std_logic;
    pcWriteEnable: out std_logic
    );

  end component;
  
  component mux32Bit
  port ( 
        val0, val1: IN STD_LOGIC_VECTOR (31 downto 0);
        muxEnable: IN STD_LOGIC;
        muxOutput: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
  end component;
  
  component pcReg
  port(
       clk: in std_logic;
       rst_n: in std_logic;
       pcWriteEnable: in std_logic;
       nextPC: in std_logic_vector(31 downto 0);
       programCounter: out std_logic_vector(31 downto 0)
       );
  end component;
  
  component orer
    port ( 
        input1: IN STD_LOGIC;
        input2: IN STD_LOGIC;
        orOutput: OUT STD_LOGIC
        );
  end component;
  
  --------------------------- IF/ID PIPELINE REGISTER ----------------------------------------------
  component pipelineRegister_IF_ID
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;
    
    IF_instruction : in STD_LOGIC_VECTOR(31 downto 0);
    IF_programCounter : in STD_LOGIC_VECTOR(31 downto 0);
    
    ID_instruction : out STD_LOGIC_VECTOR(31 downto 0);
    ID_programCounter : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  

  --------------------------- COMPONENTS FOR INSTRUCTION DECODE BLOCK ------------------------------
  component controller
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
	);
  end component;
 
  component mux21BitTo21Bit
    port ( 
        muxEnable: IN STD_LOGIC;
          IDin_regDst: IN STD_LOGIC;
          IDin_extOp: IN STD_LOGIC;
          IDin_branch: IN STD_LOGIC;
          IDin_memRead: IN STD_LOGIC;
          IDin_memToReg: IN STD_LOGIC;
          IDin_ALUCtr: IN STD_LOGIC_VECTOR(3 downto 0);
          IDin_memWrite: IN STD_LOGIC;
          IDin_ALUSrc: IN STD_LOGIC;
          IDin_regWrite: IN STD_LOGIC;
          IDin_j_flag: IN STD_LOGIC;
          IDin_jal_flag: IN STD_LOGIC;
          IDin_jr_flag: IN STD_LOGIC;
          IDin_lui_flag: IN STD_LOGIC;
          IDin_slt_u_flag: IN STD_LOGIC;
          IDin_pc_write_enable: IN STD_LOGIC;
          IDin_bne_flag: IN STD_LOGIC;
          IDin_lw_flag: IN STD_LOGIC;
          IDin_halt_flag: IN STD_LOGIC;
          IDin_shamt_flag: IN STD_LOGIC;
          IDin_sign_flag: IN STD_LOGIC;

          
          IDout_regDst: out STD_LOGIC;
          IDout_extOp: out STD_LOGIC;
          IDout_branch: out STD_LOGIC;
          IDout_memRead: out STD_LOGIC;
          IDout_memToReg: out STD_LOGIC;
          IDout_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          IDout_memWrite: out STD_LOGIC;
          IDout_ALUSrc: out STD_LOGIC;
          IDout_regWrite: out STD_LOGIC;
          IDout_j_flag: out STD_LOGIC;
          IDout_jal_flag: out STD_LOGIC;
          IDout_jr_flag: out STD_LOGIC;
          IDout_lui_flag: out STD_LOGIC;
          IDout_slt_u_flag: out STD_LOGIC;
          IDout_pc_write_enable: out STD_LOGIC;
          IDout_bne_flag: out STD_LOGIC;
          IDout_lw_flag: out STD_LOGIC;
          IDout_halt_flag: out STD_LOGIC;
          IDout_shamt_flag: out STD_LOGIC;
          IDout_sign_flag: out STD_LOGIC

        );
  end component;

  component twoInputAdder
  port ( 
        val1, val2: IN STD_LOGIC_VECTOR (31 downto 0);
        addRes: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
  end component;

  component pcUpdate
  port ( 
        programCounter: IN STD_LOGIC_VECTOR (31 downto 0);
        jlabel: IN STD_LOGIC_VECTOR (25 downto 0);
        updatedPC: OUT STD_LOGIC_VECTOR(31 downto 0)
        );
  end component;

  component registerFile
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
  end component;
  
  component signExtender
    port ( 
        imm16: IN STD_LOGIC_VECTOR (15 downto 0);
        extOp: IN STD_LOGIC;
        signExtended: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
  end component;
  
  component luiShifter
    port ( 
        imm16: IN STD_LOGIC_VECTOR (15 downto 0);
        shiftedOut: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
  end component;

  --------------------------- ID/EX PIPELINE REGISTER ----------------------------------------------
  component pipelineRegister_ID_EX
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;
    
          ID_WB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          ID_M : IN STD_LOGIC;
          ID_EX : IN STD_LOGIC;

          ID_regDst: IN STD_LOGIC;
          ID_extOp: IN STD_LOGIC;
          ID_branch: IN STD_LOGIC;
          ID_memRead: IN STD_LOGIC;
          ID_memToReg: IN STD_LOGIC;
          ID_ALUCtr: IN STD_LOGIC_VECTOR(3 downto 0);
          ID_memWrite: IN STD_LOGIC;
          ID_ALUSrc: IN STD_LOGIC;
          ID_regWrite: IN STD_LOGIC;
          ID_j_flag: IN STD_LOGIC;
          ID_jal_flag: IN STD_LOGIC;
          ID_jr_flag: IN STD_LOGIC;
          ID_lui_flag: IN STD_LOGIC;
          ID_slt_u_flag: IN STD_LOGIC;
          ID_pc_write_enable: IN STD_LOGIC;
          ID_bne_flag: IN STD_LOGIC;
          ID_lw_flag: IN STD_LOGIC;
          ID_halt_flag: IN STD_LOGIC;
          ID_shamt_flag: IN STD_LOGIC;
          ID_sign_flag: IN STD_LOGIC;
          
          ID_instruction: in STD_LOGIC_VECTOR(31 downto 0);
          ID_Data1 : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_Data2 : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_luiShifted : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_nextPC : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_branchAddr : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_jumpAddr : IN STD_LOGIC_VECTOR(31 downto 0);
          
          EX_WB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          EX_M : OUT STD_LOGIC;
          EX_EX : OUT STD_LOGIC;
          
          EX_regDst: out STD_LOGIC;
          EX_extOp: out STD_LOGIC;
          EX_branch: out STD_LOGIC;
          EX_memRead: out STD_LOGIC;
          EX_memToReg: out STD_LOGIC;
          EX_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          EX_memWrite: out STD_LOGIC;
          EX_ALUSrc: out STD_LOGIC;
          EX_regWrite: out STD_LOGIC;
          EX_j_flag: out STD_LOGIC;
          EX_jal_flag: out STD_LOGIC;
          EX_jr_flag: out STD_LOGIC;
          EX_lui_flag: out STD_LOGIC;
          EX_slt_u_flag: out STD_LOGIC;
          EX_pc_write_enable: out STD_LOGIC;
          EX_bne_flag: out STD_LOGIC;
          EX_lw_flag: out STD_LOGIC;
          EX_halt_flag: out STD_LOGIC;
          EX_shamt_flag: OUT STD_LOGIC;
          EX_sign_flag: out STD_LOGIC;

          EX_instruction: OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_Data1 : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_Data2 : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_luiShifted : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_nextPC : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_branchAddr : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_jumpAddr : OUT STD_LOGIC_VECTOR(31 downto 0)	
    );

  end component;


  component hazardDetectionUnit
  port(
      EX_Rt : in std_logic_vector(4 downto 0);
      ID_Rs : in std_logic_vector(4 downto 0);
      ID_Rt : in std_logic_vector(4 downto 0);
      EX_memRead : in std_logic;
      
      IFID_writeEnable : out std_logic;
      IDEX_writeEnable : out std_logic;
      EXMEM_writeEnable : out std_logic;
      MEMWB_writeEnable : out std_logic;     -- to the pipeline registers

      pcWriteEnable : out std_logic;         -- go straight to the pcWriteEnableControl block, add code there to handle this case
      disableControlSignals : out std_logic  -- add code in controller.vhd to zero everything out if this is high
    );

  end component;
  
  --------------------------- COMPONENTS FOR THE EXECUTE BLOCK -----------------------------

  component alu
    port ( 
        opcode: IN STD_LOGIC_VECTOR (3 downto 0);
        A, B: IN STD_LOGIC_VECTOR (31 downto 0);
        signFlag: IN STD_LOGIC;
        aluout: OUT STD_LOGIC_VECTOR (31 downto 0);
        negative: OUT STD_LOGIC;
        overflow, zero: OUT STD_LOGIC);
  end component;

  component mux32BitThreeToOne
    port ( 
        val0, val1, val2: IN STD_LOGIC_VECTOR (31 downto 0);
        muxEnable: IN STD_LOGIC_VECTOR(1 downto 0);
        muxOutput: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
  end component;
    
  component mux5Bit
  port ( 
        val0, val1: IN STD_LOGIC_VECTOR (4 downto 0);
        muxEnable: IN STD_LOGIC;
        muxOutput: OUT STD_LOGIC_VECTOR (4 downto 0)
        );
  end component;
  
  component mux1Bit
  port ( 
        val0, val1: IN STD_LOGIC;
        muxEnable: IN STD_LOGIC;
        muxOutput: OUT STD_LOGIC
        );
  end component;

  --------------------------- EX/MEM PIPELINE REGISTER ----------------------------------------------
  component pipelineRegister_EX_MEM
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;
 
          EX_WB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          EX_M : IN STD_LOGIC;

          EX_regDst: IN STD_LOGIC;
          EX_extOp: IN STD_LOGIC;
          EX_branch: IN STD_LOGIC;
          EX_memRead: IN STD_LOGIC;
          EX_memToReg: IN STD_LOGIC;
          EX_ALUCtr: IN STD_LOGIC_VECTOR(3 downto 0);
          EX_memWrite: IN STD_LOGIC;
          EX_ALUSrc: IN STD_LOGIC;
          EX_regWrite: IN STD_LOGIC;
          EX_j_flag: IN STD_LOGIC;
          EX_jal_flag: IN STD_LOGIC;
          EX_jr_flag: IN STD_LOGIC;
          EX_lui_flag: IN STD_LOGIC;
          EX_slt_u_flag: IN STD_LOGIC;
          EX_pc_write_enable: IN STD_LOGIC;
          EX_bne_flag: IN STD_LOGIC;
          EX_lw_flag: IN STD_LOGIC;
          EX_halt_flag: IN STD_LOGIC;
          EX_shamt_flag: IN STD_LOGIC;
          EX_sign_flag: IN STD_LOGIC;
          
          EX_instruction: in STD_LOGIC_VECTOR(31 downto 0);
          EX_Data1 : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_Data2 : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_luiShifted : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_nextPC : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_branchAddr : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_jumpAddr : IN STD_LOGIC_VECTOR(31 downto 0);

          EX_zeroFlagMuxed : IN STD_LOGIC;
          EX_negativeFlag : IN STD_LOGIC;
          EX_ALURes : IN STD_LOGIC_VECTOR(31 downto 0);

          EX_jalFlagMuxOutput : IN STD_LOGIC_VECTOR(4 downto 0);
                  
          MEM_WB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          MEM_M : OUT STD_LOGIC;
          
          MEM_regDst: out STD_LOGIC;
          MEM_extOp: out STD_LOGIC;
          MEM_branch: out STD_LOGIC;
          MEM_memRead: out STD_LOGIC;
          MEM_memToReg: out STD_LOGIC;
          MEM_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          MEM_memWrite: out STD_LOGIC;
          MEM_ALUSrc: out STD_LOGIC;
          MEM_regWrite: out STD_LOGIC;
          MEM_j_flag: out STD_LOGIC;
          MEM_jal_flag: out STD_LOGIC;
          MEM_jr_flag: out STD_LOGIC;
          MEM_lui_flag: out STD_LOGIC;
       	  MEM_slt_u_flag: out STD_LOGIC;
       	  MEM_pc_write_enable: out STD_LOGIC;
       	  MEM_bne_flag: out STD_LOGIC;
       	  MEM_lw_flag: out STD_LOGIC;
       	  MEM_halt_flag: out STD_LOGIC;
       	  MEM_shamt_flag: out STD_LOGIC;
       	  MEM_sign_flag: out STD_LOGIC;

          MEM_instruction: OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_Data1 : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_Data2 : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_luiShifted : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_nextPC : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_branchAddr : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_jumpAddr : OUT STD_LOGIC_VECTOR(31 downto 0);	

          MEM_zeroFlagMuxed : OUT STD_LOGIC;
          MEM_negativeFlag : OUT STD_LOGIC;
          MEM_ALURes : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_jalFlagMuxOutput : OUT STD_LOGIC_VECTOR(4 downto 0)
    );

  end component;
  
    
  component forwardingUnit is
  port(
    MEM_regWrite : in std_logic;
    WB_regWrite : in std_logic;
    EX_memRead : in std_logic;
    MEM_registerBeingWrittenTo : in std_logic_vector(4 downto 0);
    WB_registerBeingWrittenTo : in std_logic_vector(4 downto 0);
    EX_Rs : in std_logic_vector(4 downto 0);
    EX_Rt : in std_logic_vector(4 downto 0);
    ALUSrc : in std_logic;
    
    MUXA_enable : out std_logic_vector(1 downto 0);
    MUXB_enable : out std_logic_vector(1 downto 0);
    MUXC_enable : out std_logic_vector(1 downto 0);
    MUXD_enable : out std_logic_vector(1 downto 0)
    );
  end component;

  --------------------------- COMPONENTS FOR THE MEMORY BLOCK -----------------------------
 component ander
    port ( 
        input1: IN STD_LOGIC;
        input2: IN STD_LOGIC;
        andOutput: OUT STD_LOGIC
        );
  end component;

  --------------------------- MEM/WB PIPELINE REGISTER ----------------------------------------------
  component pipelineRegister_MEM_WB
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;


          MEM_WB : in STD_LOGIC_VECTOR(1 DOWNTO 0);
          
          MEM_regDst: in STD_LOGIC;
          MEM_extOp: in STD_LOGIC;
          MEM_branch: in STD_LOGIC;
          MEM_memRead: in STD_LOGIC;
          MEM_memToReg: in STD_LOGIC;
          MEM_ALUCtr: in STD_LOGIC_VECTOR(3 downto 0);
          MEM_memWrite: in STD_LOGIC;
          MEM_ALUSrc: in STD_LOGIC;
          MEM_regWrite: in STD_LOGIC;
          MEM_j_flag: in STD_LOGIC;
          MEM_jal_flag: in STD_LOGIC;
          MEM_jr_flag: in STD_LOGIC;
          MEM_lui_flag: in STD_LOGIC;
	  MEM_slt_u_flag: in STD_LOGIC;
	  MEM_pc_write_enable: in STD_LOGIC;
	  MEM_bne_flag: in STD_LOGIC;
	  MEM_lw_flag: in STD_LOGIC;
	  MEM_halt_flag: in STD_LOGIC;
	  MEM_shamt_flag: in STD_LOGIC;
	  MEM_sign_flag: in STD_LOGIC;

          MEM_luiShifted : in STD_LOGIC_VECTOR(31 downto 0);
          MEM_nextPC : in STD_LOGIC_VECTOR(31 downto 0);

          MEM_negativeFlag : in STD_LOGIC;
          MEM_ALURes : in STD_LOGIC_VECTOR(31 downto 0);

          MEM_readData : in STD_LOGIC_VECTOR(31 downto 0);

         MEM_jalFlagMuxOutput : IN STD_LOGIC_VECTOR(4 downto 0);
         
          WB_WB : out STD_LOGIC_VECTOR(1 DOWNTO 0);
          
          WB_regDst: out STD_LOGIC;
          WB_extOp: out STD_LOGIC;
          WB_branch: out STD_LOGIC;
          WB_memRead: out STD_LOGIC;
          WB_memToReg: out STD_LOGIC;
          WB_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          WB_memWrite: out STD_LOGIC;
          WB_ALUSrc: out STD_LOGIC;
          WB_regWrite: out STD_LOGIC;
          WB_j_flag: out STD_LOGIC;
          WB_jal_flag: out STD_LOGIC;
          WB_jr_flag: out STD_LOGIC;
          WB_lui_flag: out STD_LOGIC;
	  WB_slt_u_flag: out STD_LOGIC;
	  WB_pc_write_enable: out STD_LOGIC;
	  WB_bne_flag: out STD_LOGIC;
	  WB_lw_flag: out STD_LOGIC;
	  WB_halt_flag: out STD_LOGIC;
	  WB_shamt_flag: out STD_LOGIC;
	  WB_sign_flag: out STD_LOGIC;

          WB_luiShifted : out STD_LOGIC_VECTOR(31 downto 0);
          WB_nextPC : out STD_LOGIC_VECTOR(31 downto 0);

          WB_negativeFlag : out STD_LOGIC;
          WB_ALURes : out STD_LOGIC_VECTOR(31 downto 0);

          WB_readData : out STD_LOGIC_VECTOR(31 downto 0);
          WB_jalFlagMuxOutput : OUT STD_LOGIC_VECTOR(4 downto 0)
    );

  end component;  
  
  component icache
  port(
    clk       : in  std_logic;
    nReset    : in  std_logic;

    iMemRead  : in  std_logic;                       -- CPU side
    iMemWait  : out std_logic;                       -- CPU side
    iMemAddr  : in  std_logic_vector (31 downto 0);  -- CPU side
    iMemData  : out std_logic_vector (31 downto 0);  -- CPU side

    aiMemWait : in  std_logic;                       -- arbitrator side
    aiMemRead : out std_logic;                       -- arbitrator side
    aiMemAddr : out std_logic_vector (31 downto 0);  -- arbitrator side
    aiMemData : in  std_logic_vector (31 downto 0)   -- arbitrator side
    );
  end component;
  
  component dcache
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
  end component;
  
  component memoryArbiter
  port(
    clk : in std_logic;
    rst_n : in std_logic;
    
    pipelineIFIDStall : out std_logic;
    pipelineIDEXStall : out std_logic;
    pipelineEXMEMStall : out std_logic;
    pipelineMEMWBStall : out std_logic;
    pcEnable : out std_logic;
    aiMemWait : out  std_logic;                       -- arbitrator side
    aiMemRead : in std_logic;                       -- arbitrator side
    aiMemAddr : in std_logic_vector (31 downto 0);  -- arbitrator side
    aiMemData : out  std_logic_vector (31 downto 0);   -- arbitrator side


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
  end component; 

  
----------------------- IF generated signals -----------------
  signal IFSignal_pcSrcMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal IFSignal_instruction : STD_LOGIC_VECTOR(31 downto 0);
  signal IFSignal_jjalOrResult  : STD_LOGIC;
  signal IFSignal_jjalMuxOutput  : STD_LOGIC_VECTOR(31 downto 0);
  signal IFSignal_jrFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal IFSignal_currProgramCounter : STD_LOGIC_VECTOR(31 downto 0);
  signal IFSignal_pcWriteEnableControlEnable : STD_LOGIC;
  signal IFSignal_pcWriteEnable : STD_LOGIC; 
  signal IFSignal_iMemRead, IFSignal_iMemWait : STD_LOGIC;
  signal IFSignal_nextPC : STD_LOGIC_VECTOR(31 downto 0);
  
  ------------ Write Enable and reset ----------
  signal IFIDWriteEnable : std_logic;
  signal IFID_nReset : std_logic;
   
----------------------- ID generated signals -----------------
  signal IDSignal_regDst: STD_LOGIC;
  signal IDSignal_extOp: STD_LOGIC;
  signal IDSignal_branch: STD_LOGIC;
  signal IDSignal_memRead: STD_LOGIC;
  signal IDSignal_memToReg: STD_LOGIC;
  signal IDSignal_ALUCtr: STD_LOGIC_VECTOR(3 downto 0);
  signal IDSignal_memWrite: STD_LOGIC;
  signal IDSignal_ALUSrc: STD_LOGIC;
  signal IDSignal_regWrite: STD_LOGIC;
  signal IDSignal_j_flag: STD_LOGIC;
  signal IDSignal_jal_flag: STD_LOGIC;
  signal IDSignal_jr_flag: STD_LOGIC;
  signal IDSignal_lui_flag: STD_LOGIC;
  signal IDSignal_slt_u_flag: STD_LOGIC;
  signal IDSignal_pc_write_enable: STD_LOGIC;
  signal IDSignal_bne_flag: STD_LOGIC;
  signal IDSignal_lw_flag: STD_LOGIC;
  signal IDSignal_halt_flag: STD_LOGIC;
  signal IDSignal_shamt_flag: STD_LOGIC;
  signal IDSignal_sign_flag: STD_LOGIC;

  signal IDSignal_instruction: STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_Data1 : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_Data2 : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_luiShifted : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_nextPC : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_branchAddr : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_jumpAddr : STD_LOGIC_VECTOR(31 downto 0);

  signal IDSignal_currProgramCounter : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_imm16PCExtendedShiftedBy2 : STD_LOGIC_VECTOR(31 downto 0);
  signal IDSignal_imm16PCExtended : STD_LOGIC_VECTOR(31 downto 0);
  
  signal IDSignal_WB : STD_LOGIC_VECTOR(1 downto 0);
  signal IDSignal_M : STD_LOGIC;
  signal IDSignal_EX : STD_LOGIC;
  
  
  signal IDinSignal_regDst: STD_LOGIC;
  signal IDinSignal_extOp: STD_LOGIC;
  signal IDinSignal_branch: STD_LOGIC;
  signal IDinSignal_memRead: STD_LOGIC;
  signal IDinSignal_memToReg: STD_LOGIC;
  signal IDinSignal_ALUCtr: STD_LOGIC_VECTOR(3 downto 0);
  signal IDinSignal_memWrite: STD_LOGIC;
  signal IDinSignal_ALUSrc: STD_LOGIC;
  signal IDinSignal_regWrite: STD_LOGIC;
  signal IDinSignal_j_flag: STD_LOGIC;
  signal IDinSignal_jal_flag: STD_LOGIC;
  signal IDinSignal_jr_flag: STD_LOGIC;
  signal IDinSignal_lui_flag: STD_LOGIC;
  signal IDinSignal_slt_u_flag: STD_LOGIC;
  signal IDinSignal_pc_write_enable: STD_LOGIC;
  signal IDinSignal_bne_flag: STD_LOGIC;
  signal IDinSignal_lw_flag: STD_LOGIC;
  signal IDinSignal_halt_flag: STD_LOGIC;
  signal IDinSignal_shamt_flag: STD_LOGIC;
  signal IDinSignal_sign_flag: STD_LOGIC;
  
  signal IDoutSignal_regDst: STD_LOGIC;
  signal IDoutSignal_extOp: STD_LOGIC;
  signal IDoutSignal_branch: STD_LOGIC;
  signal IDoutSignal_memRead: STD_LOGIC;
  signal IDoutSignal_memToReg: STD_LOGIC;
  signal IDoutSignal_ALUCtr: STD_LOGIC_VECTOR(3 downto 0);
  signal IDoutSignal_memWrite: STD_LOGIC;
  signal IDoutSignal_ALUSrc: STD_LOGIC;
  signal IDoutSignal_regWrite: STD_LOGIC;
  signal IDoutSignal_j_flag: STD_LOGIC;
  signal IDoutSignal_jal_flag: STD_LOGIC;
  signal IDoutSignal_jr_flag: STD_LOGIC;
  signal IDoutSignal_lui_flag: STD_LOGIC;
  signal IDoutSignal_slt_u_flag: STD_LOGIC;
  signal IDoutSignal_pc_write_enable: STD_LOGIC;
  signal IDoutSignal_bne_flag: STD_LOGIC;
  signal IDoutSignal_lw_flag: STD_LOGIC;
  signal IDoutSignal_halt_flag: STD_LOGIC;
  signal IDoutSignal_shamt_flag: STD_LOGIC;
  signal IDoutSignal_sign_flag: STD_LOGIC;

  --- IDEX signals ---
  signal IDEXWriteEnable : std_logic;
  signal IDEX_nReset : std_logic;
  
----------------------- EX generated signals -----------------
  signal EXSignal_regDst: STD_LOGIC;
  signal EXSignal_extOp: STD_LOGIC;
  signal EXSignal_branch: STD_LOGIC;
  signal EXSignal_memRead: STD_LOGIC;
  signal EXSignal_memToReg: STD_LOGIC;
  signal EXSignal_ALUCtr: STD_LOGIC_VECTOR(3 downto 0);
  signal EXSignal_memWrite: STD_LOGIC;
  signal EXSignal_ALUSrc: STD_LOGIC;
  signal EXSignal_regWrite: STD_LOGIC;
  signal EXSignal_j_flag: STD_LOGIC;
  signal EXSignal_jal_flag: STD_LOGIC;
  signal EXSignal_jr_flag: STD_LOGIC;
  signal EXSignal_lui_flag: STD_LOGIC;
  signal EXSignal_slt_u_flag: STD_LOGIC;
  signal EXSignal_pc_write_enable: STD_LOGIC;
  signal EXSignal_bne_flag: STD_LOGIC;
  signal EXSignal_lw_flag: STD_LOGIC;
  signal EXSignal_halt_flag: STD_LOGIC;
  signal EXSignal_shamt_flag: STD_LOGIC;
  signal EXSignal_sign_flag: STD_LOGIC;

  signal EXSignal_instruction: STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_Data1 : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_Data2 : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_luiShifted : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_nextPC : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_branchAddr : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_jumpAddr : STD_LOGIC_VECTOR(31 downto 0);
  
  signal EXSignal_imm16_signEx  : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_ShamtFlagMuxOutput  : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_shamtExtended  : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_ALUDataSrc  : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_negative_flag : STD_LOGIC;
  signal EXSignal_zero_flag : STD_LOGIC;
  signal EXSignal_regDstMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
  signal EXSignal_Mux_A  : STD_LOGIC_VECTOR(1 downto 0);
  signal EXSignal_Mux_B  : STD_LOGIC_VECTOR(1 downto 0);

  signal EXSignal_WB : STD_LOGIC_VECTOR(1 downto 0);
  signal EXSignal_M : STD_LOGIC;
  signal EXSignal_EX : STD_LOGIC;
  
  signal EXSignal_jalFlagMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
  signal EXSignal_InputAThreeToOneMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_InputBThreeToOneMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_ALUSrcMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  
  signal EXSignal_ALURes : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_zeroAndInvertedZeroMuxOutput : STD_LOGIC;
  signal EXSignal_zeroFlagInverted : STD_LOGIC;
  
  signal EXSignal_luiFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_extendedAluNegativeFlag : STD_LOGIC_VECTOR(31 downto 0); 
  signal EXSignal_sltuFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);        

  signal EXSignal_Data2ThreeToOneMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal EXSignal_Data1ThreeToOneMuxOutput : STD_LOGIC_VECTOR(31 downto 0); 
  
  signal EXMEMWriteEnable : std_logic; 
----------------------- MEM generated signals -----------------
  signal MEMSignal_regDst: STD_LOGIC;
  signal MEMSignal_extOp: STD_LOGIC;
  signal MEMSignal_branch: STD_LOGIC;
  signal MEMSignal_memRead: STD_LOGIC;
  signal MEMSignal_memToReg: STD_LOGIC;
  signal MEMSignal_ALUCtr: STD_LOGIC_VECTOR(3 downto 0);
  signal MEMSignal_memWrite: STD_LOGIC;
  signal MEMSignal_ALUSrc: STD_LOGIC;
  signal MEMSignal_regWrite: STD_LOGIC;
  signal MEMSignal_j_flag: STD_LOGIC;
  signal MEMSignal_jal_flag: STD_LOGIC;
  signal MEMSignal_jr_flag: STD_LOGIC;
  signal MEMSignal_lui_flag: STD_LOGIC;
  signal MEMSignal_slt_u_flag: STD_LOGIC;
  signal MEMSignal_pc_write_enable: STD_LOGIC;
  signal MEMSignal_bne_flag: STD_LOGIC;
  signal MEMSignal_lw_flag: STD_LOGIC;
  signal MEMSignal_halt_flag: STD_LOGIC;
  signal MEMSignal_shamt_flag: STD_LOGIC;
  signal MEMSignal_sign_flag: STD_LOGIC;

  signal MEMSignal_instruction: STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_Data1 : STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_Data2 : STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_luiShifted : STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_nextPC : STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_branchAddr : STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_jumpAddr : STD_LOGIC_VECTOR(31 downto 0);
  signal MEMSignal_branchFlagZeroFlagAnded : STD_LOGIC;
  signal MEMSignal_ALURes : STD_LOGIC_VECTOR(31 downto 0);
  
  signal MEMSignal_WB : STD_LOGIC_VECTOR(1 downto 0);
  signal MEMSignal_M : STD_LOGIC;
  signal MEMSignal_zeroFlagMuxed : STD_LOGIC;
  signal MEMSignal_negativeFlag : STD_LOGIC;
  signal MEMSignal_readData : STD_LOGIC_VECTOR(31 downto 0);
  
  signal MEMSignal_jalFlagMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
  signal MEMSignal_dMemWait : STD_LOGIC;
  -- write enable
  signal MEMWBWriteEnable : std_logic; 
----------------------- WB generated signals -----------------
  signal WBSignal_regDst: STD_LOGIC;
  signal WBSignal_extOp: STD_LOGIC;
  signal WBSignal_branch: STD_LOGIC;
  signal WBSignal_memRead: STD_LOGIC;
  signal WBSignal_memToReg: STD_LOGIC;
  signal WBSignal_ALUCtr: STD_LOGIC_VECTOR(3 downto 0);
  signal WBSignal_memWrite: STD_LOGIC;
  signal WBSignal_ALUSrc: STD_LOGIC;
  signal WBSignal_regWrite: STD_LOGIC;
  signal WBSignal_j_flag: STD_LOGIC;
  signal WBSignal_jal_flag: STD_LOGIC;
  signal WBSignal_jr_flag: STD_LOGIC;
  signal WBSignal_lui_flag: STD_LOGIC;
  signal WBSignal_slt_u_flag: STD_LOGIC;
  signal WBSignal_pc_write_enable: STD_LOGIC;
  signal WBSignal_bne_flag: STD_LOGIC;
  signal WBSignal_lw_flag: STD_LOGIC;
  signal WBSignal_halt_flag: STD_LOGIC;
  signal WBSignal_shamt_flag: STD_LOGIC;
  signal WBSignal_sign_flag: STD_LOGIC;

  signal WBSignal_Data2 : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_luiShifted : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_nextPC : STD_LOGIC_VECTOR(31 downto 0);

  signal WBSignal_WB : STD_LOGIC_VECTOR(1 downto 0);
  signal WBSignal_M : STD_LOGIC;

  signal WBSignal_jalFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_memToRegMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_luiFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_extendedAluNegativeFlag : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_sltuFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_negativeFlag : STD_LOGIC;
  signal WBSignal_ALURes : STD_LOGIC_VECTOR(31 downto 0);
  signal WBSignal_readData : STD_LOGIC_VECTOR(31 downto 0);
  
  signal WBSignal_jalFlagRegisterWriteLocationOutput : STD_LOGIC_VECTOR(4 downto 0);
  ------ CACHES------------------
  
  -- icache
  signal iCacheArbiter_aiMemWait : STD_LOGIC;                      -- arbitrator side
  signal iCacheArbiter_aiMemRead : STD_LOGIC;                       -- arbitrator side
  signal iCacheArbiter_aiMemAddr : STD_LOGIC_VECTOR(31 downto 0);  -- arbitrator side
  signal iCacheArbiter_aiMemData : STD_LOGIC_VECTOR(31 downto 0);   -- arbitrator side

  -- dcache
  signal dCacheArbiter_adMemRead : STD_LOGIC;                     -- arbitrator side
  signal dCacheArbiter_adMemWrite : STD_LOGIC;                       -- arbitrator side
  signal dCacheArbiter_adMemWait : STD_LOGIC;                   -- arbitrator side
  signal dCacheArbiter_adMemAddr  : STD_LOGIC_VECTOR(31 downto 0); -- arbitrator side
  signal dCacheArbiter_adMemDataRead  : STD_LOGIC_VECTOR(31 downto 0);  -- arbitrator side
  signal dCacheArbiter_adMemDataWrite  : STD_LOGIC_VECTOR(31 downto 0);  -- arbitrator side  
  signal memoryDumpFinishedSignal : STD_LOGIC;
  
  ------ arbiter to RAM signals 
  signal arbiterRamSignal_address : STD_LOGIC_VECTOR(15 downto 0);
  signal arbiterRamSignal_data  : STD_LOGIC_VECTOR(31 downto 0);
  signal arbiterRamSignal_wren : STD_LOGIC;
  signal arbiterRamSignal_rden : STD_LOGIC;
  signal arbiterRamSignal_latency_override : STD_LOGIC;
  signal arbiterRamSignal_q : STD_LOGIC_VECTOR(31 downto 0);
  signal arbiterRamSignal_memstate : STD_LOGIC_VECTOR(1 downto 0);
  
  ---- pipeline write enables----
  signal pipelineIFIDWriteEnable : std_logic;
  signal pipelineIDEXWriteEnable : std_logic;
  signal pipelineEXMEMWriteEnable : std_logic;
  signal pipelineMEMWBWriteEnable : std_logic;
  signal arbiterPCEnableSignal : std_logic;
  ----- Master halt flag --------
  signal masterHaltSignal : std_logic;
  
  ----- forwarding unit mux enable signals ---------------
  signal MuxAEnableSignal : std_logic_vector(1 downto 0);
  signal MuxBEnableSignal : std_logic_vector(1 downto 0);
  signal MuxCEnableSignal : std_logic_vector(1 downto 0);
  signal MuxDEnableSignal : std_logic_vector(1 downto 0);
  ----- hazard Detection block signals --------------------
  signal hazardDetection_IFIDWriteEnable : STD_LOGIC;
  signal hazardDetection_IDEXWriteEnable : STD_LOGIC;
  signal hazardDetection_EXMEMWriteEnable : STD_LOGIC;
  signal hazardDetection_MEMWBWriteEnable : STD_LOGIC;
  signal hazardDetection_IDEXnReset : STD_LOGIC;
  signal hazardDetectionPCWriteEnable : STD_LOGIC;
  signal hazardDetectionMux21to21Enable : STD_LOGIC;

begin
  
   
   --- CPU Staller ---
  cpuStallerBlock: cpuStaller
   port map( 
    arbiterPipelineIFIDStall  => pipelineIFIDWriteEnable,
    arbiterPipelineIDEXStall  => pipelineIDEXWriteEnable,
    arbiterPipelineEXMEMStall => pipelineEXMEMWriteEnable,
    arbiterPipelineMEMWBStall => pipelineMEMWBWriteEnable,
    
    iMemWait => IFSignal_iMemWait,
    dMemWait => MEMSignal_dMemWait,
    memState => arbiterRamSignal_memstate,

    hazardDetectionIFIDWriteEnable => hazardDetection_IFIDWriteEnable,
    hazardDetectionIDEXWriteEnable => hazardDetection_IDEXWriteEnable,
    hazardDetectionEXMEMWriteEnable => hazardDetection_EXMEMWriteEnable,
    hazardDetectionMEMWBWriteEnable => hazardDetection_MEMWBWriteEnable,

    hazardDetectionPCWriteEnable => hazardDetectionPCWriteEnable,
    
    stallIFID  => IFIDWriteEnable,
    stallIDEX  => IDEXWriteEnable,
    stallEXMEM => EXMEMWriteEnable,
    stallMEMWB => MEMWBWriteEnable,
    stallPC    => open
	) ;
  
   ----------------- START OF INSTRUCTION FETCH STAGE ----------------------- 
   
   pcWEBlock: pcWriteEnableControl
    port map(
    clk  => CLK,
    rst_n => nReset,
    iMemWait => IFSignal_iMemWait,
    dMemWait => MEMSignal_dMemWait,
    halt_flag => MEMSignal_halt_flag,

    arbiterPCWE => arbiterPCEnableSignal,
    
    dMemRead => MEMSignal_memRead,
    dMemWrite => MEMSignal_memWrite,
    
    iMemRead => open,--IFSignal_iMemRead,
    halt_output_flag => masterHaltSignal,
    pcWriteEnable => IFSignal_pcWriteEnableControlEnable
    );
      
    
   IFStagecurrPCAddBy4 : twoInputAdder
   port map( 
        val1    => IFSignal_currProgramCounter,
        val2    => x"00000004",
        addRes  => IFSignal_nextPC
        ); 

   pcSrcMux : mux32Bit
   port map( 
        val0       => IFSignal_nextPC,
        val1       => MEMSignal_branchAddr,
        muxEnable  => MEMSignal_branchFlagZeroFlagAnded,
        muxOutput  => IFSignal_pcSrcMuxOutput
        );

   JJALOrer : orer
   port map( 
        input1    => MEMSignal_j_flag,
        input2    => MEMSignal_jal_flag,
        orOutput  => IFSignal_jjalOrResult
        );  

   JJALFlagPCMux : mux32Bit
   port map( 
        val0       => IFSignal_pcSrcMuxOutput,
        val1       => MEMSignal_jumpAddr,
        muxEnable  => IFSignal_jjalOrResult,
        muxOutput  => IFSignal_jjalMuxOutput
        );
      
        
   jrFlagMux :  mux32Bit
   port map( 
        val0       => IFSignal_jjalMuxOutput,
        val1       => MEMSignal_Data1,
        muxEnable  => MEMSignal_jr_flag,
        muxOutput  => IFSignal_jrFlagMuxOutput
        ); 
   
   IFSignal_pcWriteEnable <= hazardDetectionPCWriteEnable and IFSignal_pcWriteEnableControlEnable;
    
   pcRegBlock : pcReg
   port map(
       clk             => CLK,
       rst_n           => nReset,
       pcWriteEnable   => IFSignal_pcWriteEnable,--IFSignal_pcWriteEnable,   ---------- needs to be connected to pcWriteEnableControl block!!!!
       nextPC          => IFSignal_jrFlagMuxOutput,
       programCounter  => IFSignal_currProgramCounter
       );

-------------- END OF INSTRUCTION FETCH STAGE ---------------------------------------

  --IFIDWriteEnable <= hazardDetection_IFIDWriteEnable and pipelineIFIDWriteEnable;
  
  IFID_nReset <= nReset and (not MEMSignal_branchFlagZeroFlagAnded) and (not MEMSignal_j_flag) and (not MEMSignal_jal_flag) and (not MEMSignal_jr_flag) and (not masterHaltSignal);
  --------------------------- IF/ID PIPELINE REGISTER ----------------------------------------------
  IFIDpipeline : pipelineRegister_IF_ID
  port map(
    clk                => CLK,
    rst_n              => IFID_nReset,
    regWriteEnable     => IFIDWriteEnable,
    
    IF_instruction     => IFSignal_instruction,
    IF_programCounter  => IFSignal_currProgramCounter,
    
    ID_instruction     => IDSignal_instruction,
    ID_programCounter  => IDSignal_currProgramCounter
    );

---------- START OF INSTRUCTION DECODE STAGE ----------------------------------------
  controllerBlock : controller
  port map( 
          opcode           => IDSignal_instruction(31 downto 26),
          function_code    => IDSignal_instruction(5 downto 0),

          regDst           => IDSignal_regDst,
          extOp            => IDSignal_extOp,
          branch           => IDSignal_branch,
          memRead          => IDSignal_memRead,
          memToReg         => IDSignal_memToReg,
          ALUCtr           => IDSignal_ALUCtr,
          memWrite         => IDSignal_memWrite,
          ALUSrc           => IDSignal_ALUSrc,
          regWrite         => IDSignal_regWrite,
          j_flag           => IDSignal_j_flag,
          jal_flag         => IDSignal_jal_flag,
          jr_flag          => IDSignal_jr_flag,
          lui_flag         => IDSignal_lui_flag,
          slt_u_flag       => IDSignal_slt_u_flag,
          pc_write_enable  => IDSignal_pc_write_enable,
          bne_flag         => IDSignal_bne_flag,
          lw_flag          => IDSignal_lw_flag,
          halt_flag        => IDSignal_halt_flag,
          shamt_flag       => IDSignal_shamt_flag,
          sign_flag        => IDSignal_sign_flag
	);
	
	mux21BitTo21BitBlock : mux21BitTo21Bit
    port map( 
        muxEnable => hazardDetectionMux21to21Enable,
          IDin_regDst => IDSignal_regDst,
          IDin_extOp => IDSignal_extOp,
          IDin_branch => IDSignal_branch,
          IDin_memRead => IDSignal_memRead,
          IDin_memToReg => IDSignal_memToReg,
          IDin_ALUCtr => IDSignal_ALUCtr,
          IDin_memWrite => IDSignal_memWrite,
          IDin_ALUSrc => IDSignal_ALUSrc,
          IDin_regWrite => IDSignal_regWrite,
          IDin_j_flag => IDSignal_j_flag,
          IDin_jal_flag => IDSignal_jal_flag,
          IDin_jr_flag => IDSignal_jr_flag,
          IDin_lui_flag => IDSignal_lui_flag,
          IDin_slt_u_flag => IDSignal_slt_u_flag,
          IDin_pc_write_enable => IDSignal_pc_write_enable,
          IDin_bne_flag => IDSignal_bne_flag,
          IDin_lw_flag => IDSignal_lw_flag,
          IDin_halt_flag => IDSignal_halt_flag,
          IDin_shamt_flag => IDSignal_shamt_flag,
          IDin_sign_flag => IDSignal_sign_flag,

          
          IDout_regDst => IDoutSignal_regDst,
          IDout_extOp => IDoutSignal_extOp,
          IDout_branch => IDoutSignal_branch,
          IDout_memRead => IDoutSignal_memRead,
          IDout_memToReg => IDoutSignal_memToReg,
          IDout_ALUCtr => IDoutSignal_ALUCtr,
          IDout_memWrite => IDoutSignal_memWrite,
          IDout_ALUSrc => IDoutSignal_ALUSrc,
          IDout_regWrite => IDoutSignal_regWrite,
          IDout_j_flag => IDoutSignal_j_flag,
          IDout_jal_flag => IDoutSignal_jal_flag,
          IDout_jr_flag => IDoutSignal_jr_flag,
          IDout_lui_flag => IDoutSignal_lui_flag,
          IDout_slt_u_flag => IDoutSignal_slt_u_flag,
          IDout_pc_write_enable => IDoutSignal_pc_write_enable,
          IDout_bne_flag => IDoutSignal_bne_flag,
          IDout_lw_flag => IDoutSignal_lw_flag,
          IDout_halt_flag => IDoutSignal_halt_flag,
          IDout_shamt_flag => IDoutSignal_shamt_flag,
          IDout_sign_flag => IDoutSignal_sign_flag

        );


	registerFileBlock : registerFile
	port map
	(
		-- Write data input port
		wdat    => WBSignal_jalFlagMuxOutput,
		-- Select which register to write
		wsel    => WBSignal_jalFlagRegisterWriteLocationOutput,
		-- Write Enable for entire register file
		wen	    => WBSignal_regWrite,       
		-- clock, positive edge triggered
		clk     => CLK,
		-- REMEMBER: nReset-> '0' = RESET, '1' = RUN
		nReset  => nReset,
		-- Select which register to read on rdat1 
		rsel1   => IDSignal_instruction(25 downto 21),
		-- Select which register to read on rdat2
		rsel2	  => IDSignal_instruction(20 downto 16),
		-- read port 1
		rdat1   => IDSignal_Data1,
		-- read port 2
		rdat2	  => IDSignal_Data2
		);
		
		
   pcSignExtenderBlock : signExtender
   port map( 
        imm16         => IDSignal_instruction(15 downto 0),
        extOp         => '1', -- should ALWAYS be sign extended
        signExtended  => IDSignal_imm16PCExtended
        );   
        
   currPCAddBy4 : twoInputAdder
   port map( 
        val1    => IDSignal_currProgramCounter,
        val2    => x"00000004",
        addRes  => IDSignal_nextPC
        ); 

   IDSignal_imm16PCExtendedShiftedBy2 <= IDSignal_imm16PCExtended(29 downto 0) & "00";

   nextPCimm16Adder : twoInputAdder
   port map( 
        val1    => IDSignal_nextPC,
        val2    => IDSignal_imm16PCExtendedShiftedBy2,
        addRes  => IDSignal_branchAddr
        ); 

   pcUpdateBlock : pcUpdate
   port map(   
        programCounter => IDSignal_nextPC,
        jlabel         => IDSignal_instruction(25 downto 0),
        updatedPC      => IDSignal_jumpAddr   
        );  

  luiShifterBlock : luiShifter
    port map( 
        imm16       => IDSignal_instruction(15 downto 0),
        shiftedOut  => IDSignal_luishifted
        );

---------- END OF INSTRUCTION DECODE STAGE ----------------------------------------
  
  --------------- HAZARD DETECTION UNIT ---------------------
  hazardDetectionUnitBlock: hazardDetectionUnit
  port map(
      EX_Rt => EXSignal_instruction(20 downto 16),
      ID_Rs => IDSignal_instruction(25 downto 21),
      ID_Rt => IDSignal_instruction(20 downto 16),
      EX_memRead => EXSignal_memRead,
      
      IFID_writeEnable => hazardDetection_IFIDWriteEnable,
      IDEX_writeEnable => hazardDetection_IDEXWriteEnable,
      EXMEM_writeEnable => hazardDetection_EXMEMWriteEnable,
      MEMWB_writeEnable => hazardDetection_MEMWBWriteEnable,
 
      pcWriteEnable => hazardDetectionPCWriteEnable,
      disableControlSignals => hazardDetectionMux21to21Enable
    );


  IDEX_nReset <= nReset  and (not MEMSignal_branchFlagZeroFlagAnded) and (not MEMSignal_j_flag) and (not MEMSignal_jal_flag)  and (not MEMSignal_jr_flag) and (not masterHaltSignal);
--------------------------- ID/EX PIPELINE REGISTER ----------------------------------------------
  IDEXpipeline : pipelineRegister_ID_EX
  port map(
          clk                => CLK,  
          rst_n              => IDEX_nReset,   
          regWriteEnable     => IDEXWriteEnable,
    
          ID_WB              => IDSignal_WB,
          ID_M               => IDSignal_M,
          ID_EX              => IDSignal_EX,

          ID_regDst          => IDoutSignal_regDst,
          ID_extOp           => IDoutSignal_extOp,
          ID_branch          => IDoutSignal_branch,
          ID_memRead         => IDoutSignal_memRead,
          ID_memToReg        => IDoutSignal_memToReg,
          ID_ALUCtr          => IDoutSignal_ALUCtr,
          ID_memWrite        => IDoutSignal_memWrite,
          ID_ALUSrc          => IDoutSignal_ALUSrc,
          ID_regWrite        => IDoutSignal_regWrite,
          ID_j_flag          => IDoutSignal_j_flag,
          ID_jal_flag        => IDoutSignal_jal_flag,
          ID_jr_flag         => IDoutSignal_jr_flag,
          ID_lui_flag        => IDoutSignal_lui_flag,
          ID_slt_u_flag      => IDoutSignal_slt_u_flag,
          ID_pc_write_enable => IDoutSignal_pc_write_enable,
          ID_bne_flag        => IDoutSignal_bne_flag,
          ID_lw_flag         => IDoutSignal_lw_flag,
          ID_halt_flag       => IDoutSignal_halt_flag,
          ID_shamt_flag      => IDoutSignal_shamt_flag,
          ID_sign_flag       => IDoutSignal_sign_flag,
          
          ID_instruction     => IDSignal_instruction,
          ID_Data1           => IDSignal_Data1,
          ID_Data2           => IDSignal_Data2,
          ID_luiShifted      => IDSignal_luiShifted,
          ID_nextPC          => IDSignal_nextPC,
          ID_branchAddr      => IDSignal_branchAddr,
          ID_jumpAddr        => IDSignal_jumpAddr,
          
          EX_WB              => EXSignal_WB,
          EX_M               => EXSignal_M,
          EX_EX              => EXSignal_EX,
          
          EX_regDst          => EXSignal_regDst,
          EX_extOp           => EXSignal_extOp,
          EX_branch          => EXSignal_branch,
          EX_memRead         => EXSignal_memRead,
          EX_memToReg        => EXSignal_memToReg,
          EX_ALUCtr          => EXSignal_ALUCtr,
          EX_memWrite        => EXSignal_memWrite,
          EX_ALUSrc          => EXSignal_ALUSrc,
          EX_regWrite        => EXSignal_regWrite,
          EX_j_flag          => EXSignal_j_flag,
          EX_jal_flag        => EXSignal_jal_flag,
          EX_jr_flag         => EXSignal_jr_flag,
          EX_lui_flag        => EXSignal_lui_flag,
          EX_slt_u_flag      => EXSignal_slt_u_flag,
          EX_pc_write_enable => EXSignal_pc_write_enable,
          EX_bne_flag        => EXSignal_bne_flag,
          EX_lw_flag         => EXSignal_lw_flag,
          EX_halt_flag       => EXSignal_halt_flag,
          EX_shamt_flag      => EXSignal_shamt_flag,
          EX_sign_flag       => EXSignal_sign_flag,

          EX_instruction     => EXSignal_instruction,
          EX_Data1           => EXSignal_Data1,
          EX_Data2           => EXSignal_Data2,
          EX_luiShifted      => EXSignal_luiShifted,
          EX_nextPC          => EXSignal_nextPC,
          EX_branchAddr      => EXSignal_branchAddr,
          EX_jumpAddr        => EXSignal_jumpAddr
    );

---------- START OF EXECUTE STAGE ----------------------------------------
  regDstMux : mux5Bit
   port map( 
        val0       => EXSignal_instruction(15 downto 11),
        val1       => EXSignal_instruction(20 downto 16),
        muxEnable  => EXSignal_regDst,
        muxOutput  => EXSignal_regDstMuxOutput
        ); 

  jalFlagRegisterFileMux :  mux5Bit
   port map( 
        val0       => EXSignal_regDstMuxOutput,
        val1       => "11111",
        muxEnable  => EXSignal_jal_flag,
        muxOutput  => EXSignal_jalFlagMuxOutput
        );

           
  ALUInputAThreeToOneMux: mux32BitThreeToOne
  port map( 
        val0  =>  EXSignal_Data1,
        val1  =>  WBSignal_jalFlagMuxOutput,
        val2  =>  MEMSignal_ALURes,
        muxEnable => MuxAEnableSignal,
        muxOutput => EXSignal_InputAThreeToOneMuxOutput
        );

  ALUInputBThreeToOneMux: mux32BitThreeToOne
  port map( 
        val0  =>  EXSignal_ShamtFlagMuxOutput,
        val1  =>  WBSignal_jalFlagMuxOutput,
        val2  =>  MEMSignal_ALURes,
        muxEnable => MuxBEnableSignal,
        muxOutput => EXSignal_InputBThreeToOneMuxOutput
        );
        
  
           
  EX_signExtender : signExtender
  port map( 
        imm16 => EXSignal_instruction(15 downto 0),
        extOp => EXSignal_extOp,
        signExtended => EXSignal_imm16_signEx
        );
        
  ALUSrcMux : mux32bit
  port map(
        val0  =>  EXSignal_Data2,
        val1  =>  EXSignal_imm16_signEx,
        muxEnable =>  EXSignal_ALUSrc,
        muxOutput =>  EXSignal_ALUSrcMuxOutput
        );
  
  EXSignal_shamtExtended <= "000000000000000000000000000" & EXSignal_instruction(10 downto 6);
  
  ShamtMux : mux32bit
  port map(
        val0  =>  EXSignal_ALUSrcMuxOutput,
        val1  =>  EXSignal_shamtExtended,
        muxEnable =>  EXSignal_shamt_flag,
        muxOutput =>  EXSignal_ShamtFlagMuxOutput
        );
        
  ALU_Unit  : alu
  port map( 
          opcode  =>  EXSignal_ALUCtr,
          A =>  EXSignal_InputAThreeToOneMuxOutput,
          B =>  EXSignal_InputBThreeToOneMuxOutput,
          signFlag  => EXSignal_sign_flag,
          aluout  =>  EXSignal_ALURes,
          negative  =>  EXSignal_negative_flag,
          overflow  => open,
          zero  =>  EXSignal_zero_flag
        );
  
  EXSignal_zeroFlagInverted <= not EXSignal_zero_flag;
  
  zeroAndInvertedZeroMux : mux1Bit
  port map( 
        val0       => EXSignal_zero_flag,
        val1       => EXSignal_zeroFlagInverted,
        muxEnable  => EXSignal_bne_flag,
        muxOutput  => EXSignal_zeroAndInvertedZeroMuxOutput
        );   
  
  ------ added these muxes as a quick hack for LUI followed by immediate use ---------  
  EXluiFlagMux : mux32Bit
  port map( 
        val0       => EXSignal_ALURes,
        val1       => EXSignal_luiShifted,
        muxEnable  => EXSignal_lui_flag,
        muxOutput  => EXSignal_luiFlagMuxOutput
        );   
   
  EXSignal_extendedAluNegativeFlag <= "0000000000000000000000000000000" & EXSignal_negative_flag;
  
  EXsltuFlagMux : mux32Bit
  port map( 
        val0       => EXSignal_luiFlagMuxOutput,
        val1       => EXSignal_extendedAluNegativeFlag,
        muxEnable  => EXSignal_slt_u_flag,
        muxOutput  => EXSignal_sltuFlagMuxOutput
        );        
  

  Data2ThreeToOneMux: mux32BitThreeToOne
  port map( 
        val0  =>  EXSignal_Data2,
        val1  =>  WBSignal_jalFlagMuxOutput,
        val2  =>  MEMSignal_ALURes,
        muxEnable => MuxCEnableSignal,
        muxOutput => EXSignal_Data2ThreeToOneMuxOutput
        );

  Data1ThreeToOneMux: mux32BitThreeToOne
  port map( 
        val0  =>  EXSignal_Data1,
        val1  =>  WBSignal_jalFlagMuxOutput,
        val2  =>  MEMSignal_ALURes,
        muxEnable => MuxDEnableSignal,
        muxOutput => EXSignal_Data1ThreeToOneMuxOutput
        );

	------------------------- END OF EXECUTE STAGE ----------------------------------
	
			
		
	---------------- forwarding unit ----------------------------
	forwardingUnitBlock : forwardingUnit
  port map(
    MEM_regWrite => MEMSignal_regWrite,
    WB_regWrite => WBSignal_regWrite,
    EX_memRead => EXSignal_memRead,
    MEM_registerBeingWrittenTo => MEMSignal_jalFlagMuxOutput,
    WB_registerBeingWrittenTo => WBSignal_jalFlagRegisterWriteLocationOutput,
    EX_Rs => EXSignal_instruction(25 downto 21),
    EX_Rt => EXSignal_instruction(20 downto 16),
    ALUSrc => EXSignal_ALUSrc,
    
    MUXA_enable => MuxAEnableSignal,
    MUXB_enable => MuxBEnableSignal,
    MUXC_enable => MuxCEnableSignal,
    MUXD_enable => MuxDEnableSignal
    );
 
 	
  --------------------------- EX/MEM PIPELINE REGISTER ----------------------------------------------
  EXMEMpipeline : pipelineRegister_EX_MEM
  port map(
    clk => CLK,
    rst_n => nReset,
    regWriteEnable => EXMEMWriteEnable, 
 
          EX_WB => EXSignal_WB,
          EX_M => EXSignal_M,

          EX_regDst => EXSignal_regDst,
          EX_extOp => EXSignal_extOp,
          EX_branch => EXSignal_branch,
          EX_memRead => EXSignal_memRead,
          EX_memToReg => EXSignal_memToReg,
          EX_ALUCtr => EXSignal_ALUCtr,
          EX_memWrite => EXSignal_memWrite,
          EX_ALUSrc => EXSignal_ALUSrc,
          EX_regWrite => EXSignal_regWrite,
          EX_j_flag => EXSignal_j_flag,
          EX_jal_flag => EXSignal_jal_flag,
          EX_jr_flag => EXSignal_jr_flag,
          EX_lui_flag => EXSignal_lui_flag,
          EX_slt_u_flag => EXSignal_slt_u_flag,
          EX_pc_write_enable => EXSignal_pc_write_enable,
          EX_bne_flag => EXSignal_bne_flag,
          EX_lw_flag => EXSignal_lw_flag,
          EX_halt_flag => EXSignal_halt_flag,
          EX_shamt_flag => EXSignal_shamt_flag,
          EX_sign_flag => EXSignal_sign_flag,
          
          EX_instruction => EXSignal_instruction,
          EX_Data1 => EXSignal_Data1ThreeToOneMuxOutput,
          EX_Data2 => EXSignal_Data2ThreeToOneMuxOutput,
          EX_luiShifted => EXSignal_luiShifted,
          EX_nextPC => EXSignal_nextPC,
          EX_branchAddr => EXSignal_branchAddr,
          EX_jumpAddr => EXSignal_jumpAddr,

          EX_zeroFlagMuxed => EXSignal_zeroAndInvertedZeroMuxOutput,
          EX_negativeFlag => EXSignal_negative_flag,
          EX_ALURes => EXSignal_sltuFlagMuxOutput,

          EX_jalFlagMuxOutput => EXSignal_jalFlagMuxOutput,
                 
          MEM_WB => MEMSignal_WB,
          MEM_M => MEMSignal_M,
          
          MEM_regDst => MEMSignal_regDst,
          MEM_extOp => MEMSignal_extOp,
          MEM_branch => MEMSignal_branch,
          MEM_memRead => MEMSignal_memRead,
          MEM_memToReg => MEMSignal_memToReg,
          MEM_ALUCtr => MEMSignal_ALUCtr,
          MEM_memWrite => MEMSignal_memWrite,
          MEM_ALUSrc => MEMSignal_ALUSrc,
          MEM_regWrite => MEMSignal_regWrite,
          MEM_j_flag => MEMSignal_j_flag,
          MEM_jal_flag => MEMSignal_jal_flag,
          MEM_jr_flag => MEMSignal_jr_flag,
          MEM_lui_flag => MEMSignal_lui_flag,
       	  MEM_slt_u_flag => MEMSignal_slt_u_flag,
       	  MEM_pc_write_enable => MEMSignal_pc_write_enable,
       	  MEM_bne_flag => MEMSignal_bne_flag,
       	  MEM_lw_flag => MEMSignal_lw_flag,
       	  MEM_halt_flag => MEMSignal_halt_flag,
       	  MEM_shamt_flag => MEMSignal_shamt_flag,
       	  MEM_sign_flag => MEMSignal_sign_flag,

          MEM_instruction => MEMSignal_instruction,
          MEM_Data1 => MEMSignal_Data1,
          MEM_Data2  => MEMSignal_Data2,
          MEM_luiShifted => MEMSignal_luiShifted,
          MEM_nextPC => MEMSignal_nextPC,
          MEM_branchAddr => MEMSignal_branchAddr,
          MEM_jumpAddr => MEMSignal_jumpAddr,

          MEM_zeroFlagMuxed => MEMSignal_zeroFlagMuxed,
          MEM_negativeFlag => MEMSignal_negativeFlag,
          MEM_ALURes => MEMSignal_ALURes,
          MEM_jalFlagMuxOutput => MEMSignal_jalFlagMuxOutput
    );
   
	------------------------- START OF MEMORY STAGE  ----------------------------------
  branchAndZeroAnder : ander
  port map( 
        input1     => MEMSignal_branch,
        input2     => MEMSignal_zeroFlagMuxed,
        andOutput  => MEMSignal_branchFlagZeroFlagAnded
        );     
  ---------------------- END OF MEMORY STAGE ---------------------------------------------
  
  --------------------------- MEM/WB PIPELINE REGISTER ----------------------------------------------
  MEMWBpipeline: pipelineRegister_MEM_WB
  port map(
    clk => CLK,
    rst_n => nReset,
    regWriteEnable => MEMWBWriteEnable, 


          MEM_WB => MEMSignal_WB,
          
          MEM_regDst => MEMSignal_regDst,
          MEM_extOp => MEMSignal_extOp,
          MEM_branch => MEMSignal_branch,
          MEM_memRead => MEMSignal_memRead,
          MEM_memToReg => MEMSignal_memToReg,
          MEM_ALUCtr => MEMSignal_ALUCtr,
          MEM_memWrite => MEMSignal_memWrite,
          MEM_ALUSrc => MEMSignal_ALUSrc,
          MEM_regWrite => MEMSignal_regWrite,
          MEM_j_flag => MEMSignal_j_flag,
          MEM_jal_flag => MEMSignal_jal_flag,
          MEM_jr_flag => MEMSignal_jr_flag,
          MEM_lui_flag => MEMSignal_lui_flag,
	  MEM_slt_u_flag => MEMSignal_slt_u_flag,
	  MEM_pc_write_enable => MEMSignal_pc_write_enable,
	  MEM_bne_flag => MEMSignal_bne_flag,
	  MEM_lw_flag => MEMSignal_lw_flag,
	  MEM_halt_flag => MEMSignal_halt_flag,
	  MEM_shamt_flag => MEMSignal_shamt_flag,
	  MEM_sign_flag => MEMSignal_sign_flag,

          MEM_luiShifted => MEMSignal_luiShifted,
          MEM_nextPC => MEMSignal_nextPC,

          MEM_negativeFlag => MEMSignal_negativeFlag,
          MEM_ALURes => MEMSignal_ALURes,

          MEM_readData => MEMSignal_readData,

         MEM_jalFlagMuxOutput => MEMSignal_jalFlagMuxOutput,

          WB_WB => WBSignal_WB,
          
          WB_regDst => WBSignal_regDst,
          WB_extOp => WBSignal_extOp,
          WB_branch => WBSignal_branch,
          WB_memRead => WBSignal_memRead,
          WB_memToReg => WBSignal_memToReg,
          WB_ALUCtr => WBSignal_ALUCtr,
          WB_memWrite => WBSignal_memWrite,
          WB_ALUSrc => WBSignal_ALUSrc,
          WB_regWrite => WBSignal_regWrite,
          WB_j_flag => WBSignal_j_flag,
          WB_jal_flag => WBSignal_jal_flag,
          WB_jr_flag => WBSignal_jr_flag,
          WB_lui_flag => WBSignal_lui_flag,
	  WB_slt_u_flag => WBSignal_slt_u_flag,
	  WB_pc_write_enable => WBSignal_pc_write_enable,
	  WB_bne_flag => WBSignal_bne_flag,
	  WB_lw_flag => WBSignal_lw_flag,
	  WB_halt_flag => WBSignal_halt_flag,
	  WB_shamt_flag => WBSignal_shamt_flag,
	  WB_sign_flag => WBSignal_sign_flag,

          WB_luiShifted => WBSignal_luiShifted,
          WB_nextPC => WBSignal_nextPC,

          WB_negativeFlag => WBSignal_negativeFlag,
          WB_ALURes => WBSignal_ALURes,

          WB_readData => WBSignal_readData,

         WB_jalFlagMuxOutput => WBSignal_jalFlagRegisterWriteLocationOutput
    );

  ---------------------- START OF WRITE BACK STAGE ---------------------------------------       
  memToRegMux : mux32Bit
  port map( 
        val0       => WBSignal_ALURes,
        val1       => WBSignal_readData,
        muxEnable  => WBSignal_memToReg,
        muxOutput  => WBSignal_memToRegMuxOutput
        );   
        
  luiFlagMux : mux32Bit
  port map( 
        val0       => WBSignal_memToRegMuxOutput,
        val1       => WBSignal_luiShifted,
        muxEnable  => WBSignal_lui_flag,
        muxOutput  => WBSignal_luiFlagMuxOutput
        );   
   
  WBSignal_extendedAluNegativeFlag <= "0000000000000000000000000000000" & WBSignal_negativeFlag;
  
  sltuFlagMux : mux32Bit
  port map( 
        val0       => WBSignal_luiFlagMuxOutput,
        val1       => WBSignal_extendedAluNegativeFlag,
        muxEnable  => WBSignal_slt_u_flag,
        muxOutput  => WBSignal_sltuFlagMuxOutput
        );        
        
  jalFlagMux : mux32Bit
  port map( 
        val0       => WBSignal_sltuFlagMuxOutput,
        val1       => WBSignal_nextPC,
        muxEnable  => WBSignal_jal_flag,
        muxOutput  => WBSignal_jalFlagMuxOutput
        ); 
  
  
  ------------------------ END OF WRITE BACK STAGE -----------------------------------------------

------------------------------ CACHE AND MEMORY ARBITER -----------------------------------
  IFSignal_iMemRead <= '1' and not(masterHaltSignal);
      
  icacheBlock: icache
  port map(
    clk       => CLK,
    nReset    => nReset,

    iMemRead  => IFSignal_iMemRead,--'1',       ---------------------------------- NEED TO BE CONNETED TO PCWRITEENABLE CONTROL
    iMemWait  => IFSignal_iMemWait,      
    iMemAddr  => IFSignal_currProgramCounter, 
    iMemData  => IFSignal_instruction, 

    aiMemWait => iCacheArbiter_aiMemWait,         
    aiMemRead => iCacheArbiter_aiMemRead,        
    aiMemAddr => iCacheArbiter_aiMemAddr, 
    aiMemData => iCacheArbiter_aiMemData  
    );

  
  dcacheBlock: dcache
  port map(
    clk            => CLK,
    nReset         => nReset,
    
    Halt           => masterHaltSignal,
    donePooping    => memoryDumpFinishedSignal,
    
    dMemRead       => MEMSignal_memRead,                
    dMemWrite      => MEMSignal_memWrite,                
    dMemWait       => MEMSignal_dMemWait,
    dMemAddr       => MEMSignal_ALURes, 
    dMemDataRead   => MEMSignal_readData, 
    dMemDataWrite  => MEMSignal_Data2, 

    adMemRead      => dCacheArbiter_adMemRead,               
    adMemWrite     => dCacheArbiter_adMemWrite,               
    adMemWait      => dCacheArbiter_adMemWait,                
    adMemAddr      => dCacheArbiter_adMemAddr, 
    adMemDataWrite => dCacheArbiter_adMemDataWrite,  
    adMemDataRead  => dCacheArbiter_adMemDataRead 
    );
  
  memArbiter: memoryArbiter
  port map(
    clk => CLK,
    rst_n => nReset,
    -- icache
    pipelineIFIDStall => pipelineIFIDWriteEnable,
    pipelineIDEXStall => pipelineIDEXWriteEnable,
    pipelineEXMEMStall => pipelineEXMEMWriteEnable,
    pipelineMEMWBStall => pipelineMEMWBWriteEnable,
    pcEnable => arbiterPCEnableSignal,
    aiMemWait => iCacheArbiter_aiMemWait,    
    aiMemRead => iCacheArbiter_aiMemRead,   
    aiMemAddr => iCacheArbiter_aiMemAddr,  
    aiMemData => iCacheArbiter_aiMemData,  

    -- dcache
    adMemRead      => dCacheArbiter_adMemRead,               
    adMemWrite     => dCacheArbiter_adMemWrite,            
    adMemWait      => dCacheArbiter_adMemWait,             
    adMemAddr      => dCacheArbiter_adMemAddr, 
    adMemDataRead  => dCacheArbiter_adMemDataRead, 
    adMemDataWrite => dCacheArbiter_adMemDataWrite, 
    
    --- RAM signals
                address         => arbiterRamSignal_address,
                data            => arbiterRamSignal_data,
                wren            => arbiterRamSignal_wren,
                rden            => arbiterRamSignal_rden,
                latency_override=> arbiterRamSignal_latency_override,
                q               => arbiterRamSignal_q,
                memstate        => arbiterRamSignal_memstate

    );

      ramAddr     <= arbiterRamSignal_address;
      ramData     <= arbiterRamSignal_data;
      ramWen      <= arbiterRamSignal_wren;
      ramRen      <= arbiterRamSignal_rden;
      arbiterRamSignal_q <= ramQ;        
      arbiterRamSignal_memstate <= ramState;
      halt <= masterHaltSignal and memoryDumpFinishedSignal;
end architecture;
