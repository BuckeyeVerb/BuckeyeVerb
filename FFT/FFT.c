/* ===================================================================================
 * Fast Fourier Transform; Self-Contained
 * ===================================================================================
 * ==============================================================
 * ========================================
 *
 * FFT.c
 *
 * Description of function, inputs, and outputs:
 *
 *
 * INPUTS & OUTPUTS:
 *
 * x = an array entirely composed of real-valued audio samples.  This is the thing you want an FFT of.  Type: array of floats
 * X = This is a container for the values we calculate to go into.  It is of a different size than 'x' (namely, 4*x).  Must be declared
 *     with 'malloc' outside this function (in whatever scope is calling this function).  Type: array of floats
 * M = The length of x; literally how many entries are in array 'x.'  You'd better hope it's a power of two.  Type: unsigned short
 *
 *
 * DESCRIPTION:
 *
 * This function performs a few auxiliary tasks necessary for working in the language of Code Composer, and C in general.  Feed in the
 * array you want an FFT taken of ("x").  This function will add enough zeroes on the end for the length to be twice the original length,
 * (as it needs to be for convolution).  While strictly-speaking the length req'd to imitate convolution is 2x-1, that would produce an
 * array that is one less than a power of two (assuming, as I've the right to, that the input 'x' has a length that's a power of two).
 * The DSP's function that actually performs the nitty-gritty FFT gruntwork would not like this - it MUST have radix-2 inputs.  So we
 * simply add on one x-length's worth of zeroes, making the overall size 2x.
 *
 * Next, zeroes are inserted in-between every other element in the array (so, if the original array was [x, x2, x3, x4, etc...] the
 * new array will be [x, 0, x1, 0, x3, 0, x4, 0, etc...].  This is because the actual FFT operation expects to read an array of 2N
 * long representing N complex numbers; the first, third, fifth, etc... entries in the array are the real parts and the second,
 * fourth, sixth, etc... entries are the complex parts.
 *
 * Furthermore, and of particular concern with regard to this function communicating with the scope in which it is called, arrays cannot
 * be returned as results of functions in C.  This is why techniques like pointers and overwriting the input vector are used.
 * Therefore this function needs to be fed, as an INPUT, an array the size of the eventual OUTPUT so that is has some place to send
 * the values it calculates.  Since we insert interstitial zeroes [as mentioned above] AND append zeroes onto the end, the output ends
 * up being longer than the input.  Specifically, if the input is an array 'M' elements long, then the output will be '4M' elements long.
 *
 * Of course it follows, then, that 'X' must be declared (and properly sized!) in the same scope that this function ('FFT') gets called.
 * THIS IN AND OF ITSELF IS NOT A PROBLEM, BUT IT **MUST** BE KNOWN BY ANYONE WHO WANTS TO CALL THIS FUNCTION.  Supposing this function
 * is called repeatedly by a 'for' or other loop, declaration/initialization of 'X' needs to happen INSIDE the loop so that each time
 * the loop runs, 'X' gets re-declared at the new, proper size (use C standard library func. 'malloc' to do this).
 * 'M' is the length of the input 'x.'  Because of the whole pointer situation and many limitations of C in general, we cannot determine
 * how long 'x' (or 'X') is inside this function.  We can, however, keep track of it up above (in whatever scope calls this function) and
 * pass that value in to this function.  Note that 'M's type is "unsigned short."
 *
 *
 *      Author: Erik "Baron Flambo" Ringman
 */

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <dsplib674x.h>
#include <fftstuff.h>


//Function prototypes
void DSPF_sp_cfftr2_dit(float* x, float* w, unsigned short N);
void DSPF_sp_bitrev_cplx_cn(double* x, short* index, const int nx); //Not presently used
void gen_w_r2(float* w, int n);
void bit_rev(float* x, int n);
void bitrev_index(short *index, int nx);   //Not presently used
void gen_twiddle_fft_sp (float *w, int n); //Not presently used



void FFT(float*x, float*X, unsigned short M) {
	
	int N;
	N = (int) 2*M; //Integer of merit for many functions called herein.  Equal to the number of complex values that'll be in 'X' (which is twice as many as in 'x')

	int a; //Counter variable, gets used in several "for" loops.

	int b; /*This will be used for some of the bookkeeping in the loop immediately below */
	int c; /*Similar to b, this is used for different matrix indexing.*/

	for (a=0; a<M; a++) //Assign the data from x to every other slot in X, inserting zeroes in-between.
	{
		b=2*a;
		c=1+2*a;
		X[b]=x[a];
		X[c]=0;
	}

	for (a=2*M; a<2*N; a++) //Appends the additional zeroes on to the end.  Note that this is both the real and imaginary elements
	{
		X[a]=0;
	}

	float* w =(float*)malloc(sizeof(float)*M); //"w," twiddle-factor container, must be defined in this way since its length depends on a variable
	gen_w_r2(w,N); //Twiddle factor generation; function prototyped and included below

//------ACTUAL FFT HERE:----------------
	bit_rev(w, N >> 1);
	DSPF_sp_cfftr2_dit(X,w,N);
	/*bit_rev(X,N); */

	 	 	 	 /* These to bits (bit_rev & 'for' loop) are the parts that make the 'raw' outputs look like the Matlab outputs.  To
	 	 	 	  * re-include them in the code to be compiled, simply remove the comments around them. */
	/*
		for (a=0;a<2*N;a=a+2)
			{
			x[a+1]=-x[a+1];
			}
	*/
//--------------------------------------

}



//=============================================================================================
//Definitions of prototyped functions
//===================================


//-----------------------------------
/*Bit-Reversal Index.  Note that this is distinct from the "bit-reversal function" above.  That was pulled from "DSPF_sp_cfftr2_dit_d.c"
  while the following relates to the DSP library's bit-reversal function "DSPF_sp_bitrev_cplx" and was pulled from the file
  "DSPF_sp_bitrev_cplx_d.c"  This [supposedly] can provide an increase in speed, but a.) I've no reason to believe that, and b.) the
  bit-reversal code that I *am* presently using is short and seems to work just fine, so there doesn't seem to be any reason to change it.

  As it isn't being presently used, I've commented it out.  Only break glass in case of emergency

void bitrev_index(short *index, int nx)
{
    int i, j, k, radix = 2;
    short nbits, nbot, ntop, ndiff, n2, raddiv2;
    nbits = 0;
    i = nx;

    while (i > 1)
    {
        i = i >> 1;
        nbits++;
    }

    raddiv2 = radix >> 1;
    nbot = nbits >> raddiv2;
    nbot = nbot << raddiv2 - 1;
    ndiff = nbits & raddiv2;
    ntop = nbot + ndiff;
    n2 = 1 << ntop;
    index[0] = 0;

    for ( i = 1, j = n2/radix + 1; i < n2 - 1; i++)
    {
        index[i] = j - 1;
        for (k = n2/radix; k*(radix-1) < j; k /= radix)
            j -= k*(radix-1);
        j += k;
    }

    index[n2 - 1] = n2 - 1;

}
*/


//------------------------------------------------
//OLD Twiddle factor code
/*
void gen_twiddle_fft_sp (float *w, int n)
{
    int i, j, k;
    double x_t, y_t, theta1, theta2, theta3;
    const double PI = 3.141592654;

    for (j = 1, k = 0; j <= n >> 2; j = j << 2)
    {
        for (i = 0; i < n >> 2; i += j)
        {
            theta1 = 2 * PI * i / n;
            x_t = cos (theta1);
            y_t = sin (theta1);
            w[k] = (float) x_t;
            w[k + 1] = (float) y_t;

            theta2 = 4 * PI * i / n;
            x_t = cos (theta2);
            y_t = sin (theta2);
            w[k + 2] = (float) x_t;
            w[k + 3] = (float) y_t;

            theta3 = 6 * PI * i / n;
            x_t = cos (theta3);
            y_t = sin (theta3);
            w[k + 4] = (float) x_t;
            w[k + 5] = (float) y_t;
            k += 6;
        }
    }
}

*/

// END OF LINE
