module control(in,sllv, regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2, zerosig, bgzeal, jrs, balv, jmsub);
input [5:0] in;
input sllv;
input jmsub;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2, zerosig, bgzeal, jrs, balv;
wire rformat,lw,sw,beq;
assign rformat=~|in;
assign lw=in[5]& (~in[4])&(~in[3])&(~in[2])&(in[1])&in[0];
assign sw=in[5]& (~in[4])&in[3]&(~in[2])&in[1]&in[0];
assign beq=~in[5]& (~in[4])&(~in[3])&in[2]&(~in[1])&(~in[0]);
assign bgzeal=(in[5])& (~in[4])&(~in[3])&(in[2])&(in[1])&(in[0]);
assign zerosig=(~in[5])& (~in[4])&(in[3])&(in[2])&(~in[1])&(in[0]);
assign jrs=(~in[5])& (in[4])&(~in[3])&(~in[2])&(in[1])&(~in[0]);
assign balv=(in[5])&(~in[4])&(~in[3])&(~in[2])&(~in[1])&(in[0]);


assign regdest=rformat|~(~zerosig^~bgzeal);
assign alusrc=lw|sw|jrs|zerosig;
assign memtoreg=lw|jmsub;
assign regwrite=rformat|lw|zerosig|bgzeal|~jrs|balv;
assign memread=lw|jrs|jmsub;
assign memwrite=sw|~(~jrs^~jmsub);
assign branch=beq|bgzeal;
assign aluop1=rformat|zerosig;
assign aluop2=beq|zerosig|bgzeal|balv;


endmodule
