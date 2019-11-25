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
fc = [100000, 300000, 20000, 150000, 250000];
fs1 = 7000000;
freqdev = 50000;
time = (0:dt:length(s1)*dt-dt);
figure(1);
plot(time, s1);
ms1 = fmmod(s1, fc(1), fs1, freqdev);
time = 0:dt:(length(s1)*dt)-dt;
figure(2);
% plot(time, ms1);
ms2 = fmmod(s2, fc(2), fs1, freqdev);
ms3 = fmmod(s3, fc(3), fs1, freqdev);
ms4 = fmmod(s4, fc(4), fs1, freqdev);
ms5 = fmmod(s5, fc(5), fs1, freqdev);
dms1 = fmdemod(ms1, fc(1), fs1, freqdev);
figure(3);
% plot(time, dms1);
dms2 = fmdemod(ms2, fc(2), fs1, freqdev);
dms3 = fmdemod(ms3, fc(3), fs1, freqdev);
dms4 = fmdemod(ms4, fc(4), fs1, freqdev);
dms5 = fmdemod(ms5, fc(5), fs1, freqdev);
demod_sig = [dms1' dms2' dms3' dms4' dms5'];
time = (0:dt:length(y)*dt -dt);
figure(4);
plot(time, demod_sig);
newfile = 'demod.wav';
audiowrite(newfile,demod_sig, fs);
y1 = audioread('demod.wav');
sound(y1, fs);