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
			-- instruction memory address
			imemAddr				:		out	std_logic_vector(31 downto 0);
			-- instruction data read from memory
			imemData				:		out	std_logic_vector(31 downto 0);
			-- data memory address
			dmemAddr				:		out	std_logic_vector(31 downto 0);
			-- data read from memory
			dmemDataRead		:		out	std_logic_vector(31 downto 0);
			-- data written to memory
			dmemDataWrite		:		out	std_logic_vector(31 downto 0);
			-- memory address to dump
			dumpAddr				:		in	std_logic_vector(15 downto 0)
		);
end mycpu;

architecture arch_mycpu of mycpu is

  
  ------------------------ COMPONENTS FOR PC UPDATE BLOCK -------------------------        
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
  
  --------------------------- COMPONENTS FOR CONTROLLER BLOCK ------------------------------
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
 
  
  --------------------------- COMPONENTS FOR THE BIGGEST BLOCK -----------------------------
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
  
  component alu
    port ( 
        opcode: IN STD_LOGIC_VECTOR (3 downto 0);
        A, B: IN STD_LOGIC_VECTOR (31 downto 0);
        signFlag: IN STD_LOGIC;
        aluout: OUT STD_LOGIC_VECTOR (31 downto 0);
        negative: OUT STD_LOGIC;
        overflow, zero: OUT STD_LOGIC);
  end component;
    
  component ander
    port ( 
        input1: IN STD_LOGIC;
        input2: IN STD_LOGIC;
        andOutput: OUT STD_LOGIC
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
  
  component lwStateMachine
    port(
    clk: in std_logic;
    rst_n: in std_logic;
    opcode : in STD_LOGIC_VECTOR(5 downto 0);
    pcWriteEnable: out std_logic;
    haltFlag: out std_logic
  );
  end component;
----------- rami and ramd components ----------
  component rami
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
	
	component ramd
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;
    
  signal j_flagSig, jal_flagSig, jr_flagSig, pc_write_enableSig, regDstSig, regWriteSig, ALUSrcSig, bne_flagSig, memToRegSig, lui_flagSig, slt_u_flagSig : STD_LOGIC;
  signal memWriteSig, extOpSig, branchSig, memReadSig, lw_flagSig, halt_flagSig, sign_flagSig, shamt_flagSig : STD_LOGIC;
  signal ALUCtrSig : STD_LOGIC_VECTOR(3 downto 0);
  signal imm16PCExtendedSig : STD_LOGIC_VECTOR(31 downto 0);
  signal nextPCSig : STD_LOGIC_VECTOR(31 downto 0);
  signal currPCSig : STD_LOGIC_VECTOR(31 downto 0);
  signal branchAddrSig : STD_LOGIC_VECTOR(31 downto 0);
  signal pcSrcMuxOutputSig : STD_LOGIC_VECTOR(31 downto 0);
  signal branchZeroAnderSig : STD_LOGIC;
  signal updatedPCSig : STD_LOGIC_VECTOR(31 downto 0);
  signal instructionSig : STD_LOGIC_VECTOR(31 downto 0);
  signal jjalOrResult : STD_LOGIC;
  signal jjalMuxOutputSig : STD_LOGIC_VECTOR(31 downto 0);
  signal jrFlagMuxOutputSig : STD_LOGIC_VECTOR(31 downto 0);
  signal registerData1Sig : STD_LOGIC_VECTOR(31 downto 0);
  signal registerData2Sig : STD_LOGIC_VECTOR(31 downto 0);
  signal ramdOutputSig : STD_LOGIC_VECTOR(31 downto 0);
  signal regDstMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
  signal jalFlagRegisterFileMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
  signal registerFileWriteDataSig : STD_LOGIC_VECTOR(31 downto 0);
  signal imm16ALUExtendedSig : STD_LOGIC_VECTOR(31 downto 0);
  signal ALUSrcMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal shamtExtendedSig : STD_LOGIC_VECTOR(31 downto 0);
  signal ALUInputBSig : STD_LOGIC_VECTOR(31 downto 0);
  signal aluOutputSig : STD_LOGIC_VECTOR(31 downto 0);
  signal aluNegativeFlagSig : STD_LOGIC;
  signal aluZeroFlagSig, aluZeroFlagInvertedSig : STD_LOGIC;
  signal aluOverflowFlagSig : STD_LOGIC;
  signal zeroAndInvertedZeroMuxOutput : STD_LOGIC;
  signal ramdInputAddr : STD_LOGIC_VECTOR(31 downto 0);
  signal extendedDumpAddr : STD_LOGIC_VECTOR(31 downto 0);
  signal luiShiftedSig : STD_LOGIC_VECTOR(31 downto 0);
  signal memToRegMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal luiFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal sltuFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
--  signal jalFlagMuxOutput : STD_LOGIC_VECTOR(31 downto 0);
  signal extendedAluNegativeFlag : STD_LOGIC_VECTOR(31 downto 0);
  signal haltFlagSig : STD_LOGIC;
  signal haltFlagOrSig : STD_LOGIC;
  signal pcwe : STD_LOGIC;
  signal imm16PCExtendedShifted : STD_LOGIC_VECTOR(31 downto 0);
  
begin
   ----------------- PC BLOCK LAYOUT -----------------------
   pcSignExtenderBlock : signExtender
    port map( 
        imm16         => instructionSig(15 downto 0),
        extOp         => '1',
        signExtended  => imm16PCExtendedSig
        );   
   
   imm16PCExtendedShifted <= imm16PCExtendedSig(29 downto 0) & "00";
        
   npcImm16Adder : twoInputAdder
   port map( 
        val1    => nextPCSig,
        val2    => imm16PCExtendedShifted,
        addRes  => branchAddrSig
        ); 
        
   currPCAddBy4 : twoInputAdder
   port map( 
        val1    => currPCSig,
        val2    => x"00000004",
        addRes  => nextPCSig
        ); 
   
   pcSrcMux : mux32Bit
   port map( 
        val0       => nextPCSig,
        val1       => branchAddrSig,
        muxEnable  => branchZeroAnderSig,
        muxOutput  => pcSrcMuxOutputSig
        );

   JJALFlagPCMux : mux32Bit
   port map( 
        val0       => pcSrcMuxOutputSig,
        val1       => updatedPCSig,
        muxEnable  => jjalOrResult,
        muxOutput  => jjalMuxOutputSig
        );
      
   pcUpdateBlock : pcUpdate
   port map(   
        programCounter => nextPCSig,
        jlabel         => instructionSig(25 downto 0),
        updatedPC      => updatedPCSig   
        );  
        
   JJALOrer : orer
   port map( 
        input1    => j_flagSig,
        input2    => jal_flagSig,
        orOutput  => jjalOrResult
        );  
        
   jrFlagMux :  mux32Bit
   port map( 
        val0       => jjalMuxOutputSig,
        val1       => registerData1Sig,
        muxEnable  => jr_flagSig,
        muxOutput  => jrFlagMuxOutputSig
        ); 
        
   pcRegBlock : pcReg
   port map(
       clk             => CLK,
       rst_n           => nReset,
       pcWriteEnable   => pc_write_enableSig,
       nextPC          => jrFlagMuxOutputSig,
       programCounter  => currPCSig
       );

-------------- end of PC block layout ----------------------------------------------------------

---------- start of controller layout ----------------------------------------
  controllerBlock : controller
  port map( 
          opcode           => instructionSig(31 downto 26),
          function_code    => instructionSig(5 downto 0),

          regDst           => regDstSig,
          extOp            => extOpSig,
          branch           => branchSig,
          memRead          => memReadSig,
          memToReg         => memToRegSig,
          ALUCtr           => ALUCtrSig,
          memWrite         => memWriteSig,
          ALUSrc           => ALUSrcSig,
          regWrite         => regWriteSig,
          j_flag           => j_flagSig,
          jal_flag         => jal_flagSig,
          jr_flag          => jr_flagSig,
          lui_flag         => lui_flagSig,
          slt_u_flag       => slt_u_flagSig,
          pc_write_enable  => open,
          bne_flag         => bne_flagSig,
          lw_flag          => lw_flagSig,
          halt_flag        => halt_flagSig,
          shamt_flag       => shamt_flagSig,
          sign_flag        => sign_flagSig
	);
	
----------- LAYOUT OF RAMI AND RAMD ---------------------------------------
  ramiBlock : rami
	PORT map
	(
		address  => currPCSig(15 downto 0),
		clock	   => CLK,
		data	    => x"00000000",
		wren     => '0',
		q        => instructionSig
	);
	
	ramdBlock : ramd
	PORT map
	(
		address  => ramdInputAddr(15 downto 0),
		clock    => CLK,
		data     => registerData2Sig,
		wren     => memWriteSig,
		q        => ramdOutputSig
	);

------------- LAYOUT OF BIGGEST BLOCK ---------------------------
  
  regDstMux : mux5Bit
   port map( 
        val0       => instructionSig(15 downto 11),
        val1       => instructionSig(20 downto 16),
        muxEnable  => regDstSig,
        muxOutput  => regDstMuxOutput
        ); 

  jalFlagRegisterFileMux :  mux5Bit
   port map( 
        val0       => regDstMuxOutput,
        val1       => "11111",
        muxEnable  => jal_flagSig,
        muxOutput  => jalFlagRegisterFileMuxOutput
        ); 
  
  registerFileBlock : registerFile
	port map
	(
		-- Write data input port
		wdat    => registerFileWriteDataSig,
		-- Select which register to write
		wsel    => jalFlagRegisterFileMuxOutput,
		-- Write Enable for entire register file
		wen	    => regWriteSig,
		-- clock, positive edge triggered
		clk     => CLK,
		-- REMEMBER: nReset-> '0' = RESET, '1' = RUN
		nReset  => nReset,
		-- Select which register to read on rdat1 
		rsel1   => instructionSig(25 downto 21),
		-- Select which register to read on rdat2
		rsel2	  => instructionSig(20 downto 16),
		-- read port 1
		rdat1   => registerData1Sig,
		-- read port 2
		rdat2	  => registerData2Sig
		);
		
	aluSignExtenderBlock : signExtender
  port map( 
        imm16         => instructionSig(15 downto 0),
        extOp         => extOpSig,
        signExtended  => imm16ALUExtendedSig
        );
        
  ALUSrcMux :  mux32Bit
  port map( 
        val0       => registerData2Sig,
        val1       => imm16ALUExtendedSig,
        muxEnable  => ALUSrcSig,
        muxOutput  => ALUSrcMuxOutput
        );  
        
  shamtExtendedSig <= "000000000000000000000000000" & instructionSig(10 downto 6);
    
  shamtFlagMux : mux32Bit
  port map( 
        val0       => ALUSrcMuxOutput,
        val1       => shamtExtendedSig,
        muxEnable  => shamt_flagSig,
        muxOutput  => ALUInputBSig
        ); 
        
  ALUBlock : alu
  port map( 
        opcode    => ALUCtrSig,
        A         => registerData1Sig,
        B         => ALUInputBSig,
        signFlag  => sign_flagSig,
        aluout    => aluOutputSig,
        negative  => aluNegativeFlagSig,
        overflow  => aluOverflowFlagSig,
        zero      => aluZeroFlagSig
        );
    
  aluZeroFlagInvertedSig <= not aluZeroFlagSig;
    
  zeroAndInvertedZeroMux : mux1Bit
  port map( 
        val0       => aluZeroFlagSig,
        val1       => aluZeroFlagInvertedSig,
        muxEnable  => bne_flagSig,
        muxOutput  => zeroAndInvertedZeroMuxOutput
        ); 
        
  branchAndZeroAnder : ander
  port map( 
        input1     => branchSig,
        input2     => zeroAndInvertedZeroMuxOutput,
        andOutput  => branchZeroAnderSig
        );     
    
  extendedDumpAddr <= x"0000" & dumpAddr;    
    
  ramdTestbenchALUAddressMux : mux32Bit
  port map( 
        val0       => aluOutputSig,
        val1       => extendedDumpAddr,
        muxEnable  => haltFlagOrSig,
        muxOutput  => ramdInputAddr
        );     
        
  luiShifterBlock : luiShifter
  port map( 
        imm16       => instructionSig(15 downto 0),
        shiftedOut  => luiShiftedSig
        );    
  
  memToRegMux : mux32Bit
  port map( 
        val0       => aluOutputSig,
        val1       => ramdOutputSig,
        muxEnable  => memToRegSig,
        muxOutput  => memToRegMuxOutput
        );   
        
  luiFlagMux : mux32Bit
  port map( 
        val0       => memToRegMuxOutput,
        val1       => luiShiftedSig,
        muxEnable  => lui_flagSig,
        muxOutput  => luiFlagMuxOutput
        );   
   
  extendedAluNegativeFlag <= "0000000000000000000000000000000" & aluNegativeFlagSig;
  
  sltuFlagMux : mux32Bit
  port map( 
        val0       => luiFlagMuxOutput,
        val1       => extendedAluNegativeFlag,
        muxEnable  => slt_u_flagSig,
        muxOutput  => sltuFlagMuxOutput
        );        
        
  jalFlagMux : mux32Bit
  port map( 
        val0       => sltuFlagMuxOutput,
        val1       => nextPCSig,
        muxEnable  => jal_flagSig,
        muxOutput  => registerFileWriteDataSig
        ); 
        
  lwHaltStateMachine : lwStateMachine
  port map(
    clk            => CLK,
    rst_n          => nReset,
    opcode         => instructionSig(31 downto 26),
    pcWriteEnable  => pc_write_enableSig,
    haltFlag       => haltFlagSig
  );     
  
  --pcwe <= pc_write_enableSig xor lw_flagSig;
  
  haltFlagOrSig <= halt_flagSig or haltFlagSig;
			-- halt for processor
			halt <= haltFlagOrSig;
      -- instruction memory address
			imemAddr <= currPCSig;
			-- instruction data read from memory
			imemData <= instructionSig;
			-- data memory address
			dmemAddr <= ramdInputAddr;
			-- data read from memory
			dmemDataRead <= ramdOutputSig;
			-- data written to memory
			dmemDataWrite	<= registerData2Sig;
  
end architecture;