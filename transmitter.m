[y fs] = audioread("whatareyou2.wav");
% disp(length(y));
dt = 1/fs;
% figure(1);
% plot(time,y)
% fs1 = 2*fs;
% newfile = [tempname(),'.wav'];
% audiowrite(newfile, y, fs1);
% sound(y, fs1)
% fc = 8000000;
% fs2 = 20000000;
% freqdev = 1000000;
% mod_sig = fmmod(y, fc, fs2, freqdev);
% figure(2);
% plot(time, mod_sig);
% yfft = fft(mod_sig);
% figure(3)
% plot(abs(yfft(:,1)));
n = length(y);
audioblock = [];
s1 = [];
s2 = [];
s3 = [];
s4 = [];
s5 = [];
i = 1;
fs1 = fs * 2;
for k = 1:2*fs:n
    disp(i);
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
% disp(length(s5));
fc = [4000, 4100, 4200, 4300, 4400];

freqdev = 7500;
time = (0:dt:length(s1)*dt-dt);
figure(1);
plot(time, s1);
ms1 = fmmod(s1, fc(1), fs1, freqdev);
% time = 0:dt:(length(s1)*dt)-dt;
% figure(2);
% plot(time, ms1);
ms2 = modulator(s2, fc(2), fs1, freqdev);
ms3 = modulator(s3, fc(3), fs1, freqdev);
ms4 = modulator(s4, fc(4), fs1, freqdev);
ms5 = modulator(s5, fc(5), fs1, freqdev);
[dms1, time_1] = demodulator(ms1, fc(1), fs1, freqdev, dt);
% figure(3);
% plot(time, dms1);
[dms2, time_2] = demodulator(ms2, fc(2), fs1, freqdev, dt);
[dms3, time_3] = demodulator(ms3, fc(3), fs1, freqdev, dt);
[dms4, time_4] = demodulator(ms4, fc(4), fs1, freqdev, dt);
[dms5, time_5] = demodulator(ms5, fc(5), fs1, freqdev, dt);

demod_sig = [dms1' dms2' dms3' dms4' dms5'];
time = [time_1 time_2 time_3 time_4 time_5];
figure(4);
plot(time, demod_sig);

newfile = 'demod.wav';
audiowrite(newfile,demod_sig, fs);
y1 = audioread('demod.wav');
sound(y1, fs);

function [mes1] = modulator(s, fc, fs, freqdev)
    mes1 = fmmod(s, fc, fs, freqdev);
end

function [dmes, time] = demodulator(mes, fc, fs, freqdev, dt)
    dmes = fmdemod(mes, fc, fs, freqdev);
    dmes = dmes(75:length(dmes) -  75);
    time = 0:dt:length(dmes)*dt - dt;
end

