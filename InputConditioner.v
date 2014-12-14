module inputconditioner(clk, noisysignal, conditioned, positiveedge, negativeedge);
output reg conditioned = 0;
output reg positiveedge = 0;
output reg negativeedge = 0;
input clk, noisysignal;

parameter counterwidth = 3;
parameter waittime = 3;

reg[counterwidth-1:0] counter =0;
reg synchronizer0 = 0;
reg synchronizer1 = 0;

always @(posedge clk ) begin
    negativeedge = 0;
    positiveedge = 0;
    if(conditioned == synchronizer1)
        counter <= 0;
    else begin
        if( counter == waittime) begin
            counter <= 0;
            conditioned <= synchronizer1;
	    if (conditioned == 1)
		negativeedge = 1;
	    else if (conditioned == 0)
		positiveedge = 1;
        end
        else 
            counter <= counter+1;
    end
    synchronizer1 = synchronizer0;
    synchronizer0 = noisysignal;
end
endmodule


module testConditioner;
wire conditioned;
wire rising;
wire falling;
reg pin, clk;
reg ri;
always @(posedge clk) ri=rising;
inputconditioner dut(clk, pin, conditioned, rising, falling);

initial begin
// Your Test Code
// Be sure to test each of the three things the conditioner does:
// Synchronize, Clean, Preprocess (edge finding)
// also remember that every two clk=!clk is one clock cycle
clk=0;
pin = 0;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
pin = 1;
#10 clk=!clk;
#10 clk=!clk;
pin = 0;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
pin = 1;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
pin=0;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
pin=1;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
pin=0;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
#10 clk=!clk;
end
endmodule
