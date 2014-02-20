%assuming that the number of blocks goes from h0 to h6.
N = 4;

%number of blocks of input
x_Total = 1000;

%Fill input signal vector with random numbers
x = rand(1,x_Total*N);

%value of blocks of impulse response
h_Total = 32;

%Fill input signal vector with random numbers
h = rand(1,h_Total*N);

%Final output array filled with 0's
y = zeros(1,(length(x) + length(h)) - 1);

for block_Counter = 1:x_Total
    %standard convolve N samples with h0 
    y = standConv(y,block_Counter,x,h,N);
    
    %fast convolve h1 with N samples 
    IR = IRComp(h,2,3,2,N);
    X = XComp(x,block_Counter,1,2,N);    
    
    y = outputComp(y,block_Counter,1,3,IR,X,N);
    
    %fast convolve h2 with N samples
    IR = IRComp(h,3,4,2,N);
    
    y = outputComp(y,block_Counter,2,4,IR,X,N);
    
    %Every second block of input signal requires convolution between 2N sized
    %samples with h3 and h4
    
    if rem(block_Counter,2) == 0
        %fast convolve h3 with 2N samples
        IR = IRComp(h,4,6,4,N);
        
        X = XComp(x,block_Counter,2,4,N);
        
        y = outputComp(y,block_Counter,2,6,IR,X,N);
        
        %fast convolve h4 with 2N samples 
        IR = IRComp(h,6,8,4,N);
        
        y = outputComp(y,block_Counter,4,8,IR,X,N);
    end
    
    if rem(block_Counter,4) == 0
        %fast convolve h5 with 4N samples 
        IR = IRComp(h,8,12,8,N);
        
        X = XComp(x,block_Counter,4,8,N);
        
        y = outputComp(y,block_Counter,4,12,IR,X,N);
        
        %fast convolve h6 with 4N samples 
        IR = IRComp(h,12,16,8,N);
        
        y = outputComp(y,block_Counter,8,16,IR,X,N);
    end
    
    if rem(block_Counter,8) == 0
        %fast convolve h5 with 4N samples 
        IR = IRComp(h,16,24,16,N);
        
        X = XComp(x,block_Counter,8,16,N);
        
        y = outputComp(y,block_Counter,8,24,IR,X,N);
        
        %fast convolve h6 with 4N samples 
        IR = IRComp(h,24,32,16,N);
        
        y = outputComp(y,block_Counter,16,32,IR,X,N);
    end
end

y
w = conv(x,h)
plot(y-w)
