/* ===================================================================================
 * Fast Fourier Transform; Self-Contained
 * ===================================================================================
 * ==============================================================
 * ========================================
 *
 * fftDEMOfull.c
 *
 */


#include <math.h>
#include <stdio.h>
#include <dsplib674x.h>
#include <fftstuff.h>
#include <stdlib.h>

#define NELEMS(x)  (sizeof(x) / sizeof(x[0])) //makes it simple to get array length with one function, akin to how we do in Matlab


void DSPF_sp_cfftr2_dit(float* x, float* w, unsigned short N);
void DSPF_sp_bitrev_cplx_cn(double* x, short* index, const int nx); //Not presently used
void gen_w_r2(float* w, int n);
void bit_rev(float* x, int n);
void bitrev_index(short *index, int nx);   //Not presently used
void gen_twiddle_fft_sp (float *w, int n); //Not presently used



int mainFFTdemoFULL(void) {
	

	unsigned short M=32; //Original array length
	int N;
	N = (int) 2*M; //Integer of merit for many functions called herein.  Equal to the number of complex values that'll be in 'x' (which is twice as many as in 'A')
	float A [32] = {1, 8, 2, -4, 3, -2, 1, 2, -1, 4, -8, 5, -3, 5, -2, 9, 1, 7, 2, 8, 2, -2, 1,2, -1, 4, -8, 5, -3, 2,-6, 9};

	/* The FFT function is equipped for complex inputs; it expects arrays to be in the form of every other entry being imaginary.
	 * For example, the list of complex numbers "cpx1, cpx2, cpx3, etc..." would be stored in an array with the form:
	 * [Real1, Imag1, Real2, Imag2, Real3, Imag3, etc...]    Since we are only feeding real numbers in, we must insert zeroes
	 * as every other entry in the array.  For this test, the array above has simply been initialized with zeroes.*/
	int a;
	int b;
	int c;
	float* x =(float*)malloc(sizeof(float)*4*M);
	for (a=0; a<M; a++) //Assign the data from x to every other slot in X, inserting zeroes in-between.
	{
		b=2*a;
		c=1+2*a;
		x[b]=A[a];
		x[c]=0;
		printf("first loop %f \n",x[a]);
	}

	for (a=2*M; a<4*M; a++) //Appends the additional zeroes on to the end.  Note that this is both the real and imaginary elements
	{
		x[a]=0;
		printf("second loop %f %i \n",x[a],a);
	}



	float* w =(float*)malloc(sizeof(float)*M);
	gen_w_r2(w,N);

//------ACTUAL FFT HERE:----------------
	bit_rev(w, N >> 1);
	DSPF_sp_cfftr2_dit(x,w,N);
//--------------------------------------

//---------------------------------<Printing>-------------
	printf("FFT x, UNPROCESSED");
	printf("\n");
	for(a=0; a<4*M; a=a+2)
	{
		printf("%f", x[a]);
		printf("  ");
		printf("%f", x[a+1]);
		printf(" i");
		printf("\n");
	}



	printf("this is fftdemo FULL");

//--------------------------------</Printing>------------^

//"Fixing" the results, I.E. giving them the 'Matlab look'-------
	bit_rev(x,N);
	for (a=0;a<2*M;a=a+2)
		{
		x[a+1]=-x[a+1];
		}
//----------------------------------------------------------------

//---------------------------------<Printing>-------------
	printf("FFT x (Extra Matlab Flavour)");
	printf("\n");
	for(a=0; a<4*M; a=a+2)
	{
	    printf("%f", x[a]);
	    printf("   ");
	    printf("%f", x[a+1]);
	    printf(" i");
	    printf("\n");
	}



	printf("this is fftdemo FULL");
	//--------------------------------</Printing>------------^

	return 0;
}



//-------------------------------------------------------------------------

//-----------------------------------
/*Bit-Reversal Index.  Note that this is distinct from the "bit-reversal function" above.  That was pulled from "DSPF_sp_cfftr2_dit_d.c"
  while the following relates to the DSP library's bit-reversal function "DSPF_sp_bitrev_cplx" and was pulled from the file
  "DSPF_sp_bitrev_cplx_d.c"

  As it isn't being presently used, I've commented it out.

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
//OLD Twiddle factor code; Only break glass in case of emergency
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
