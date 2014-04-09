//
//  main.c
//  Zero Delay Algorithm
//
//  Created by Santosh Kantharaj on 3/29/14.
//  Copyright (c) 2014 Santosh Kantharaj. All rights reserved.
//

#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <complex.h>

//Number of samples in a block
#define N 32

//Number of blocks of input
#define x_Total 1024

//Number of blocks of impulse response
#define h_Total 512

void standConv(float*, int, float*, float*);
complex double* IRComp(float*,int,int,int);
complex double* XComp(float*,int,int,int);
void outputComp(float*,int,int,int,double complex*,double complex*,int);
void zerodelayconvolution();

//as mentioned earlier, we'll probably just do fast convolution here instead
void standConv(float *y, int block_Counter, float* x, float* h)
{
   //compute standard convolution.
   //take samples 0 to 2N-1 of impulse response
   //convolve this with (block_Counter - 1)*N  to block_Counter*N - 1
   //these numbers will probably not be relevant, as we will be getting
   //the input signal one input buffer at a time and won't have the whole
   //thing at once
   
    int standConv_OutputSize = 3*N - 1;
    float* standConv_Output = (float*) malloc(sizeof(float)*standConv_OutputSize);
    //compute standard conv and put it in output array
    //------------------------------------------------
    
    //compute the starting index to write to time-domain output array
    int output_StartIndex = (block_Counter)*N;
    //int output_EndIndex = (block_Counter + 2)*N - 2;
    
    //compute values for output array
    for(int i=0; i < standConv_OutputSize; i++)
    {
        y[output_StartIndex+i] += standConv_Output[i];
    }
    
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

void zerodelayconvolution()
{
    //computes the number of elements in the input signal and impulse response vectors
    int input_Size = x_Total*N;
    int impulse_Size = h_Total*N;
    
    //Fill input signal vector with random numbers
    float* x = (float*) malloc(input_Size*sizeof(float));
    
    //Call to random number generator seed
    srand( (unsigned int) time(NULL) );
    
    for(int i=0; i<input_Size; i++)
    {
        //limits random numbers between 1 and 10
        x[i] = rand() % 10 + 1;
    }
    
    //Fill input signal vector with random numbers
    float* h = (float*) malloc(impulse_Size*sizeof(float));
    
    //Fill input signal vector with random numbers
    for(int i=0; i<impulse_Size; i++)
    {
        //limits random numbers between 1 and 10
        h[i] = rand() % 10 + 1;
    }
    
    //Final output array filled with 0's
    int y_Size = input_Size + impulse_Size - 1;
    float* y = (float*) malloc(y_Size*sizeof(float));
    memset(y,0,y_Size*sizeof(int));
    
    for(int block_Counter = 0; block_Counter < x_Total; block_Counter++)
    {
        //convolution with h0
        //Perform standard convolution
        //Save result to output array
        //standConv(&y,block_Counter,x,h);
        
        int mult_Factor = 1;
        
        int impulse_IterateTotal = ceil(log2(h_Total)) - 1;
        
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
                if(impulse_Counter != impulse_IterateTotal || impulse_IterateTotal == floor(log2(h_Total)) - 1)
                {
                    //take the fft of the IR
                    IR = IRComp(h,3*mult_Factor,4*mult_Factor,2*mult_Factor);
                    
                    outputComp(y,block_Counter,2*mult_Factor,4*mult_Factor,IR,X,2*mult_Factor);
                }
                
            }
            //Double the mult_Factor
            mult_Factor *= 2;
        }
        
    }
}

int main(int argc, const char * argv[])
{
    zerodelayconvolution();
    
    return 0;
}

