function [total_noise] = PLC_noise(varargin)
% Main file for running the cumulative noise 

% By Gautham Prasad, Jahidur Rahman, Hao Ma, Fariba Aalamifar
% The University of British Columbia, Vancouver, British Columbia

%%% INPUT
% level - output noise level required
%       'best' - lowest noise possible in an in-home scenario
%       'worst' - highest noise possible in an in-home scenario
%       'rand' - a noise level somewhere randomly in between the 'best' and 'worst' conditions

%%% OUTPUT
% noise_time - time domain noise samples in one mains cycle

%%% EXAMPLE
% total_noise   = PLC_noise('worst') --- gives you the time domain noise samples under a worst-case network condition (high noise)
% total_noise   = PLC_noise          --- gives you the time domain noise samples under a random network condition 
% total_noise   = PLC_noise('best')  --- gives you the time domain noise samples under a best-case network condition (low noise)

% REFERENCES
% [1] Latchman, Haniph A., et al. Homeplug AV and IEEE 1901: A Handbook for PLC Designers and Users. John Wiley & Sons, 2013.
% [2] Benyoucef, Dirk. "A new statistical model of the noise power density spectrum for powerline communication." Proceedings of the 7th International Symposium on Power-Line Communications and its Applications, Kyoto, Japan. 2003.
%close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_arg         = length(varargin);

% level_i and level_b are for the impulse and background noise, respectively 
switch num_arg
    case 0
        level_i = 'rand';
        level_b = 'random';
    otherwise
        level_i = varargin{1};
        if(strcmp(varargin{1}, 'rand'))
            level_b = 'random';
        else
            level_b = varargin{1};
        end
end

% Define system constants - chosen from HomePlug AV specifications
% Refer [1] for more details
N_FFT           = 3072;                     % FFT size
f_samp          = 75000000;                 % sampling frequency
delta_f         = f_samp/N_FFT;             % OFDM sub-carrier spacing
building        = 'residential';            % we are only interested in in-home noise here - this can also be changed to 'office' to get industrial noise
num_cyc         = 1;                        % total number of mains cycles you need your noise for 
freq_mains      = 60;                       % North American mains frequency of 60 Hz 
num_samp        = num_cyc*f_samp*(1/freq_mains);    % total number of noise samples to be generated  

% Periodic synchronous noise for the desired noise level
per_sync        = prasad_sync(75000000, level_i, num_cyc);

% Periodic asynchronous noise for the desired noise level
per_async       = prasad_async(75000000, level_i, num_cyc);

% Aperiodic noise for the desired noise level
aper            = AperiodicImpulseNoise(75000000, level_i, num_cyc);

% Generalized background noise - this is the sum of colored background noise and narrowband noise
gbn_freq_orig   = GBN(level_b, building, delta_f);
gbn_freq        = gbn_freq_orig - 30; % convert dBm/Hz to dBW/Hz (-30); convert 100 Ohm line to normalized impedance (+20)

% Convert background noise PSD to time domain samples to add it up with the impulse noise

% Background noise is generated from 2 - 30 MHz
% But we use a sampling frequency of 75 MHz
% Extend the noise PSD to cover 0 - 37.5 MHz for proper use of FFT 
%gbn_freq        = [gbn_freq(1:ceil(2000/delta_f)),  gbn_freq, gbn_freq(end - ceil(7500/delta_f) : end)]; 
gbn_low         = interp1([ceil(2000000/delta_f)+1:length(gbn_freq)+ ceil(2000000/delta_f)], gbn_freq, [1:ceil(2000000/delta_f)+1], 'linear', 'extrap');
gbn_high        = interp1([ceil(2000000/delta_f)+1:length(gbn_freq)+ ceil(2000000/delta_f)], gbn_freq, [ceil(2000000/delta_f)+1+length(gbn_freq):(N_FFT/2)], 'linear', 'extrap');
gbn_freq        = [gbn_low gbn_freq gbn_high];


% The function GBN gives PSD for positive frequencies
% Flip it to make the PSD conjugate symmetric
gbn_freq        = [gbn_freq, conj(fliplr(gbn_freq([2:end-1])))];

% Convert dBm/Hz to V:- PSD of the coloring filter to frequency response of the coloring filter
% Refer [2] for more details - specifically [2, Fig. 2]
gbn_freq        = 10.^(gbn_freq./20).* f_samp;

% Get the impulse response of the filter
gbn_filter_time = real(ifft(gbn_freq));

% Convolve with a normalized white gaussian noise [2, Fig. 2] 
gbn_time        = conv(sqrt(1/num_samp)*randn(1, num_samp), gbn_filter_time);

% Extract the required number of samples
gbn_time        = gbn_time(1:num_samp);

% close all;

% Add all the time domain noise samples
total_noise     = gbn_time + per_sync + per_async + aper;

% Plot the power spectral density of the noise
% [pow_tot, freq_tot] = pwelch(real(total_noise), [], [], N_FFT, f_samp);
% figure;
% plot(freq_tot./1000000, (+30-20)+10*log10(abs(pow_tot))); % +30 to convert dBW/Hz to dBm/Hz; -20 to account for a 100 Ohm power line 
% xlabel('Frequency (MHz)');
% ylabel('Power Spectral Density across a 100 \Omega line (dBm/Hz)')
% title('Overall noise PSD')

% Plot the time domain noise signal - only real part since the data signal is real 
% figure;
% plot(real(total_noise));
% xlabel('Time samples');
% ylabel('Amplitude, V');
% title('Overall noise in time domain')

end