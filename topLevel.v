module topLevel(clk, sw, btn, out, led);

input[7:0] sw;
input btn;
wire[2:0] switchControlSignal;
wire[2:0] noteControlSignal;
wire[2:0] controlSignal;
wire btnPos, btnNeg;
reg songSelect = 0;

wire strummerPos, strummerNeg;
input clk;

output out;
output[7:0] led;

wire[6:0] useless;

inputconditioner btnCond(clk, btn, btnPos, btnNeg);

always @(posedge clk) begin
	if (btnPos) begin
		songSelect = ~songSelect;
	end
end

inputconditioner conditioner(clk, sw[0], strummerPos, strummerNeg);
controlSignalGen control(clk, sw[7:1], strummerPos, strummerNeg, switchControlSignal, useless[6:0]);
songGenerator songGen(clk, noteControlSignal);
mux3bit mux(switchControlSignal, noteControlSignal, songSelect, controlSignal);
frequencyGen frequency(clk, controlSignal, out);

assign led[7] = songSelect;
assign led[6:4] = controlSignal;
assign led[3:1] = switchControlSignal;
assign led[0] = songSelect;

endmodule

module songGenerator(clk, note);
input clk;
output[2:0] note;

reg[31:0] t = 0;
reg[30:0] musicSheet;
reg[100:0] index = 0;

parameter A = 3'd0;
parameter B = 3'd1;
parameter C = 3'd2;
parameter D = 3'd3;
parameter E = 3'd4;
parameter F = 3'd5;
parameter G = 3'd6;
parameter none = 3'd7;


initial musicSheet = {A, B, C, D, E, F, G};

// how are we gonna parse the notes?
//initial $readmemh("whateverWeNameTheFile.mem", musicSheet);

always @(posedge clk) begin
	if (t == 0) begin
		if (index == 6) begin
			index <= 0;
		end
		else begin 
			index <= index + 3;
			t <= 25000000;
		end
	end else begin
		t <= t + 1;
	end
end


assign note[2] = musicSheet[index];
assign note[1] = musicSheet[index+1];
assign note[0] = musicSheet[index+2];

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
		controlSignal = 6;
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

module mux3bit(input0, input1, control, out);

input[2:0] input0, input1;
input control;
output[2:0] out;

wire[2:0] mux_input[1:0]; // Creates a 2d Array of wires

assign mux_input[0] = input0; // Connects the sources of the array
assign mux_input[1] = input1;
assign out = mux_input[control]; // Connects the output of the array

endmodule