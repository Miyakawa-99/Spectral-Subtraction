clear all;
close all;
clc;

[signal,fs] = audioread("speech_signal.wav");
[noise,fsn] = audioread("noise_signal.wav");

noise_sig =  5*noise;
speech_sig = signal;

spee_signal = speech_sig + noise_sig;
speech_signal = speech_sig(:,1);
noise_signal = noise_sig(:,1);

figure;
subplot(1, 2, 1);
plot(speech_signal);
subplot(1, 2, 2);
plot(noise_signal);

speech_fft = abs(fft(speech_signal));
noise_fft = abs(fft(noise_signal));

result_fft = speech_fft - noise_fft;

result = ifft(result_fft);

fnoise = zeros(160,1);
count=0;

for i = 1 : 160 : length(noise_signal)
     count=count+1;
     n_window = hann(160) .* noise_signal(i:i+159);
     fnoise = fnoise + (abs(fft(n_window)));
end

average_noise = (fnoise)/count;
figure;plot(average_noise)


signal_energy = zeros(160,1);
count = 0;
%%%%%%%%%
for i = 1 : 160 : length(speech_signal)
    
    l = hann(160) .* speech_signal(i : i+159);
    f = fft(l);
    signal_energy = signal_energy + (abs(f)).^2;
    
    count = count + 1;
end

avg = signal_energy / count;

for i = 1 : 160 : length(speech_signal)
    
    window_signal = hann(160) .* speech_signal(i : i+159);
    fspeech_window = fft(window_signal);
    
    e = (abs(fspeech_window)) .^2;
    
    if e < avg
        enhanced_signal = abs(fspeech_window) - abs(average_noise);  
    else 
        enhanced_signal = abs(fspeech_window);
    end
    
      mask = enhanced_signal >= 0;
      enhanced_signal = enhanced_signal .* mask;
    
    sub = ifft(enhanced_signal);  
    res(i : i+159) = sub(1:160);
%

end
%%
res = res.';
temp = res;
figure;
plot(temp);
sound(10*temp, fs);  
%sound(speech_sig, fs);
    %%
% %     close all;
figure
spectrogram(speech_signal)
figure;spectrogram(noise_signal)
figure;spectrogram(res);
    

