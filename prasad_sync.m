function [p_noise_sync_fin_conc]  = prasad_sync(varargin)

%%% INPUTS
% f_samp                    = sampling frequency used in the transceiver system [DEFAULT: 75MHz]
% str                       = Choose noise conditions [DEFAULT: 'rand']
% num_cyc                   = number of mains cycles of impulse noise required [DEFAULT: 1]
% N_FFT                     = FFT Size [Default: 3072]

%%% OUTPUT
% p_noise_sync_fin_conc     = generated periodic synchronous noise samples for one mains cycle 

%%% REFERENCES
% [1] Çelebi, Hasan Basri. Noise and multipath characteristics of power line communication channels. Diss. University of South Florida, 2010.
% [2] Cortés, José Antonio, et al. "Analysis of the indoor broadband power-line noise scenario." Electromagnetic Compatibility, IEEE Transactions on 52.4 (2010): 849-858.
% [3] IEEE Standards Association. "IEEE Standard for Broadband over Power Line Networks: Medium Access Control and Physical Layer Specifications." IEEE Std 1901 2010 (2010): 1-1586.

num_arg                     = length(varargin);
switch num_arg
    case 0
        f_samp              = 75000000;
        str                 = 'rand';
        num_cyc             = 1;
        N_FFT               = 3072;
    case 1
        f_samp              = varargin{1};
        str                 = 'rand';
        num_cyc             = 1;
        N_FFT               = 3072;
    case 2
        f_samp              = varargin{1};
        str                 = varargin{2};
        num_cyc             = 1;
        N_FFT               = 3072;
    case 3
        f_samp              = varargin{1};
        str                 = varargin{2};
        num_cyc             = varargin{3};
        N_FFT               = 3072;
    case 4
        f_samp              = varargin{1};
        str                 = varargin{2};
        num_cyc             = varargin{3};
        N_FFT               = varargin{4};
    otherwise
        disp('Extra inputs ignored');
        f_samp              = varargin{1};
        str                 = varargin{2};
        num_cyc             = varargin{3};
        N_FFT               = varargin{4};
end

tot_samp_cyc                = f_samp*(1/60);                                            % Total samples in a mains cycle (for 60 Hz North American)
p_noise_sync_fin            = [];                                                       % Define/initialize noise vector - can add some zeros to generate noise with some delay
Nd                          = 3;                                                        % Number of damped sinusoids, chosen based on [1]
if strcmp(str, 'best')
    t_dur_sync = 2*10^(-6);
elseif strcmp(str, 'worst')
    t_dur_sync = 300 * 10^(-6);
else
    t_dur_sync                  = ((300 - 2)*rand + 2)*10^(-6);                         % Uniformly distributed between 2us and 300us, based on [2]
end
t_sync                      = [0:1/f_samp:t_dur_sync];
damp_f                      = 0.005*f_samp;                                             % Damping factor, to be chosen based on duration of impulse

% Number of impulses in one main cycle based on best/worst case or random scenario 
if strcmp(str, 'best')
    num_imp                 = 1;
elseif strcmp(str, 'worst')
    num_imp                 = 10;
else
    num_imp                 = round(10*rand);
end

for jj=1:num_imp
    for ii = 1:Nd
        if strcmp(str, 'best')
            amp = 0.005;
        elseif strcmp(str, 'worst')
            amp = 1.5/Nd;
        else
            amp                 = (1/Nd)*((1.5-0.005)*rand + 0.005);                    % Impulse amplitude: Uniformly distributed between 5mV and 1.5V, based on [2]
        end
        f                   = 250000*rand + 250000;                                     % Pseudo frequency: Uniformly distributed between 250kHz and 500kHz, based on [2]
        p_noise_sync(ii,:)  = amp*exp(-damp_f*t_sync).*exp(-1i*2*pi*f*t_sync);          % Damped sinusoids expression for impulse noise, based on [3]
    end
    if(Nd>1)
        p_noise_sync        = sum(p_noise_sync);
    end
    int_a_time              = round((200000-10000)*rand + 10000);                       % Randomly chosen inter arrival time (no stats were available for this)
    p_noise_sync_fin        = [p_noise_sync_fin, zeros(1,int_a_time) p_noise_sync];     % Concatenate all the impulses         
end

p_noise_sync_fin            = [p_noise_sync_fin, zeros(1, tot_samp_cyc-length(p_noise_sync_fin))];
p_noise_sync_fin            = p_noise_sync_fin(1:tot_samp_cyc);

p_noise_sync_fin_conc       = [];

for ii = 1:num_cyc
    p_noise_sync_fin_conc   = [p_noise_sync_fin_conc, p_noise_sync_fin];                % Concatenate the same noise for all mains cycles since this is periodic noise
end

% figure(500)
% plot(real(p_noise_sync_fin_conc));
% xlabel('Time samples');
% ylabel('Amplitude, V');
% title('Periodic Synchronous Impulse Noise for one mains cycle');

% figure(501)
% [pow_noise_sync, freq_noise_sync] = pwelch(real(p_noise_sync_fin_conc), [], [], N_FFT, f_samp);
% pow_noise_sync = pow_noise_sync*10;
% plot(freq_noise_sync, 10*log10(abs(pow_noise_sync)));
% grid on;
% xlabel('Frequency, Hz');
% ylabel('Power Spectral Density, dBm/Hz');
% title('PSD of periodic synchronous noise');