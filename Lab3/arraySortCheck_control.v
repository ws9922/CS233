
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;
 	wire garbage, start, checking, oneround, Done, Sorted;
 
 	wire garbage_next = (garbage & ~go) | reset;
 	wire start_next = (garbage & go & ~reset) | (start & go & ~reset) | (Done & ~reset & go) | (Sorted & go & ~reset);
 	wire checking_next = (start & ~go & ~reset )| (oneround & ~end_of_array & ~inversion_found & ~zero_length_array & ~reset) ;
 	wire oneround_next = checking & ~reset;
	wire Done_next = (oneround & inversion_found & ~reset) | (Done & ~reset & ~go) | (checking & ~reset & inversion_found);
	wire Sorted_next = (oneround & end_of_array & ~reset) | (checking & zero_length_array & ~reset) | (Sorted & ~go & ~reset);


	dffe n1(garbage, garbage_next, clock, 1'b1, 1'b0);
	dffe n2(start, start_next, clock, 1'b1, 1'b0);
	dffe n3(checking, checking_next, clock, 1'b1, 1'b0);
	dffe n4(oneround, oneround_next, clock, 1'b1, 1'b0);
	dffe n5(Done, Done_next, clock, 1'b1, 1'b0);
	dffe n6(Sorted, Sorted_next, clock, 1'b1, 1'b0);

	assign load_index = start | oneround;
	assign load_input = start;
	assign select_index = oneround;

	assign done = Done | Sorted;
	assign sorted = Sorted;
endmodule
