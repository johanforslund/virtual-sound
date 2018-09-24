clear 
clc

fileReader = dsp.AudioFileReader('x1.wav');
fileReader.SamplesPerFrame = 512;
fileReader.PlayCount = 2;
deviceWriter = audioDeviceWriter('SampleRate',fileReader.SampleRate);
deviceWriter.Driver = 'ASIO';

m = mobiledev;

pause(3); %Ge tid åt mobiledev att init

HRIR = load('HRIR.mat');

impulseResponses = zeros(512, 2, 24);

for i=73:1:96
    leftResponse = HRIR.l_eq_hrir_S.content_m(i, :);
    rightResponse = HRIR.r_eq_hrir_S.content_m(i, :);
    impulseResponses(:, :, i-72) = [leftResponse; rightResponse]';
end

while ~isDone(fileReader)
    signal = fileReader();
    
    if m.Orientation %Kolla att m tar emot från sensorn
        impulseResponse = impulseResponses(:, :, getAngleIndex(m.Orientation));
    else
        impulseResponse = impulseResponses(:, :, 1); %Standard respons, vinkel = 0 grader
    end
    
    convolutedSignal = HRIRconv(signal, impulseResponse);
    deviceWriter(convolutedSignal);
end

release(fileReader);
release(deviceWriter);