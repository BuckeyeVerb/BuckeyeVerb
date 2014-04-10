/* ===================================================================================
 * Inverse Fast Fourier Transform; Self-Contained
 * ===================================================================================
 * ==============================================================
 * ========================================
 *
 * IFFT.c
 *
 * Description of function, inputs, outputs.  Since many things are repeated from/similar to the 'FFT.c' function, it is recommended
 * that you read that first.  This description will be much more succinct.
 *
 * Like the FFT function, this one uses arrays of the form [Real1, Imag1, Real2, Imag2, etc...] to represent an array of complex numbers.
 * Ultimately, it will provide as a result an array of ONLY the real parts, since there should be no imaginary parts.
 *
 * 'Y' is the input array, length '4M-2,' where 'M' is the length of the input block that underwent a fast Fourier transform and was
 * ultimately used to create 'Y' (see the introductory comments in the 'FFT.c' function for more detail).  Just as 'X' was an output
 * container for the FFT function results, 'y' will be the output container for this function's results.
 *
 * Finally - and, once more, akin to 'FFT.c' - this function CANNOT calculate array lengths for itself (of arrays passed in to it via
 * pointers, that is).  Ergo it needs the input 'N.'  'N' is the length of the thing which you desire to have IFFT'd, namely 'Y.'
 *
 *
 *  Created on: Apr 4, 2014
 *      Author: Erik "Cap'n Long Dong Silver" Ringman
 */

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <dsplib674x.h>
#include <fftstuff.h>

//Function prototypes
void DSPF_sp_icfftr2_dif(float* x, float* w, unsigned short n);
void gen_w_r2(float* w, int n);
void bit_rev(float* x, int n);



void IFFT(float*Y, float*y, unsigned short N)
{
	int b=N/2;
	float* w =(float*)malloc(sizeof(float)*b);
	gen_w_r2(w,b);
	bit_rev(w, b>>1 );
	DSPF_sp_icfftr2_dif(Y,w,b);

/*Corrections required in case FFT.c was modified with similar corrections.  This'd be done only for the purpose of getting
 * outputs that resemble the Matlab outputs.  Only break glass in case of emergency.
 */
/*	bit_rev(Y,b);
 *  int a;
	for (a=0;a<2*N;a=a+2)
		{
		Y[a+1]=-y[a+1];
		}

 */


	//Scale by N:
	int i;
	for (i = 0; i < N; i++)
	   {
	       Y[i] /= b;
	   }

	//Now we should have no complex values, so even indices of Y are real-valued and odd (cpx) indices or Y are zeroes.  We now chop out
	//these interstitial zeroes
	for (i=0; i<(N/2)-1;i++) //Note the loop end condition "i<(N/2)-1"  This is so that we extract every real value except the last one.  For purposes relating to the radix-2 constraint of the FFT/IFFT functions, we calculate FFTs that're one audio sample longer than necessary, and at the end we discard the final value in the convolved output.
	{
		y[i]=Y[2*i];
	}

}




// END OF LINE

