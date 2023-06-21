
function [p_noise_sync_fin]  = AperiodicImpulseNoise(f_samp, str, num_cyc)

%%% INPUTS
% f_samp                    = sampling frequency used in the transceiver system
% str                       = Choose noise conditions

%%% OUTPUT
% p_noise_sync_fin          = generated aperiodic impulse noise samples for one mains cycle 

%%% REFERENCES
% [1] Çelebi, Hasan Basri. Noise and multipath characteristics of power line communication channels. Diss. University of South Florida, 2010.
% [2] Cortés, José Antonio, et al. "Analysis of the indoor broadband power-line noise scenario." Electromagnetic Compatibility, IEEE Transactions on 52.4 (2010): 849-858.
% [3] IEEE Standards Association. "IEEE Standard for Broadband over Power Line Networks: Medium Access Control and Physical Layer Specifications." IEEE Std 1901 2010 (2010): 1-1586.

%  clc
%  clear all
 
%f_samp=75e6;                                                                           % Sampling frequency for HomePlug PLC standard

observation_period=num_cyc*f_samp*(1/60);                                                      % Total observation period (s)
observation_time=0:observation_period;
p_noise_sync_fin            = [];                                                       % Define/initialize noise vector - can add some zeros to generate noise with some delay
Nd                          = 3;                                                        % Number of damped sinusoids, chosen based on [1]

if strcmp(str, 'best')
    t_dur_sync = 15*10^(-6);
elseif strcmp(str, 'worst')
    t_dur_sync = 150 * 10^(-6);
else
    t_dur_sync                  = ((150 - 15)*rand + 15)*1e-6;                          % Impulse duration, Uniformly distributed between 15us and 150us (Type 1), based on [2]
end
t_sync                      = [0:1/f_samp:t_dur_sync];
damp_f                      = 0.005*f_samp;                                             % Damping factor, to be chosen based on duration of impulse

%Number of impulses in one main cycle based on best/worst case or random scenario 
 if strcmp(str, 'best')
     num_imp                 = 1;
 elseif strcmp(str, 'worst')
     num_imp                 = 10;
 else
     num_imp                 = round(10*rand);
 end

%num_imp=10;

for jj=1:num_imp
    for ii = 1:Nd
        
        if strcmp(str, 'best')
            amp(ii) = 0.005/Nd;
        elseif strcmp(str, 'worst')
            amp(ii) = .15/Nd;
        else
            amp(ii)             = (150e-3-20e-3)*rand + 20e-3;                          % Impulse amplitude: Uniformly distributed between 5mV and 150mV, based on [2]
        end
        f(ii)               = 500e3*rand + 1e6;                                         % Pseudo frequency: Uniformly distributed between 500kHz and 1 MHz, based on [2]
        p_noise_sync(ii,:)  = amp(ii)*exp(-damp_f*t_sync).*exp(-1i*2*pi*f(ii)*t_sync);  % Damped sinusoids expression for impulse noise, based on [3]
    end
    if(Nd>1)
        p_noise_sync        = sum(p_noise_sync);
    end
    int_a_time              = round((1/1e-3)*((random('exp',100))));                 % Exponential distributed Inter arrival time (in us) with mean 100ms, based on [1]
    p_noise_sync_fin        = [p_noise_sync_fin, zeros(1,int_a_time) p_noise_sync];     % Concatenate all the impulses         
end

p_noise_sync_fin            = [p_noise_sync_fin, zeros(1,(length(observation_time)-length(p_noise_sync_fin)))];


%%% Amplitdue of time domain impulse noise
% figure(1)
% plot(observation_time/1e-3,real(p_noise_sync_fin))
% xlabel('Time (ms)','FontName','Arial','FontSize',14);
% ylabel('Amplitude (mV)','FontName','Arial','FontSize',14);
% 
% %%% PSD of the impulse noise
% figure(2)
% [psd, freq] = pwelch(real(p_noise_sync_fin), [], [], length(observation_time), f_samp);
% plot(freq/(1*1e6), 10*log10(abs(psd))+30);
% xlabel('Frequency (MHz)','FontName','Arial','FontSize',14);
% ylabel('PSD (dBm/Hz)','FontName','Arial','FontSize',14);

p_noise_sync_fin            = p_noise_sync_fin(1:length(p_noise_sync_fin)-1);

if (length(p_noise_sync_fin) > length(observation_time)-1)
    p_noise_sync_fin        = p_noise_sync_fin(1:(length(observation_time)-1));
end