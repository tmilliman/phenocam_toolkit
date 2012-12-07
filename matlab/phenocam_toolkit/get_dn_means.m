function [dnr, dng, dnb] = get_dn_means(img, mask)
%
% function to return mean DN values for an image / mask pair.
%

  
% make sure mask and image are the same dimensions
if size(img,1) ~= size(mask,1) || size(img,2) ~= size(mask,2)  
  error('Mask and input image are not the same dimensions.')
end

% split image into its components
red = img(:,:,1);
green = img(:,:,2);
blue = img(:,:,3);
    
% calculate green chromatic coordinates    
% load individual band values
dnr = mean(red(mask));
dng = mean(green(mask));
dnb = mean(blue(mask));

return
  