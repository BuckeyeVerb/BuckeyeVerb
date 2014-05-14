/* ===================================================================================
 * Inverse Fast Fourier Transform; Self-Contained
 * ===================================================================================
 * ==============================================================
 * ========================================
 *
 * IFFT.c
 *
 *
 *
 * INPUTS  & OUTPUTS:
 *
 * Y = The thing you want to take an inverse fast Fourier transform of.  If it's not a power of two, you're gonna have a bad time.  Type: array of floats
 * y = Container to receive the calculated results of this function.  Must be declared in scope that calls this function, SEE DETAILS in desc. below.  Type: array of floats
 * N = number of complex numbers represented in the array 'Y.'  This is exactly half the length (number of entries) in 'Y'  Type: unsigned short
 *
 *
 * DESCRIPTION:
 *
 * Since many things are repeated from/similar to the 'FFT.c' function, it is recommended
 * that you read that first.  This description will be significantly condensed by comparison.
 *
 * Like the FFT function, this one uses arrays of the form [Real1, Imag1, Real2, Imag2, etc...] to represent an array of complex numbers.
 * Ultimately, it will provide as a result an array of ONLY the real parts, since there should be no imaginary parts.
 *
 * 'Y' is the input array, length '4M' where 'M' is the length of the original input block that underwent a fast Fourier transform and was
 * ultimately used to create 'Y' (see the introductory comments in the 'FFT.c' function for more detail).  Just as 'X' was an output
 * container for the FFT function results, 'y' will be the output container for this function's results and therefore must be declared
 * in the scope that calls this function.  Use 'malloc' to accomplish this.  The length of 'y' is to be 2M-1, where M is the same as stated
 * above.  For ease of understanding, know that M=(length of input 'Y')/4.  Don't worry about anything else, this function'll take care
 * of it for you, just make sure 'y' is 2M-1 and everything'll be kosher.
 *
 * Finally - and, once more, akin to 'FFT.c' - this function CANNOT calculate array lengths for itself (of arrays passed in to it via
 * pointers, that is).  Ergo it needs the input 'N.'  'N' is the number of complex values represented by the thing which you desire
 * to have IFFT'd, namely 'Y.'  That is to say, its value is EXACTLY half the number of elements in the input array 'Y.'
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
	int a; //Counter variable for loops

	float* w =(float*)malloc(sizeof(float)*(N/2));
	gen_w_r2(w,N);
	bit_rev(w, N>>1 );

/*Corrections required in case FFT.c was modified with similar corrections.  This may need to be done for the purpose of making the
 * complex multiplication step work properly.  Only break glass in case of emergency. */
/*
    for (a=0;a<N;a=a+2)
	{
		Y[a+1]=-Y[a+1];
	}

	bit_rev(Y,N);
*/

	//IFFT here:
	DSPF_sp_icfftr2_dif(Y,w,N);

	//Scale by N:
	int i;
	for (i = 0; i < N*2; i++)
	   {
	       Y[i] /= N;
	   }

	/*Now we should have no complex values, so even indices of Y are real-valued and odd (cpx) indices or Y are zeroes.  We now chop out
	  these interstitial zeroes
	  Note the loop end condition "i<(N/2)-1"  This is so that we extract every real value except the last one.  For purposes relating
	   to the radix-2 constraint of the FFT/IFFT functions, we calculate FFTs that're one audio sample longer than necessary, and at
	   the end we discard the final value in the convolved output. */
	for (i=0; i<N-1;i++)
	{
		y[i]=Y[2*i];
	}

}

//It's divine
//when you can end code so fine
//on that sweet line
//number ninety-nine.
