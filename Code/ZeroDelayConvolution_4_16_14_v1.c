#define N 1024
#define H_BLOCKS 4
#define XBUCKET_BLOCKS 4
#define TRUE 1
#define FALSE 0

//these two are just place holders. in the final code write up, these will be removed
unsigned char rxBuffer;
unsigned char txBuffer;

//sample-based input buffer
float sampleInputBuffer[N];

//sample-based output buffer 
float sampleOutputBuffer[N];

static int largestSegToBlocks();
static void writeToInputBucket(float*, float*, int);
static void ZeroDelayConvolution(float*, float*, float*, float*, int);
static void fastConvolution(float*, float*, float*, int, int, int, int, int);
static void complexFastMult(float*, float*, float*, int);
static void outputComp(float*, float*, int, int, int);

static void BufferBytesToSamples(unsigned char);
static void BufferSamplesToBytes(float*);

static void outputComp(float* output_bucket, float* fastConvResult, int output_bucket_startindex, int output_Size, int output_bucket_Size)
{

	//save fast convolution to output bucket
	int i;
	for(i = 0; i < output_Size; i++)
	{
		output_bucket[output_bucket_startindex + i] += fastConvResult[i];
	}
	
	//copy first N samples of output bucket to output buffer
	for(i = 0; i < N; i++)
	{
		sampleOutputBuffer[i] = output_bucket[i];
	}
	
	//shift output bucket data to the left by N samples
	//zero out elements which were at the tail end
	//pretty sure the memmove and memset approach will work, but will keep commented for now
	//memmove(output_bucket,output_bucket+N,(output_bucket_Size - N)*sizeof(float));
	//memset(output_bucket+output_bucket_Size-N,0,N*sizeof(float));
	 
	//shifting output bucket data to the left by N samples
	for(i = 0; i < (output_bucket_Size - N); i++)
	{
		output_bucket[i] = output_bucket[N+i];
	}
	
	//zero out elements which were at the tail end
	for(i = (output_bucket_Size - N); i < output_bucket_Size; i++)
	{
		output_bucket[i] = 0;
	}
}

static void fastConvolution(float* fastConvResult,float* ir,float* x_bucket,int ir_startindex,int ir_Size,int x_bucket_startindex,int x_Size,int ish0convolution)
{
	int x_fft_input_Size;
	int ir_fft_input_Size;

	//if convolving with h0, do this
	if(ish0convolution == TRUE)
	{
		//set sizes of the arrays that will be passed to FFT function. Both need to be set to 4*N
		x_fft_input_Size = 2*N;
		ir_fft_input_Size = 2*N;
	}
	else
	{
		//set sizes of the arrays that will be passed to FFT function. Both need to be set to 4*N
		x_fft_input_Size = x_Size;
		ir_fft_input_Size = ir_Size;	
	}
		
	//FFT input arrays declared, set to size as stipulated above
	//float x_fft_input[x_fft_input_Size];
	//float ir_fft_input[ir_fft_input_Size];
		
	float* x_fft_input = (float*) malloc(sizeof(float)*x_fft_input_Size);
	float* ir_fft_input = (float*) malloc(sizeof(float)*ir_fft_input_Size);
	
	//copy over input bucket data to FFT input array for the input signal
	int i;
	for(i=0;i<x_Size;i++)
	{
		x_fft_input[i] = x_bucket[x_bucket_startindex+i];
	}
		
	//copy over IR data to FFT input array for the IR
	for(i=0;i<ir_Size;i++)
	{
		ir_fft_input[i] = ir[ir_startindex+i];
	}
		
	//set sizes of the arrays that will contain the result of the FFTs. These will be double of the input and ir arrays
	int X_Size = 4*x_fft_input_Size;
	int IR_Size = 4*ir_fft_input_Size;
		
	//FFT output arrays declared, set to double the size of the FFT input arrays
	//float X[X_Size];
	//float IR[IR_Size];
		
	float* X = (float*) malloc(sizeof(float)*X_Size);
	float* IR = (float*) malloc(sizeof(float)*IR_SIZE);
	
	//Call FFT function, write to X_fft_output and IR_fft_output
	FFT(x_fft_input,X,x_fft_input_Size);
	FFT(ir_fft_input,IR,ir_fft_input_Size);
		
	//Declare function that will contain the complex multiplication results
	//float complexFastMultResult[X_Size];
	
	float* complexFastMultResult = (float*) malloc(sizeof(float)*X_Size);
	
	//Performs multiplication of two complex arrays
    for(i=0; i<2*x_fft_input_Size; i++)
    {
    	//(a + ib)(c + id) = ac - bd + i (ad + bc)

    	//Real part
    	complexFastMultResult[2*i] = X[2*i]*IR[2*i] - X[2*i+1]*IR[2*i+1];

    	//Imaginary Part
    	complexFastMultResult[2*i+1] = X[2*i]*IR[2*i+1] + X[2*i+1]*IR[2*i];

    }	

	
	//Call IFFT to convert data in complexFastMultResult to the time domain and write it to fastConvResult
	IFFT(complexFastMultResult,fastConvResult,x_fft_input_Size*2);		
	
	free(x_fft_input);
	free(ir_fft_input);
	free(X);
	free(IR);
	free(complexFastMultResult);
	
}

static void writeToInputBucket(float* sampleInputBuffer, float* x_bucket, int block_Counter)
{
	int i;
	int startindex = (block_Counter - 1)*N;
	for(i = 0; i < N; i++)
	{
		 x_bucket[startindex + i] = sampleInputBuffer[i];
	}
}

static void ZeroDelayConvolution(float* sampleInputBuffer, float* ir, float* x_bucket, float* output_bucket, int output_bucket_Size)
{
	static int block_Counter = 0;
	block_Counter++;
	writeToInputBucket(sampleInputBuffer,x_bucket,block_Counter);
	
	//starting index and number of blocks of ir to read from
	int ir_startindex;
	//int ir_endindex;
	int ir_Size;
	
	//starting index and number of blocks of x_bucket to read from
	int x_bucket_startindex;
	//int x_bucket_endindex;
	int x_Size;
	
	//starting index and number of blocks of output_bucket to write to
	int output_bucket_startindex;
	int output_Size;
	
	//flag indicating whether we are performing convolution with h0 or another block
	int ish0convolution; 
	
	/************ convolution with h0 ****************/
	
	//set h0 flag to true
	ish0convolution = TRUE;
	
	//starting index and number of samples for ir
	ir_startindex = 0;
	//ir_endindex = 2N - 1;
	ir_Size = 2*N;
	
	//starting index and number of samples for x_bucket
	x_bucket_startindex = (block_Counter - 1)*N;
	//x_bucket_endindex = (block_Counter)*N - 1;
	x_Size = 1*N;
	
	//array containing h0 convolution result
	//float h0fastConvResult[4*N];
	float h0fastConvResult = (float*) malloc(sizeof(float)*(4*N));
	
	//get result of convolution between h0 and buffer of input
	fastConvolution(h0fastConvResult,ir,x_bucket,ir_startindex,ir_Size,x_bucket_startindex,x_Size,ish0convolution);	
	
	//starting index and number of samples for output_bucket 
	output_bucket_startindex = 0;
	//int output_bucket_endindex = 4N - 1;
	output_Size = 4*N;
	
	//add result to the output bucket
	outputComp(output_bucket,h0fastConvResult,output_bucket_startindex,output_Size,output_bucket_Size);
	
	
	/************* convolution with the rest of impulse response *************/
	
	//set h0 flag to false
	ish0convolution = FALSE;
	
	//declare mult_Factor
	int mult_Factor = 1;
	
	int impulse_IterateTotal = ceil(log2(H_BLOCKS)) - 1;
	
	int impulse_Counter;
	
	for(impulse_Counter = 1; impulse_Counter <= impulse_IterateTotal; impulse_Counter++)
    {
            
        if(block_Counter % mult_Factor == 0)
        {
			//starting index and number of samples for ir
			ir_startindex = (2*mult_Factor)*N;
			ir_Size = mult_Factor*N;
                
            //starting index and number of samples for x_bucket
            x_bucket_startindex = (block_Counter - mult_Factor)*N;
            x_Size = mult_Factor*N;
            
            //array containing convolution result (odd numbered h-segments)
			//float hofastConvResult[2*mult_Factor*N];                        
			
			float* hofastConvResult = (float*) malloc(sizeof(float)*(2*mult_Factor*N));
			
			//get result of convolution between h0 and buffer of input
			fastConvolution(hofastConvResult,ir,x_bucket,ir_startindex,ir_Size,x_bucket_startindex,x_Size,ish0convolution);
            
            //starting index and number of samples for output_bucket
            output_bucket_startindex = (2*mult_Factor)*N;
            output_Size = (2*mult_Factor)*N;
            
            //add result to the output bucket
			outputComp(output_bucket,hofastConvResult,output_bucket_startindex,output_Size,output_bucket_Size);
                
            //Handles the last block of the impulse response
            if(impulse_Counter != impulse_IterateTotal || impulse_IterateTotal == floor(log2(H_BLOCKS)) - 1)
            {
				//starting index and number of samples for ir
				ir_startindex = (3*mult_Factor)*N;
				ir_Size = mult_Factor*N;
            
            	//array containing convolution result (even numbered h-segments)
				//float hefastConvResult[2*mult_Factor*N];                        
			
				float* hefastConvResult = (float*) malloc(sizeof(float)*(2*mult_Factor*N));
				
				//get result of convolution between h0 and buffer of input
				fastConvolution(hefastConvResult,ir,x_bucket,ir_startindex,ir_Size,x_bucket_startindex,x_Size,ish0convolution);
            
            	//starting index and number of samples for output_bucket
            	output_bucket_startindex = (3*mult_Factor)*N;
            	output_Size = (2*mult_Factor)*N;
            
            	//add result to the output bucket
				outputComp(output_bucket,hefastConvResult,output_bucket_startindex,output_Size,output_bucket_Size); 
				
				free(hefastConvResult);
            }
			
			free(hofastConvResult);
                
        }
            //Double the mult_Factor
            mult_Factor *= 2;
    }
    
    if(block_Counter == XBUCKET_BLOCKS)
    {
        block_Counter = 0;
    }
	 
	free(h0fastConvResult); 
}

static void BufferBytesToSamples(unsigned char rxbuffer)
{
	//blaablaablaa
}

static void BufferSamplesToBytes(float* sampleOutputBuffer)
{
	//blaablaablaa
}

static int largestSegToBlocks()
{	
	int mult_Factor;
	
	if(H_BLOCKS == 2)
	{
		mult_Factor = 2;
	}
	else
	{
		int ir_blocktotal = 2;
		mult_Factor = 1;
		
		while(ir_blocktotal < H_BLOCKS)
		{
			ir_blocktotal += 2*mult_Factor;
			mult_Factor *= 2;
		}
	}
	return mult_Factor/2;
}	   

 int main()
 {
     //stuff happens to set up interrupt handlers and so forth
     //-------------------------------------------------------
     
     /*****************************
     -initiate ir and x_bucket arrays
     -both are in time domain
     -ir contains the entire ir signal
     -x_bucket contains input signal blocks upto length of ir
     *******************************/
     
     int ir_Size = H_BLOCKS*N;
     int x_bucket_Size = XBUCKET_BLOCKS*N;
     
     //float ir[ir_Size];
     //float x_bucket[x_bucket_Size];
     
	 //instantiate ir and x_bucket arrays
	 float* ir = (float*) malloc(sizeof(float)*ir_Size);
	 float* x_bucket = (float*) malloc(sizeof(float)*x_bucket_Size);
	 
     //compute size of largest segment in ir
     int largestsegment_BLOCKS = largestSegToBlocks();
     
     //use the number of blocks in largest segment to compute the output_Bucket size
     int output_bucket_BLOCKS = H_BLOCKS + largestsegment_BLOCKS;
     int output_bucket_Size = output_bucket_BLOCKS*N;
     //float output_bucket[output_bucket_Size];
     
	 //instantiate output_bucket
	 float* output_bucket = (float*) malloc(sizeof(float)*output_bucket_Size);
	 
     //set output_Bucket to 0's. might or might not have to do this
     memset(output_bucket,0,sizeof(output_bucket));
     
     while(1)
     {
     	BufferBytesToSamples(rxBuffer);
     	ZeroDelayConvolution(sampleInputBuffer,ir,x_bucket,output_bucket,output_bucket_Size);
     	BufferSamplesToBytes(sampleOutputBuffer);
     	//memcpy(blaa blaa blaa);
     }
	 
	 free(ir);
	 free(x_bucket);
	 free(output_bucket);
     return 0;          
 }