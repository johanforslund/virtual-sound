HRIR = load('HRIR.mat');

impulseResponses = zeros(512, 2, 24);

[signal, fs] = audioread('x1.wav');

for i=73:1:96
    leftResponse = HRIR.l_eq_hrir_S.content_m(i, :);
    rightResponse = HRIR.r_eq_hrir_S.content_m(i, :);
    impulseResponses(:, :, i-72) = [leftResponse; rightResponse]';
end

for i=1:24
    impulseResponse = impulseResponses(:, :, i);
    convolutedSignal = HRIRconv(signal(:, 1), impulseResponse);

    audiowrite(['x1-', num2str(i), '.wav'], convolutedSignal, fs);
end

disp('All files created');