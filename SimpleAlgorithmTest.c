//
/*  A simple test, using only h0, h1, and h2, of the functionality of our algorithm.  Effectively, this will test the input/output
 * capabilities, the FFTs' functionality, and our ability to both extract data from the right spot and deploy it to the right spot.
 */
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

h0 declared, defined, and FFT'd
h1 declared, defined, and FFT'd
h2 declared, defined, and FFT'd

 */

void standConv(float*, int, float*, float*);
complex double* IRComp(float*,int,int,int);
void FastConvolve(float*,int,int);
void outputComp(float*,int,int,double complex*,double complex*,int);
void IRComp(float*,int,int,int);



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

void SimpleAlgorithmTest(float*x,float*y,int Q)
{
    static int block_Counter=0; //Starts out at zero, gets incremented by one every time the algorithm runs (in other words, every
    							//another input buffer arrives

    //Input Bucket Setup
    static float* xbucket = (float*) malloc(h_Size*sizeof(float));
    memset(xbucket,0,h_Size*sizeof(int));

    //Output Bucket Setup
    int y_Size = h_size + /*hmax size (in this example that's h2's size) */ - 1;
    static float* ybucket = (float*) malloc(y_Size*sizeof(float));
    memset(ybucket,0,y_Size*sizeof(int)); //Initialize all values to zero.


    int i; //Counter variable, used variously throughout different loops
    //Input bucket "management" (insertion of new buffers)
    for (i=0;i<BLOCKLENGTH;i++)
    {
    	int a=BLOCKLENGTH*block_Counter+i;
    	xbucket[a]=x[i];
    }


    int mult_Factor = 1;
        
    int impulse_IterateTotal = ceil(log2(Q)) - 1;
        
    for(int impulse_Counter = 0; impulse_Counter < impulse_IterateTotal; impulse_Counter++)
    {
            
    	if(block_Counter % mult_Factor == 0)
    	{
    		double complex* X;
    		//take the fft of the Input Signal
    		FastConvolve(xbucket,block_Counter,mult_Factor*BLOCKLENGTH);
                
    		outputComp(ybucket,block_Counter,2*mult_Factor,IR,X,2*mult_Factor);
                
    		//Handles the last block of the impulse response
    		if(impulse_Counter != impulse_IterateTotal || impulse_IterateTotal == floor(log2(Q)) - 1)
    		{
    			//take the fft of the IR
    			IR = IRComp(h,3*mult_Factor,4*mult_Factor,2*mult_Factor);
                    
    			outputComp(ybucket,block_Counter,2*mult_Factor,IR,X,2*mult_Factor);
    		}
                
    	}
    	//Double the mult_Factor
    	mult_Factor *= 2;
    }

    //Closing output bucket management (shifting)
    for(i=0;i<BLOCKLENGTH;i++)
    {
    	a=i+BLOCKLENGTH;
    	ybucket[i]=ybucket[a];
    }

    block_Counter++;
}



int main(int argc, const char * argv[])
{
    zerodelayconvolution();

    return 0;
}





//----Prototyped Functions------------------------------

void IRComp(float* h,int s_B,int e_B,int h_Size) //IN PROGRESS, BUT SHOULDN'T BE NEEDED AS h-BLOCKS SHOULD BE PRE-FFT'd
{
	int N=-2+4/*length of input*/;
    float* IR = (float*)malloc(sizeof(float)*(h_Size*N - 1));
    FFT(h,IR,m);
    //------------------------------------

    //return value
    return IR;
}

void FastConvolve(float* xbucket, float*ybucket,float*H, int s_B, int M)
{
	int i; //counter variable
	int N=4*M-2;//length of FFT'd blocks
	float* x =(float*)malloc(sizeof(float)*M);
	float* X =(float*)malloc(sizeof(float)*(N));
	int a; //another counter variable
	for(i=0;i<M;i++)
	{
		a=s_B+i;
		x[i]=xbucket[a];
	}
    FFT(x,X,M);

// This'll go away: -----> void outputComp,float*IR)

    float* Y = (float*) malloc(sizeof(float)*(N));

    for (i=0;i<N;i++)
    {
    	Y[i] = X[i]*H[/*specific index here*/];
    }

    float* y = (float*) malloc(sizeof(float)*(2*M-1);

    IFFT(Y,y,N);
    int output_StartIndex = (block_Counter + (2*multfactor))*N;

    for(int i=0; i < fast_MultSize; i++)
    {
        ybucket[output_StartIndex+i] += y[i];
    }

}

