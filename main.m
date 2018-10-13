clear 
clc

fileReaders = createFileReaders();

fileReaderBackground = dsp.AudioFileReader('audio/background.mp3');
fileReaderBackground.SamplesPerFrame = 512/2;
fileReaderBackground.PlayCount = 2;

disp(fileReaders{1}.SampleRate);
deviceWriter = audioDeviceWriter('SampleRate',fileReaders{1}.SampleRate);
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

signals = cell(24, 1);

while ~isDone(fileReaders{1})
    for i=1:24
        fileReader = fileReaders{i, 1};
        signals{i, 1} = fileReader();
    end
    
    backgroundSignal = fileReaderBackground();
    
    if m.Orientation
        angleIndex = getAngleIndex(m.Orientation);
    else
        angleIndex = 1;
    end
    
    signal = signals{angleIndex, 1};
    signal = signal + backgroundSignal;
    
    deviceWriter(signal);
end

for i=1:24
    release(fileReaders{i, 1});
end
release(fileReaderBackground);
release(deviceWriter);