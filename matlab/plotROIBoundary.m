function [] = plotROIBoundary(imgpath,maskpath)

% 
% function to draw the boundary of an ROI mask region onto an image.
%
% usage: plotROIBoundary(imgpath, maskpath)
%
% imgpath: path to an image file
% roipath: path to ROI mask image
%

% for testing:
%
%   imgpath='test_data/harvard_2008_08_07_103137.jpg';
%   maskpath='test_data/harvard_deciduous_0001_01.tif';
%   plotROIBoundary(imgpath,maskpath)
% 


% load mask, create boundary of ROI
tmparr = imread(maskpath,'tiff');

% convert to logical mask for bwboundaries call
mask = tmparr==0;

% get boundary coordinates
boundary = bwboundaries(mask);

% load image 
img = imread(imgpath);

% display the image in a new figure window
figure;
h = imagesc(img);
hold on;

%plot ROI boundary
linewidth = 4;
lineStyle = '-';
color = [1 0 0];
for i = 1:numel(boundary)
    plot(boundary{i}(:,2),...
        boundary{i}(:,1),...
        lineStyle,...
        'LineWidth',linewidth,...
        'Color', color);
end

return;