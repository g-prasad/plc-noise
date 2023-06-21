%Generation of colored noise in Matlab
a=0.9; %low pass filter parameter
L=50 ; % Number of samples used in auto-covariance calculation
clc;
Fs=1000; %sampling rate
Fc=10; % carrier frequency for the dummy signal
t=0:1/Fs:2; %time base
variance = 1; %variance of white noise
%generate a dummy signal - Later on this can be replaced by the signal that you are interested in , so
%that the generated noise can be added to it.
signal=5*sin(2*pi*Fc*t);
% Generate Gaussian White Noise with zero mean and unit variance
whiteNoise=sqrt(variance)*randn(1,length(signal));
%Calculate auto Covariance of the generated white noise L is the number of samples used in
%autocovariance calculation
[whiteNoiseCov,lags] = xcov(whiteNoise,L);
%Frequency domain representation of noise
NFFT = 2^nextpow2(length(whiteNoise));
whiteNoiseSpectrum = fft(whiteNoise,NFFT)/length(whiteNoise);
f = Fs/2*linspace(0,1,NFFT/2+1);
%Colored Noise Generation
x=whiteNoise;
%First Order Low pass filter y(n)=a*y(n-1)+(1-a)*x(n)
%Filter Trasfer function Y(Z) = X(Z)*(1-a)/(1-aZ^-1)
[y zf]=filter(1-a,[1 -a],x);
coloredNoise = y;
[coloredNoiseCov,lags] = xcov(coloredNoise,L);
NFFT = 2^nextpow2(length(coloredNoise));
coloredNoiseSpectrum = fft(coloredNoise,NFFT)/length(coloredNoise);
f = Fs/2*linspace(0,1,NFFT/2+1);
%plotting commands
figure(1);
subplot(3,1,1);
plot(t,whiteNoise);
title('Additive White Gaussian Noise');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,2);
stem(lags,whiteNoiseCov/max(whiteNoiseCov));
title('Normalized AutoCovariance of AWGN noise');
xlabel('Lag [samples]');
subplot(3,1,3);
stem(f,2*abs(whiteNoiseSpectrum(1:NFFT/2+1)))
title('Frequency Domain representation of AWGN');
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
figure(2);
subplot(3,1,1);
plot(t,coloredNoise);
title('Colored Noise');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,2);
stem(lags,coloredNoiseCov/max(coloredNoiseCov));
title('Normalized AutoCovariance of Colored Noise');
xlabel('Lag [samples]');
subplot(3,1,3);
stem(f,2*abs(coloredNoiseSpectrum(1:NFFT/2+1)))
title('Frequency Domain representation of Colored Noise');
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
