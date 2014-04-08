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
 * This function performs a few auxiliary tasks necessary for working in the language of Code Composer, and C in general.  Feed in the
 * array you want an FFT taken of.  This function will add enough zeroes on the end for the length to be twice the original length,
 * minus one (as it needs to be for convolution).  Next, zeroes are inserted in-between every other element in the array (so, if the
 * original array was [x, x2, x3, x4, etc...] the new array will be [x, 0, x1, 0, x3, 0, x4, 0, etc...].  This is because the actual
 * FFT operation expects to read an array of 2N long representing N complex numbers; the first, third, fifth, etc... entries in the
 * array are the real parts and the second, fourth, sixth, etc... entries are the complex parts.
 *
 * Furthermore, and of particular concern with regard to this function communicating with the scope in which it is called, arrays cannot
 * be returned as results of functions in C.  This is why techniques like pointers and overwriting the input vector are used.
 * Therefore this function needs to be fed, as an INPUT, an array the size of the eventual OUTPUT so that is has some place to send
 * the values it calculates.  Since we insert interstitial zeroes [as mentioned above] AND append zeroes onto the end (the array to be
 * FFT'd must be (2*input length)-1 long, the output ends up being longer than the input.  Specifically, if the input is an array 'M'
 * elements long, then the output will be an array '4M - 2' elements long.  The two inputs to this function are 'x' and 'X.'  'x' is the
 * actual unprocessed audio data samples and is 'M' long, 'X' is an empty array ready and waiting for input that's '4M-2' long.  Of
 * course it follows, then, that 'X' must be declared (and properly sized!) in the same scope that this function ('FFT') gets called.
 * THIS IN AND OF ITSELF IS NOT A PROBLEM, BUT IT **MUST** BE KNOWN BY ANYONE WHO WANTS TO CALL THIS FUNCTION.  Supposing this function
 * is called repeatedly by a 'for' or other loop, declaration/initialization of 'X' needs to happen INSIDE the loop so that each time
 * the loop runs, 'X' gets re-declared at the new, proper size.
 *
 *
 *      Author: Erik "Baron Flambo" Ringman
 */

#include <math.h>
#include <stdio.h>
#include <dsplib674x.h>

#define NELEMS(x)  (sizeof(x) / sizeof(x[0])) //makes it simple to get array length with one function, akin to how we do in Matlab

//Function prototypes
void DSPF_sp_cfftr2_dit(float* x, float* w, unsigned short N);
void DSPF_sp_bitrev_cplx_cn(double* x, short* index, const int nx);
void gen_w_r2(float* w, int n);
void bit_rev(float* x, int n);
void bitrev_index(short *index, int nx);   //Not presently used
void gen_twiddle_fft_sp (float *w, int n); //Not presently used



void FFT(float*x, float*X) {
	
	M=NELEMS(x); //Getting M as the ORIGINAL length of the vector to be convolved 'x'
	N=-2+M*4; // This is the ULTIMATE length of the array that A.) needs to be convolved and B.) will be output.  If easier, make "N=NELEMS(X);"
	float X[N];
	int a; //Counter variable, gets used in several "for" loops.  C doesn't allow declaration/initialization in the loop defintion line
	       //itself, so I declare 'a' here and use it as the counter in any given loop.
	int b; /*This will be used for some of the bookkeeping in the loop immediately below; when referencing an array index in C you cannot
	         do a computation, you must be specifically referencing a numerical location. */
	int c; /*Similar to b, this is used for different matrix indexing.*/
	for (a=0; a<M; a++) //Assign the data from x to every other slot in X, inserting zeroes in-between.
	{
		b=2*a;
		c=1+2*a;
		X[b]=x[b];
		X[c]=0;
	}
	for (a=2*M+1; a<=N; a++) //Appends the additional zeroes on to the end.  Note that this is both the real and imaginary elements
	{
		X[a]=0;
	}
	b=N/2; // 'b' from above is useless now, so I'll take over that variable to initialize 'w' (contains all the twiddle factors)
	float w [b];
	gen_w_r2(w,N); //Twiddle factor generation; function prototyped and included below

//------ACTUAL FFT HERE:----------------
	bit_rev(w, N >> 1);
	DSPF_sp_cfftr2_dit(X,w,N);
	bit_rev(X,N);
//--------------------------------------

	return 0;
}



//=============================================================================================
//Definitions of prototyped functions
//===================================
/* generate real and imaginary twiddle table of size n/2 complex numbers */
void gen_w_r2(float* w, int n)
{
    int i;
    float pi = 4.0 * atan(1.0);
    float e = pi * 2.0 / n;

    for(i = 0; i < (n >> 1); i++)
    {
        w[2 * i] = cos(i * e);
        w[2 * i + 1] = sin(i * e);
    }
}


//------------------------------
//Bit-Reversal Function

void bit_rev(float* x, int n)
{
    int i, j, k;
    float rtemp, itemp;
    j = 0;

    for(i=1; i < (n-1); i++)
    {
        k = n >> 1;

        while(k <= j)
        {
            j -= k;
            k >>= 1;
        }

        j += k;

        if(i < j)
        {
            rtemp = x[j*2];
            x[j*2] = x[i*2];
            x[i*2] = rtemp;
            itemp = x[j*2+1];
            x[j*2+1] = x[i*2+1];
            x[i*2+1] = itemp;
        }
    }
}


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
