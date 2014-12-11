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

module testControlGen;

reg[7:0] switches = 8'b00000010;
wire[2:0] controlSignal;

controlSignalGen generator(switches, controlSignal);

initial begin
#1000 switches = 8'b00000011; // makes it 0
#1 $display("The control signal should be %d. It is actually %d", 0, controlSignal);
#1000 switches = 8'b00000101; // should stay at 0 even though the switch was toggled
#1 $display("The control signal should be %d. It is actually %d", 0, controlSignal);
#1000 switches = 8'b00000100; // now switches to 1
#1 $display("The control signal should be %d. It is actually %d", 1, controlSignal);
#1000 switches = 8'b01000011; // error, should make it 6
#1 $display("The control signal should be %d. It is actually %d", 6, controlSignal);
#1000 switches = 8'b01000001; // should stay at 6
#1 $display("The control signal should be %d. It is actually %d", 6, controlSignal);
#1000 switches = 8'b01000000; // makes it 5
#1 $display("The control signal should be %d. It is actually %d", 5, controlSignal);
#1000 switches = 8'b00000011; // makes it 0
#1 $display("The control signal should be %d. It is actually %d", 0, controlSignal);
end
endmodule


