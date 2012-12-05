%
% test_gcc_calculation.m
% 
% matlab script to perform simple calculation of ROI means for RGB
% brightness as well as calculate GCC for testing and evalution.
% 

addpath('phenocam_toolkit');
rehash;

current_dt=datestr(now,0);
disp(current_dt);

imgfile='./test_data/harvard_2008_08_07_103137.jpg';
maskfile='./test_data/harvard_deciduous_0001_01.tif';
gcc_expected=0.4367;

disp('=========================================');
disp('test_gcc_calculation.m')
disp(sprintf('image file: %s',imgfile));
disp(sprintf('mask file: %s',maskfile));
disp('=========================================');

% read in TIFF mask file
mask = imread(maskfile,'tif');

% read in image, print out error message if file is 
img = imread(imgfile);

[meanred, meangreen, meanblue] = get_dn_means(img,mask);

% calculate green chromatic coordinates
gcc_roi = meangreen / (meanred + meangreen + meanblue);
expected_gcc = 0.4367;
disp('DN-R, DN-G, DN-B');
dnstr = sprintf('%7.4f, %7.4f, %7.4f',meanred, meangreen, ...
		meanblue);
disp(dnstr);
disp(sprintf('Calculated value: %7.4f',gcc_roi));
disp(sprintf('Expected value: %7.4f',expected_gcc));

if (gcc_roi - gcc_expected) > 0.00005
  disp('gcc calculation failed!');
else
  disp('gcc calculation succeeded!');
end

return;