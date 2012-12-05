#!/usr/bin/env python

"""
Script to test the calculation of a gcc timeseries using the
phenocam toolkit.
"""

from PIL import Image
import numpy as np
import os, sys
from datetime import datetime as dt
import phenocam_toolkit as pt

archive_dir = './test_data'
site = 'bartlett'
year = 2006
maskfile = 'bartlett_deciduous_0001_01.tif' 
maskpath = os.path.join(archive_dir,maskfile)


if __name__ == "__main__":

    now = dt.now()

    # print some info to stdout
    print "========================================="
    print "test_timeseries_calculation.py: " 
    print "date: %s" % (now.strftime('%Y-%m-%d %H:%M:%S'),)
    print "archive dir: %s" % (archive_dir,)
    print "site: %s" % (site,)
    print "year: %d" % (year,)
    print "mask: %s" % (maskfile,)
    print "========================================="

    # open and read ROI mask file
    roi_img = Image.open(maskpath)
    roi_img.load()
    roimask = np.asarray(roi_img,dtype=np.bool8)

    # get a list of images for this site
    imlist = pt.getsiteimglist(archive_dir,site)

    # loop over list
    for imgpath in imlist:

        # get datetime from filename
        imgfile = os.path.basename(imgpath)
        imgdt = pt.fn2datetime(site,imgfile)

        # open and read image file
        im = Image.open(imgpath)
        im.load()

        # find mean values over ROI
        [r_mean_roi, g_mean_roi, b_mean_roi] = pt.get_dn_means(im, roimask)

        # construct GCC value
        brt_mean_roi = r_mean_roi + g_mean_roi + b_mean_roi
        gcc_roi = g_mean_roi / brt_mean_roi

        # generate output line
        #
        # standard output will be:
        # date, time, year, doy, dn-r, dn-g, dn-b, filename
        imgdate = imgdt.date()
        imgtime = imgdt.time()
        imgyear = imgdt.year
        imgfdoy = pt.datetime2fdoy(imgdt)

        print "date,time,year,doy,dn-r,dn-g,dn-b,filename"
        print "%s,%s,%d,%5.4f,%5.2f,%5.2f,%5.2f,%s" % \
              (imgdate, imgtime, imgyear, imgfdoy, r_mean_roi,
               g_mean_roi, b_mean_roi, imgfile,)

