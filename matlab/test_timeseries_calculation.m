%
% test_timeseries_calculation.m
% 
% Script to test the calculation of a gcc timeseries using the
% MATLAB phenocam toolkit.
% 

addpath('phenocam_toolkit');
rehash;

archive_dir = '../test_data';
site = 'bartlett';
year = 2006;
maskfile = 'bartlett_deciduous_0001_01.tif';
maskpath = fullfile(archive_dir,maskfile);

current_dt=datestr(now,0);

disp('=========================================');
disp('test_timeseries_calculation.m')
disp(['date: ',current_dt]);
disp(['archive_dir: ', archive_dir]);
disp(['site: ',site]);
disp(sprintf('year: %d',year));
disp(['mask: ',maskfile]);
disp('=========================================');

% read in TIFF mask file
mask = imread(maskpath,'tif');

% get list of imagepaths for this site
imlist = getsiteimglist(archive_dir,site);

% loop over imagepaths
nimg=length(imlist);
for i = 1:nimg
  imgpath=imlist{i};

  % get datenum from filename
  [imgdir, imgname, imgext] = fileparts(imgpath);
  imgfile = [imgname, imgext];
  imgdn = fn2datenum(site,imgfile);

  % read in image
  img = imread(imgpath);

  % get mean DN values over ROI mask region
  [r_mean_roi, g_mean_roi, b_mean_roi] = get_dn_means(img,mask);
  
  % calculate GCC (green chromatic coordinate)
  brt_mean_roi = r_mean_roi + g_mean_roi + b_mean_roi;
  gcc_roi = g_mean_roi / brt_mean_roi;
  
  % generate output line
  %
  % standard output will be:
  % date, time, year, doy, dn-r, dn-g, dn-b, filename
  imgdate = datestr(imgdn,29);
  imgtime = datestr(imgdn,13);
  imgyear = datestr(imgdn,10);
  imgfdoy = datenum2fdoy(imgdn);

  outstr = sprintf('%s,%s,%s,%.4f,%.2f,%.2f,%.2f,%s', ...
		   imgdate, imgtime, imgyear, imgfdoy, r_mean_roi, ...
               g_mean_roi, b_mean_roi, imgfile);
  disp(outstr);
end


return;
