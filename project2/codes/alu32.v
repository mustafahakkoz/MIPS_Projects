module alu32(sum,a,b,zout,gin, minusign, overflow);//ALU operation according to the ALU control line values
output [31:0] sum;
input [31:0] a,b; 
input [2:0] gin;//ALU control line
reg [31:0] sum;
reg [31:0] less;
output zout;
reg zout;
output minusign;
reg minusign;
output overflow;
reg overflow;
 
always @(a or b or gin)
begin
	
	overflow=0;
	case(gin)
	3'b010:begin		//ALU control line=010, ADD
		sum=a+b; 
		if((~(a[31]^b[31]))&(sum[31]^a[31])) overflow=1'b1;
		else overflow=0;
		end	
	3'b110:begin 
		sum=a+1+(~b);	//ALU control line=110, SUB
		if((a[31]^b[31]))
		if(a[31]^sum[31])
		overflow=1;
		else
		overflow=0;		
		end
	3'b111: begin less=a+1+(~b);	//ALU control line=111, set on less than
			if (less[31]) sum=1;	
			else sum=0;
		  end
	3'b000: sum=a & b;	//ALU control line=000, AND
	3'b001: sum=a|b;		//ALU control line=001, OR
	3'b011: begin 			//ALU control for less than zero
			if(a[31]) minusign=1;
			else minusign=0;
			end
	3'b100: sum=a<<b;  //ALU control line= 100 shift left
	default: sum=31'bx;	
	endcase
zout=~(|sum);

end
endmodule
