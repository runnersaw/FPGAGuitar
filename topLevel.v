module topLevel(clk, sw, out);
input[7:0] sw;
wire[2:0] controlSignal;
input clk;

output reg out;

controlSignalGen(sw, controlSignal);
frequencyGen(clk, controlSignal, out);

endmodule

module controlSignalGen(switches, controlSignal);

input[7:0] switches;
output reg[2:0] controlSignal = 0;

wire[6:0] inputControl;
wire strummer;

assign inputControl = {switches[7:1]};
assign strummer = {switches[0]};

always @(edge strummer) begin
	controlSignal = 6;
	case(inputControl)
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
endmodule

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
