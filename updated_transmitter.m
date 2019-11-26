[y fs] = audioread("whatareyou2.wav");
[another, fs_2] = audioread("kaaki.wav");
dt = 1/fs;
n = length(y);
%Creating windows of 2sec.
audioblock = [];
s1 = [];
s2 = [];
s3 = [];
s4 = [];
s5 = [];
i = 1;
%Upsampling
fs1 = 5 * fs;

for k = 1:2*fs:n
    s = y(k:min(k+2*fs-1, n));
    if i == 1 
        s1 = s;
    elseif i == 2
        s2 = s;
    elseif i == 3
        s3 = s;
    elseif i == 4
        s4 = s;
    else
        s5 = s;
    end
    i = i + 1;
end
%Channels availbale for hopping.
fc = [10000, 11000, 12000, 13000, 14000];

% another = upsample(another, 5);
freqdev = 3500;

another_mod = modulator(another, fc(2), fs1, freqdev);
%Modlating windows
ms1 = modulator(s1, fc(1), fs1, freqdev);
ms2 = modulator(s2, fc(2), fs1, freqdev);
ms3 = modulator(s3, fc(3), fs1, freqdev);
ms4 = modulator(s4, fc(4), fs1, freqdev);
ms5 = modulator(s5, fc(5), fs1, freqdev);

for i = 1:1:length(ms2)
    ms2(i) = ms2(i) + another_mod(i);
end
%Demodulating windows
[dms1, time_1] = demodulator(ms1, fc(1), fs1, freqdev, dt);
[dms2, time_2] = demodulator(ms2, fc(2), fs1, freqdev, dt);
[dms3, time_3] = demodulator(ms3, fc(3), fs1, freqdev, dt);
[dms4, time_4] = demodulator(ms4, fc(4), fs1, freqdev, dt);
[dms5, time_5] = demodulator(ms5, fc(5), fs1, freqdev, dt);
demod_sig = [dms1 dms2 dms3 dms4 dms5];
time = 0:1/fs:length(demod_sig)*1/fs-1/fs;
figure(4);
plot(time, demod_sig);

newfile = 'demod.wav';
audiowrite(newfile,demod_sig, fs);
y1 = audioread('demod.wav');
sound(y1, fs);

%Modulating function
function [mes1] = modulator(s, fc, fs, freqdev)
    s = upsample(s, 5);
    Ts = 1/fs;
    N = length(s);
    t=(0:Ts:(N*Ts)- Ts);
    t = transpose(t);
    kf=0.628;%Modulation index
    mes1= exp(1j*(2*pi*fc*t+2*pi*kf*cumsum(s)));
    mes1 = awgn(mes1,50);

end

%Demodulating function
function [dmes, time] = demodulator(mes, fc, fs, freqdev, dt)

        phi_hat(1)=30; 
        e(1)=0; 
        phd_output(1)=0; 
        vco(1)=0; 
        %Define Loop Filter parameters(Sets damping)
        kp=1; %Proportional constant 
        ki=0.5; %Integrator constant 
        %PLL implementation 
        for n=2:length(mes) 
        vco(n)=conj(exp(1j*(2*pi*n*fc/fs+phi_hat(n-1))));%Compute VCO 
        phd_output(n)=imag(mes(n)*vco(n));%Complex multiply VCO x Signal input 
        e(n)=e(n-1)+(kp+ki)*phd_output(n)-ki*phd_output(n-1);%Filter integrator 
        phi_hat(n)=phi_hat(n-1)+e(n);%Update VCO 
        end

        dmes = e;
        dmes = dmes(75:length(dmes) -  75);
        dmes = downsample(dmes, 5);
        time = 0:dt:length(dmes)*dt - dt;
    end

