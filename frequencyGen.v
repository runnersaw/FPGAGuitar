module frequencyGen(clk, controlSignals, soundWave);

input clk;
input[2:0] controlSignals;
output reg soundWave = 0;

reg[19:0] clkDivider;
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

module testFreqGen;

reg clk = 0;
reg[2:0] controlSignals = 3'd0;
wire soundWave;

frequencyGen generator(clk, controlSignals, soundWave);

always #10 clk=!clk;

initial begin
#25000000 controlSignals = 3'd6;
end
endmodule

