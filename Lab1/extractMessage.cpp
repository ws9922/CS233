/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);

    // allocate an array for the output
    unsigned char *message_out = new unsigned char[length];
    for (int i = 0; i < length; i++) {
        message_out[i] = 0;
    }

    // TODO: write your code here
    int numberOfMessage = length / 8;
    int line = 0;
    for (int i = 0; i < numberOfMessage; i++) {
        unsigned char verify = 0b00000001;
        for (int k = 0; k < 8; k++) {
            int j = 8 * i + 7;
            unsigned char original = 0b00000000;
            unsigned char smart = 0b10000000;
            while(j >= 8 * i) {
                //int index = j - 8 * i;
                if ((message_in[j] & verify) != 0b00000000) {
                    original = original | smart;
                }
                smart = smart >> 1;
                j--;
            }
        message_out[line] = original;
        line ++;
        verify = verify << 1;
        }
        
    }

    return message_out;
}
