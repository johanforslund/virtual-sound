function fileReaders = createFileReaders()

samplesPerFrame = 512/4;

fileReaders = cell(24, 1);

for i=1:24
    fileReader = dsp.AudioFileReader(['x1-', num2str(i), '.wav']);
    fileReader.SamplesPerFrame = samplesPerFrame;
    fileReader.PlayCount = 2;

    fileReaders{i, 1} = fileReader;
end