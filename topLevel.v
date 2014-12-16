module topLevel(clk, sw, btn, out, led);

input[7:0] sw;
input btn;
wire[2:0] controlSignal;
wire songOut, freqOut;
wire btnPos, btnNeg;
reg songSelect = 0;

wire strummerPos, strummerNeg;
input clk;

output out;
output[7:0] led;

inputconditioner btnCond(clk, btn, btnPos, btnNeg);

always @(posedge clk) begin
	if (btnPos) begin
		songSelect = ~songSelect;
	end
end

inputconditioner conditioner(clk, sw[0], strummerPos, strummerNeg);
controlSignalGen control(clk, sw[7:1], strummerPos, strummerNeg, controlSignal, led[6:0]);
songGenerator songGen(clk, songOut);
frequencyGen frequency(clk, controlSignal, freqOut);
mux1bit mux(freqOut, songOut, songSelect, out);

assign led[7] = songSelect;

endmodule

module songGenerator(clk, out);
input clk;
output out;

reg[10:0] state = 0;

parameter clkSpeed = 50000000;
reg[3:0] noteTime = 1; // length of note second
reg[31:0] clkDivider;
reg[31:0] counter = 0;
reg loopCounter = 0;
reg[1:0] nextCounter = 0;

parameter eflat4Freq = 310;
parameter dflat4Freq = 276;
parameter dflat5Freq = 554;
parameter aflat4Freq = 414;
parameter gflat4Freq = 370;
parameter gflat5Freq = 740;
parameter f5Freq = 698;

always @(posedge clk) begin
	if (counter == 0) begin
		case(state)
			0: begin
				noteTime = 1;
				clkDivider = clkSpeed/dflat4Freq/2;
				state <= 1;
			end
			1: begin
				noteTime = 1;
				clkDivider = clkSpeed/dflat5Freq/2;
				state <= 2;
			end
			2: begin
				noteTime = 1;
				clkDivider = clkSpeed/aflat4Freq/2;
				state <= 3;
			end
			3: begin
				noteTime = 1;
				clkDivider = clkSpeed/gflat4Freq/2;
				state <= 4;
			end
			4: begin
				noteTime = 1;
				clkDivider = clkSpeed/gflat5Freq/2;
				state <= 5;
			end
			5: begin
				noteTime = 1;
				clkDivider = clkSpeed/aflat4Freq/2;
				state <= 6;
			end
			6: begin
				noteTime = 1;
				clkDivider = clkSpeed/f5Freq/2;
				state <= 7;
			end
			7: begin
				noteTime = 1;
				clkDivider = clkSpeed/aflat4Freq/2;
				if (loopCounter == 1) begin
					if (nextCounter == 0) begin
						state <= 8;
						nextCounter <= 1;
					end 
					if (nextCounter == 1) begin
						state <= 9;
						nextCounter <= 2;
					end 
					if (nextCounter == 2) begin
						state <= 10;
						nextCounter <= 3;
					end 
					if (nextCounter == 3) begin
						state <= 0;
						nextCounter <= 4;
					end 
					loopCounter = 0;
				end else begin
					if (nextCounter == 0) begin
						state <= 0;
					end 
					if (nextCounter == 1) begin
						state <= 8;
					end 
					if (nextCounter == 2) begin
						state <= 9;
					end 
					if (nextCounter == 3) begin
						state <= 10;
					end 
					loopCounter = 1;
				end
			end
			8: begin
				noteTime = 1;
				clkDivider = clkSpeed/eflat4Freq/2;
				state <= 1;
			end
			9: begin
				noteTime = 1;
				clkDivider = clkSpeed/gflat4Freq/2;
				state <= 1;
			end
			10: begin
				noteTime = 1;
				clkDivider = clkSpeed/dflat4Freq/2;
				state <= 1;
			end
		endcase
		counter <= clkSpeed*noteTime/4;
	end else begin
		counter <= counter-1;
	end
end

songFreqGen freqGen(clk, clkDivider, out);

endmodule

module songFreqGen(clk, clkDivider, out);
input clk;
input[31:0] clkDivider;
output reg out = 0;
reg[31:0] counter;

always @(posedge clk) begin
	if (counter == 0) begin
		counter <= clkDivider;
		out = ~out;
	end else begin
		counter <= counter-1;
	end
end

endmodule

module controlSignalGen(clk, switches, strummerPos, strummerNeg, controlSignal, led);

input[6:0] switches;
input strummerPos, strummerNeg, clk;
output reg[2:0] controlSignal = 0;
output reg[6:0] led = 0;

wire strummerEdge;

or orgate(strummerEdge, strummerPos, strummerNeg);

always @(posedge clk) begin
	if (strummerEdge) begin
		controlSignal = 7;
		led = {switches};
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

reg[16:0] clkDivider;
reg[19:0] counter = 1;

parameter A = 3'd0;
parameter B = 3'd1;
parameter C = 3'd2;
parameter D = 3'd3;
parameter E = 3'd4;
parameter F = 3'd5;
parameter G = 3'd6;
parameter none = 3'd7;

parameter clkSpeed = 50; //megahertz
parameter aFreq = 220;
parameter bFreq = 247;
parameter cFreq = 261;
parameter dFreq = 294;
parameter eFreq = 330;
parameter fFreq = 349;
parameter gFreq = 392;

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
		none: begin
			clkDivider = 2; // generates a 25000000Hz freq, which we can't here
		end
	endcase
end
endmodule

module inputconditioner(clk, noisysignal, positiveedge, negativeedge);
reg conditioned = 0;
output reg positiveedge = 0;
output reg negativeedge = 0;
input clk, noisysignal;

parameter counterwidth = 7;
parameter waittime = 100;

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

module mux1bit(input0, input1, control, out);

input input0, input1;
input control;
output out;

wire mux_input[1:0]; // Creates a 2d Array of wires

assign mux_input[0] = input0; // Connects the sources of the array
assign mux_input[1] = input1;
assign out = mux_input[control]; // Connects the output of the array

endmodule