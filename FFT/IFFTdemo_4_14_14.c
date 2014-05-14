/* ===================================================================================
 * Inverse Fast Fourier Transform; Self-Contained
 * ===================================================================================
 * ==============================================================
 * ========================================
 *
 * IFFTdemo.c
 *
 * Description of function, inputs, outputs.  This is a DEMONSTRATIVE function to see if it works right; use "IFFT.c" to pass in & out
 *
 *
 * Like the FFT function, this one uses arrays of the form [Real1, Imag1, Real2, Imag2, etc...] to represent an array of complex numbers.
 * Ultimately, it will provide an array of ONLY the real parts, since there should be no imaginary parts.
 *
 * 'Y' is the input array, length '4M-2,' where 'M' is the length of the input block that underwent a fast Fourier transform and was
 * ultimately used to create 'Y.'  Just as 'X' was an output container for the FFT function results, 'y' will be the output container
 * for this function's results.
 *
 *
 *
 *
 *  Created on: Apr 4, 2014
 *      Author: Erik "Cap'n Long Dong Silver" Ringman
 */


#include <math.h>
#include <stdio.h>
#include <dsplib674x.h>
#include <fftstuff.h>
#include <stdlib.h>


//Function prototypes
void DSPF_sp_icfftr2_dif(float* x, float* w, unsigned short n);
void gen_w_r2(float* w, int n);
void bit_rev(float* x, int n);



void main(void)
{

	float A[128] = {43.000000,0.000000,  3.616321,30.125547,  -14.479670,-2.567202,  12.362492,-21.842867,  32.385956,13.828468,  -7.707342,18.480019,  1.519983,-3.868871,  4.327905,-4.279924,  20.798990,2.485281,  2.305606,11.042850,  16.090977,2.064070,  5.466386,19.738562,  0.345887,10.251665,  -3.438493,4.526769,  12.931265,9.287642,  -14.795074,12.285769,  17.000000,-10.000000,  4.956760,30.588863,  -4.126019,7.640384,  -12.621098,21.370527,  -6.488023,-10.174742,  1.631006,20.984383,  -14.443722,-3.912756,  6.433661,14.007210,  -18.798990,14.485281,  -23.586613,0.723100,  -5.995662,-12.674122,  -23.052052,8.538252,  -10.243816,-50.597946,  35.359089,3.127013,  8.502851,-7.042882,  24.741423,53.781017,  -81.000000,0.000000,  24.741428,53.781006,  8.502846,-7.042882,  35.359089,3.127012,  -10.243820,-50.597939,  -23.052046,8.538255,  -5.995665,-12.674120,  -23.586613,0.723101,  -18.798990,14.485281,  6.433663,14.007207,  -14.443724,-3.912753,  1.631013,20.984381,  -6.488022,-10.174742,  -12.621092,21.370529,  -4.126016,7.640386,  4.956764,30.588863,  17.000000,-10.000000,  -14.795071,12.285774,  12.931269,9.287637,  -3.438493,4.526770,  0.345886,10.251665,  5.466391,19.738560,  16.090977,2.064065,  2.305608,11.042850,  20.798990,2.485281,  4.327904,-4.279922,  1.519982,-3.868872,  -7.707339,18.480021,  32.385952,13.828463,  12.362488,-21.842869,  -14.479672,-2.567199,  3.616327,30.125546};
	unsigned short N=64; //There're 64 complex numbers in A, taking up 128 array entries.
	float y[63];

	//PRINT FFT'd VALUES (inputs)
	printf("Original Inputs (Results of an FFT w/ Post-Processing (a-la Matlab):");
	printf("\n");
	int i;
	int a;
	for(i=0;i<N;i=i+2)
	{
		printf("%f",A[i]);
		printf("  ");
		printf("%f i",A[i+1]);
		printf("\n");
	}

	printf("\n");

	float* w =(float*)malloc(sizeof(float)*(N/2));
	gen_w_r2(w,N);
	bit_rev(w, N>>1 );

	printf("\n");

	//"Fixing" the FFT results; I.E. undoing post-processing----------------
	for (a=0;a<N;a=a+2)
	{
		A[a+1]=-A[a+1];
	}
	bit_rev(A,N);
	//----------------------------------------------------------------------

	printf("FFT'd Results, WITHOUT Post-Processing");
	printf("\n");
	for (i=0;i<N;i=i+2)
	{
		printf("%f",A[i]);
		printf("  ");
		printf("%f",A[i+1]);
		printf(" i;");
		printf("\n");
	}
	printf("\n");

	//IFFT here:
	DSPF_sp_icfftr2_dif(A,w,N);



	//Scale by N
	for (i = 0; i < N*2; i++) /*ACHTUNG! Originally the limiting condition was "i < N*2"  because "N" represents the number of COMPLEX
								numbers in the array; since it takes two array entries (real & imaginary) to represent one complex\
								number, the array is twice as long as this "N."  If there's a problem with the IFFT, consider changing
								this first to see if anything's solved.*/
	   {
	       A[i] /= N;
	   }

	printf("IFFT'd Final Outputs");
	printf("\n");
	//PRINT IFFT'd VALUES (OUTPUTS)
	for (i=0;i<N;i=i+2)
	{
		printf("%f",A[i]);
		printf("  ");
		printf("%f",A[i+1]);
		printf(" i;");
		printf("\n");
	}

	//Now we should have no complex values, so even indices of Y are real-valued and odd (cpx) indices or Y are zeroes.  We now chop out
	//these interstitial zeroes
	//float* y =(float*)malloc(sizeof(float)*(N-1));
	for (i=0; i<N-1;i++)
	{
		y[i]=A[2*i];
		printf("%i \n",i);
		printf("%f \n",y[i]);
	}

}

// END OF LINE
