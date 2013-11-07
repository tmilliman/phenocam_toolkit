%
% test_gcc_calculation.m
% 
% matlab script to perform simple calculation of ROI means for RGB
% brightness as well as calculate GCC for testing and evalution.
% 

addpath('./phenocam_toolkit');
rehash;

current_dt=datestr(now,0);
disp(current_dt);

archive_dir='../test_data'
imgfile='harvard_2008_08_07_103137.jpg';
maskfile='harvard_deciduous_0001_01.tif';
gcc_expected=0.4367;

imgpath = fullfile(archive_dir,imgfile);
maskpath = fullfile(archive_dir,maskfile);

disp('=========================================');
disp('test_gcc_calculation.m')
disp(sprintf('image file: %s',imgfile));
disp(sprintf('mask file: %s',maskfile));
disp('=========================================');

% read in TIFF mask file
roi_img = imread(maskpath);

% convert mask to boolean array
roimask = roi_img == 0;

% read in image, print out error message if file is 
img = imread(imgpath);

[meanred, meangreen, meanblue] = get_dn_means(img,roimask);

% calculate green chromatic coordinates
gcc_roi = meangreen / (meanred + meangreen + meanblue);
expected_gcc = 0.4367;
disp('DN-R, DN-G, DN-B');
dnstr = sprintf('%7.4f, %7.4f, %7.4f',meanred, meangreen, ...
		meanblue);
disp(dnstr);
disp(sprintf('Calculated value: %7.4f',gcc_roi));
disp(sprintf('Expected value: %7.4f',expected_gcc));

if abs(gcc_roi - gcc_expected) > 0.00005
  disp('gcc calculation failed!');
else
  disp('gcc calculation succeeded!');
end

return;