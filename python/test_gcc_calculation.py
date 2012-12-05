#!/usr/bin/env python

"""
Script to test calculation of gcc value from a single image and mask.
"""

from PIL import Image
import numpy as np
import os, sys
from datetime import datetime as dt
import phenocam_toolkit as pt

archive_dir = './test_data'
imgfile = 'harvard_2008_08_07_103137.jpg'
maskfile = 'harvard_deciduous_0001_01.tif'
gcc_expected = 0.4367

imgpath = os.path.join(archive_dir,imgfile)
maskpath = os.path.join(archive_dir,maskfile)



if __name__ == "__main__":

    now = dt.now()

    # print some info to stdout
    print "========================================="
    print "test_gcc_calculation.py: " 
    print "date: %s" % (now.strftime('%Y-%m-%d %H:%M:%S'),)
    print "image file: %s" % (imgfile,)
    print "mask file: %s" % (maskfile,)
    print "========================================="

    # open and read image file
    im = Image.open(imgpath)
    im.load()

    # open and read mask file
    roi_img = Image.open(maskpath)
    roi_img.load()
    roimask = np.asarray(roi_img,dtype=np.bool8)

    [r_mean_roi, g_mean_roi, b_mean_roi] = pt.get_dn_means(im, roimask)
    
    brt_mean_roi = r_mean_roi + g_mean_roi + b_mean_roi
    gcc_roi = g_mean_roi / brt_mean_roi

    print "DN-R, DN-G, DN-B"
    print "%5.4f, %5.4f, %5.4f" % (r_mean_roi, g_mean_roi, b_mean_roi,)
    print "Calculated value: %4.4f" % (gcc_roi,)
    print "Expected value:   %4.4f" % (gcc_expected,)
    
    if (gcc_roi - gcc_expected) > .00005:
        print "gcc calculation failed!"
    else:
        print "gcc calculation succeeded!"

