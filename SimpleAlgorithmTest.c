//
/*  A simple test, using only h0, h1, and h2, of the functionality of our algorithm.  Effectively, this will test the input/output
 * capabilities, the FFTs' functionality, and our ability to both extract data from the right spot and deploy it to the right spot.
 */
//


//

#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <complex.h>
#include <FFT.c>
#include <IFFT.c>

//Number of samples per block, declared in stone.  This corresponds to the N seen in the Zero Delay paper.
#define BLOCKLENGTH 64

/*

h0 declared and defined
h1 declared and defined
h2 declared and defined

 */

void standConv(float*, int, float*, float*);
complex double* IRComp(float*,int,int,int);
complex double* XComp(float*,int,int,int);
void outputComp(float*,int,int,int,double complex*,double complex*,int);



/*
 *
 * STUFF THAT NEEDS TO BE DONE IN MCASP, BEFORE THE "WHILE(1)" LOOP:
 *
 * 1.) The size of h (total length of impulse response) should be determined and set GLOBALLY.  For reference,
 *     I'll be calling this "h_size"  To make codewriting easier, I've #defined it up here.
 *
 */

#define h_size
#define Q      /*RIGHT NOW, THERE'S A DUMMY VAR. NAMED "Q" IN USE.  This Q represents the number of blocks that 'h' could be split into
 	 	 	 	*IF each block was EVENLY-SIZED and the size of an input buffer.  It is NOT the number of blocks that 'h' is split into
 	 	 	 	*by the Zero-Delay paper method. */










/*Here 'x' is the latest buffer of input samples, and 'y' is the next, ready-to-be-played-back, buffer's
 * length of output.  Even though the buckets are declared inside the algorithm, by declaring them as static
 * arrays we ensure two things:
 * 1.) They won't get lost/deleted/forgotten when the algorithm 'ends,' returns to MCASP for playback, and
 * then gets called again.
 * 2.) They only get declared once; even though they're inside the algorithm they won't get 're-declared' every
 * time the algorithm's called. */
void SimpleAlgorithmTest(float*x,float*y)
{
    static int block_Counter=0; //Starts out at zero, gets incremented by one every time the algorithm runs (in other words, every
    							//another input buffer arrives

    //Input Bucket Setup
    float* xbucket = (float*) malloc(h_Size*sizeof(float));
    memset(xbucket,0,h_Size*sizeof(int));

    //Output Bucket Setup
    int y_Size = h_size + /*hmax size (in this example that's h2's size) */ - 1;
    float* ybucket = (float*) malloc(y_Size*sizeof(float));
    memset(ybucket,0,y_Size*sizeof(int)); //Initialize all values to zero.

    int mult_Factor = 1;
        
    int impulse_IterateTotal = ceil(log2(Q)) - 1;
        
    for(int impulse_Counter = 0; impulse_Counter < impulse_IterateTotal; impulse_Counter++)
    {
            
    	if(block_Counter % mult_Factor == 0)
    	{
    		double complex* IR;
    		//take the fft of the IR
    		IR = IRComp(h,2*mult_Factor,3*mult_Factor,2*mult_Factor);

    		double complex* X;
    		//take the fft of the Input Signal
    		X = XComp(x,block_Counter,1*mult_Factor,2*mult_Factor);
                
    		outputComp(y,block_Counter,2*mult_Factor,4*mult_Factor,IR,X,2*mult_Factor);
                
    		//Handles the last block of the impulse response
    		if(impulse_Counter != impulse_IterateTotal || impulse_IterateTotal == floor(log2(Q)) - 1)
    		{
    			//take the fft of the IR
    			IR = IRComp(h,3*mult_Factor,4*mult_Factor,2*mult_Factor);
                    
    			outputComp(y,block_Counter,2*mult_Factor,4*mult_Factor,IR,X,2*mult_Factor);
    		}
                
    	}
    	//Double the mult_Factor
    	mult_Factor *= 2;
    }

    block_Counter++;
}




















complex double* IRComp(float* h,int s_B,int e_B,int h_Size)
{
    complex double* IR = (complex double*) malloc(sizeof(complex double)*(h_Size*N - 1));
    //compute the fft of h, place it in IR
    //------------------------------------

    //return value
    return IR;
}

complex double* XComp(float* x,int s_B,int e_B,int x_Size)
{
    complex double* X = (complex double*) malloc(sizeof(complex double)*(x_Size*N - 1));
    //compute the fft of h, place it in IR
    //------------------------------------

    //return value
    return X;
}

void outputComp(float* y,int block_Counter,int s_B,int e_B,double complex* IR,double complex* X,int fast_MultSize)
{
    //Perform element by element multiplication of IR and X
    //int fast_MultSize = sizeof(IR)/sizeof(double complex);
    complex double* fast_MultContainer = (complex double*) malloc(sizeof(complex double)*(fast_MultSize*N - 1));

    for(int i=0; i<fast_MultSize; i++)
    {
        fast_MultContainer[i] = IR[i] * X[i];
    }

    //compute ifft of fast_MultContainer data. I won't do that here, but I will just make a dummy array
    float* ifft_Container = (float*) malloc(sizeof(float)*fast_MultSize);

    //compute the starting index to write to time-domain output array
    int output_StartIndex = (block_Counter + s_B)*N;

    //compute ifft of fast_MultContainer, store it in ifft_Container
    //--------------------------------------------------------------

    //compute values for output array
    for(int i=0; i < fast_MultSize; i++)
    {
        y[output_StartIndex+i] += ifft_Container[i];
    }

}


int main(int argc, const char * argv[])
{
    zerodelayconvolution();
    
    return 0;
}

