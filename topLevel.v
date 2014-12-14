module topLevel(clk, sw, out);
input[7:0] sw;
wire[2:0] controlSignal;
wire strummerPos, strummerNeg;
input clk;

output out;

inputconditioner conditioner(clk, sw[0], strummerPos, strummerNeg);
controlSignalGen control(clk, sw[7:1], strummerPos, strummerNeg, controlSignal);
frequencyGen frequency(clk, controlSignal, out);

endmodule

module controlSignalGen(clk, switches, strummerPos, strummerNeg, controlSignal);

input[6:0] switches;
input strummerPos, strummerNeg, clk;
output reg[2:0] controlSignal = 0;

wire[6:0] inputControl;
wire strummerEdge;

or orgate(strummerEdge, strummerPos, strummerNeg);

always @(posedge clk) begin
	if (strummerEdge) begin
		controlSignal = 6;
		case(switches)
			7'b1000000: begin
				controlSignal = 6;
			end
			7'b0100000: begin
				controlSignal = 5;
			end
			7'b0010000: begin
				controlSignal = 4;
			end
			7'b0001000: begin
				controlSignal = 3;
			end
			7'b0000100: begin
				controlSignal = 2;
			end
			7'b0000010: begin
				controlSignal = 1;
			end
			7'b0000001: begin
				controlSignal = 0;
			end
		endcase
	end
end
endmodule

module frequencyGen(clk, controlSignals, soundWave);

input clk;
input[2:0] controlSignals;
output reg soundWave = 0;

reg[15:0] clkDivider;
reg[19:0] counter = 1;

parameter A = 3'd0;
parameter B = 3'd1;
parameter C = 3'd2;
parameter D = 3'd3;
parameter E = 3'd4;
parameter F = 3'd5;
parameter G = 3'd6;

parameter clkSpeed = 25; //megahertz
parameter aFreq = 220;
parameter bFreq = 247;
parameter cFreq = 261;
parameter dFreq = 294;
parameter eFreq = 330;
parameter fFreq = 349;
parameter gFreq = 392;
parameter selectedFreq = A;


always @(posedge clk) begin
	if (counter == 0) begin
		counter <= clkDivider;
		soundWave = ~soundWave;
	end else begin
		counter <= counter-1;
	end
	case(controlSignals)
		A: begin
			clkDivider = clkSpeed*1000000/aFreq/2;
		end
		B: begin
			clkDivider = clkSpeed*1000000/bFreq/2;
		end
		C: begin
			clkDivider = clkSpeed*1000000/cFreq/2;
		end
		D: begin
			clkDivider = clkSpeed*1000000/dFreq/2;
		end
		E: begin
			clkDivider = clkSpeed*1000000/eFreq/2;
		end
		F: begin
			clkDivider = clkSpeed*1000000/fFreq/2;
		end
		G: begin
			clkDivider = clkSpeed*1000000/gFreq/2;
		end
	endcase
end
endmodule

module inputconditioner(clk, noisysignal, positiveedge, negativeedge);
reg conditioned = 0;
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