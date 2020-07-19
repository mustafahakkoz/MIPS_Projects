module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg [7:0] datmem[0:31],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire overflowprc;
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
out5,		//Output of zero or sign extend
out6,		//Output of alu result or pc for link
out7, 		//output of jump or Branch&ALUZero
out8, 		//output of (jump or Branch&ALUZero) or jumpsub
out9, 		//output of data memory mux
out10, 		//shifted sum for jmsub
out11, 		//balv shifted
out12,		//new pc
sum,		//ALU result
extad,	//Output of sign-extend unit
zextad, //output of zero-extend unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad,	//Output of shift left 2 unit
signext_inst25_0,
jmpadr; //jump address

wire [5:0] inst31_26;	//31-26 bits of instruction
wire overflowreg,
overflowreg2;

wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
reg31,
out13,		//regwrite input
out1;		//Write data input of Register File.

wire [15:0] inst15_0;	//15-0 bits of instruction
wire [25:0] inst25_0;

wire [31:0] instruc,	//current instruction
balv_addr,
dpack;	//Read data output of memory (data read from memory)



wire [2:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
mout, //minus sign output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
zerominus, // output of zero | minus
jump, //jump signal
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop0, zerosig, bgzeal, jrs, jmsub, sllv, overflow, balv, overflowbalv, reg31signal;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];
 assign inst25_0=instruc[25:0];


// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
 registerfile[out13]= regwrite ? out3:registerfile[out13];//Write data to register

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]};

assign reg31 = 5'd31;

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, instruc[20:16],instruc[15:11],regdest);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,out5,alusrc);

//mux with MemToReg control
mult2_to_1_32 mult3(out9, sum,dpack,memtoreg);

//mux with data memory output and pc+4
//mult2_to_1_32 mult9(out3, out9,adder1out,jmsub);

//mux with pc+4 and memtoreg output
mult2_to_1_32 mult14(out3, out9,adder1out,reg31signal);

//mux with zero extend or sign extend selection
mult2_to_1_32 mult5(out5, extad,zextad,zerosig);

//mux with alu result and pc for link
//mult2_to_1_32 mult6(out6, sum,,bgzeal);

//mux with (Branch&ALUZero) control
mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrc);

//mux with jump and result of (Branch&ALUZero)
mult2_to_1_32 mult7(out7, out4,dpack,jrs);

//mux with (jrs & branch&ALU) and jmsub
mult2_to_1_32 mult8(out8, out7,out9,jmsub);

//mux with reg31 and regular regwrite
mult2_to_1_32 mult13(out13, out1, reg31, reg31signal);


//shift shift3(out10, sum);
//assign signext(signext_inst25_0, inst25_0);

assign signext_inst25_0 = {{ 6 {inst25_0[25]}}, inst25_0};
shift shift4(out11, signext_inst25_0);
assign balv_addr={adder1out[31:28], out11[27:0]};


//mux for balv and ((jrs & branch&ALU) and jmsub)
mult2_to_1_32 mult12(out12,out8,balv_addr,overflowbalv);

assign rformat= (~instruc[31])&(~instruc[30])&(~instruc[29])&(~instruc[28])&(~instruc[27])&(~instruc[26]);
assign jmsub=instruc[5]&(~instruc[4])&(~instruc[3])&(~instruc[2])&(instruc[1])&(~instruc[0])&rformat;
assign sllv= (~instruc[5])&(~instruc[4])&(instruc[3])&(~instruc[2])&(~instruc[1])&(instruc[0])&rformat;

assign reg31signal = bgzeal|jmsub|overflowbalv;

//assign memtoreg = sllv ? 1'b0:1'b1;


// load pc
always @(negedge clk)
pc=out12;

// alu, adder and control logic connections

//ALU unit
alu32 alu1(sum,dataa,out2,zout,gout, mout, overflow);


assign #40 overflowreg = overflow;
assign #10 overflowreg2 = overflowreg;

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(instruc[31:26],sllv,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,
aluop1,aluop0, zerosig, bgzeal, jrs, balv, jmsub);

//Sign extend unit
signext sext(instruc[15:0],extad);

//zero extend unit
zeroext zext(instruc[15:0],zextad);

//ALU control unit
alucont acont(aluop1,aluop0,instruc[3],instruc[2], instruc[1], instruc[0] ,gout);


//Shift-left 2 unit
shift shift2(sextad,extad);

//AND gate
assign zerominus = zout || ~mout;
assign pcsrc=branch && zerominus; 

assign overflowbalv = overflowreg2&&balv;

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
initial
begin
$readmemh("initDm.dat",datmem); //read Data Memory
$readmemh("initIM.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;
	
end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule

