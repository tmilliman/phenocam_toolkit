%
% test_gcc_calculation.m
% 
% matlab script to perform simple calculation of ROI means for RGB
% brightness as well as calculate GCC for testing and evalution with other
% programs
% 

current_dt=datestr(now,0);
disp(current_dt);

imgfile='./test_data/harvard_2008_08_07_103137.jpg';
maskfile='./test_data/harvard_deciduous_0001_01.tif';

disp('test_gcc_calculation.m')
disp(sprintf('image file: %s',imgfile));
disp(sprintf('mask file: %s',maskfile));
disp('=========================================');

% read in TIFF mask file
mask = imread(maskfile,'tif');

% read in image, print out error message if file is 
img = imread(imgfile);

% make sure they are the same dimensions
if size(img,1) ~= size(mask,1) || size(img,2) ~= size(mask,2)  
  error('Mask and input image are not the same dimensions.')
end

% split image into its components
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);
    
% calculate green chromatic coordinates    
% load individual band values
meanred = mean(mean(red(mask == 0)));
meangreen = mean(mean(green(mask == 0)));
meanblue = mean(mean(blue(mask == 0)));

% calculate green chromatic coordinates
gcc = meangreen / (meanred + meangreen + meanblue);
expected_gcc = 0.4367;
disp('DN-R, DN-G, DN-B');
dnstr = sprintf('%7.4f, %7.4f, %7.4f',meanred, meangreen, ...
		meanblue);
disp(dnstr);
disp(sprintf('Calculated value: %7.4f',gcc));
disp(sprintf('Expected value: %7.4f',expected_gcc));

    
return;