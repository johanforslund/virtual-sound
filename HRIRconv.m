function output_data = HRIRconv(audio, IRfile)

left_imp=IRfile(:,1);
right_imp=IRfile(:,2);

% Do convolution with FFT%
out_left = conv(audio,left_imp, 'same');
out_right = conv(audio,right_imp, 'same');

output_data=[out_left out_right];
