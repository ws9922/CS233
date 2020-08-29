/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here
	unsigned bitrmask = 0b01010101010101010101010101010101;
	unsigned bitlmask = 0b10101010101010101010101010101010;
	unsigned rightcounter = input & bitrmask;
	unsigned leftcounter = input & bitlmask;
	input = (leftcounter >> 1) + rightcounter;
	bitrmask = 0b00110011001100110011001100110011;
	bitlmask = 0b11001100110011001100110011001100;
	rightcounter = input & bitrmask;
	leftcounter = input & bitlmask;
	input = (leftcounter >> 2) + rightcounter;
	bitrmask = 0b00001111000011110000111100001111;
	bitlmask = 0b11110000111100001111000011110000;
	rightcounter = input & bitrmask;
	leftcounter = input & bitlmask;
	input = (leftcounter >> 4) + rightcounter;
	bitrmask = 0b00000000111111110000000011111111;
	bitlmask = 0b11111111000000001111111100000000;
	rightcounter = input & bitrmask;
    leftcounter = input & bitlmask;
	input = (leftcounter >> 8) + rightcounter;
	bitrmask = 0b00000000000000001111111111111111;
	bitlmask = 0b11111111111111110000000000000000;
	rightcounter = input & bitrmask;
	leftcounter = input & bitlmask;
	input = (leftcounter >> 16) + rightcounter;
	return input;
}
