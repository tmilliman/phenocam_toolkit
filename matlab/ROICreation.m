function ROICreation(imgpath,roimaskpath,ROItype)

% Function to facilitate ROI creation on imagery. The function opens an
% image window and waits for the user to draw the ROI on the image. The ROI
% may be moved around and expanded as required by the user. Double clicking 
% finishes the process, saving the mask and opening a window clearly
% depicting the mask.
%
% SYNTAX:
%     ROICreation(imgpath,maskfilename,ROItype)
%         imgpath = path to image to use for drawing ROI
%         roimaskpath = output file name for Matlab
%         ROItype = ROI type, where 1 =  free hand, 2 = ellipse, 3 =  rectangle
%
% EXAMPLE:
%     ROICreation('C:\data\harvard\2009','harvard_2009_06_17_133139.jpg','harvardmask.tif',2)
%         This example creates facilitates ROI creation for the image, 
%         harvard_2009_06_17_133139.jpg, in directory,
%         C:\data\harvard\2009; the ROI type is an ellipse, and the output
%         file name will be 'harvardmask.tif'
%
% Written by Michael Toomey, mtoomey@fas.harvard.edu, January 27, 2012,
% based on code by Koen Hufkens, khufkens@bu.edu.
% Edited on November 17, 2012 to change output to TIFF file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debug=0;

if nargin == 0 % input image path is requred
  error('Input image path is required.');
elseif nargin == 1 % check input arguments
  
  roimaskpath=input('ROI mask path: ','s');
  ROItype=input(['ROI type (1 =  polygon, 2 = ellipse, 3 =' ...
		 ' rectangle): ']);
elseif nargin == 2
  ROItype=input(['ROI type (1 =  polygon, 2 = ellipse, 3 =' ...
		 ' rectangle): ']);
  ROItype=int16(ROItype);
  if (ROItype < 1) | (ROItype > 3) 
    error('Unknown ROI type');
  end
elseif nargin > 3
  errstr='Too many input arguments. Please type help ROICreation for details';
  error(errstr);
end
    
if (debug)
  disp(sprintf('nargin: %d', nargin));
  disp(sprintf('Input Image Path: %s', imgpath));
  disp(sprintf('Output ROI Mask File: %s', roimaskpath));
  disp(sprintf('ROI Type: %d',ROItype));
end


% open image filename
try
  img = imread(imgpath);
catch
  error('Unable to read input image file.')
end

% open figure
figure
h_im = image(img);

% enable ROI creation and conversion to mask based on "ROItype"
if ROItype == 1
    % create freehand ROI using "getline"
    % Koen uses "getline" and poly2mask in lines 273-289
    [xcoord, ycoord] = getline(gcf,'closed');
    % overplot the polygon
    hold on
    plot(xcoord,ycoord,'Color',[1 1 1],'LineWidth',2)
    hold off
    % convert polygon to binary mask
    mask = poly2mask(xcoord, ycoord, size(img,1), size(img,2));
elseif ROItype == 2
    % create ellipse ROI using imellipse
    ellps = imellipse;
    position = wait(ellps);
    mask = createMask(ellps,h_im);
elseif ROItype == 3
    % create rectangular ROI using imrect
    rect = imrect;
    position = wait(rect);
    mask = createMask(rect,h_im);    
else 
    error('ROItype must equal either 1, 2, or 3');    
end

mask = uint8(mask);

mask(mask == 0) = 255;
mask(mask == 1) = 0;

% plot mask
figure
imagesc(mask); colormap(gray)

% save mask
imwrite(mask,roimaskpath,'tif')