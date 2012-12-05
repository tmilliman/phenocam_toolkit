"""
phenocam_toolkit.py

A collection of routines for processing images from the PhenoCam
Network (http://phenocam.sr.unh.edu/).  For the latest version and
documentation on this library see: http://phenocam.sr.unh.edu/webcam/tools.

Depends: numpy

"""

import numpy as np
import os, sys, re, glob
import datetime


###############################################################################

def get_dn_means(im, roimask):
    
    """
    function to return mean DN values for an image / mask pair.
    """
 
    # split into bands
    (im_r, im_g, im_b) = im.split()

    # create numpy arrays with bands
    r_array = np.asarray(im_r, dtype=np.float)
    g_array = np.asarray(im_g, dtype=np.float)
    b_array = np.asarray(im_b, dtype=np.float)
    brt_array = r_array + g_array + b_array

    # try applying mask to brightness image ... if mask and image don't
    # have same size this will raise an exception.
    try:
        brt_ma = np.ma.array(brt_array,mask=roimask)
    except:
        errstr = "Error applying mask to: %s\n" % (imgfile,)
        sys.stderr.write(errstr)
        sys.exit

    # make masked arrays for R,G,B
    g_ma = np.ma.array(g_array,mask=roimask)
    r_ma = np.ma.array(r_array,mask=roimask)
    b_ma = np.ma.array(b_array,mask=roimask)

    # find mean values to store
    g_mean_roi = np.mean(g_ma)
    r_mean_roi = np.mean(r_ma)
    b_mean_roi = np.mean(b_ma)

    return [r_mean_roi, g_mean_roi,  b_mean_roi]

###############################################################################

def fn2datetime(sitename, filename, irFlag=False):
    """
    Function to extract the datetime from a "standard" filename based on a
    sitename.  Here we assume the filename format is the standard:

          sitename_YYYY_MM_DD_HHNNSS.jpg

    So we just grab components from fixed positions.  If irFlag is 
    True then the "standard" format is:

          sitename_IR_YYYY_MM_DD_HHNNSS.jpg

    """    
    
    if irFlag:
        prefix=sitename+"_IR"
    else:
        prefix=sitename

    # set start of datetime part of name
    nstart=len(prefix)+1
    
    # assume 3-letter extension e.g. ".jpg"
    dtstring=filename[nstart:-4]
    
    # extract date-time pieces
    year=int(dtstring[0:4])
    mon=int(dtstring[5:7])
    day=int(dtstring[8:10])
    hour=int(dtstring[11:13])
    mins=int(dtstring[13:15])
    sec=int(dtstring[15:17])
    
    # return list
    return datetime.datetime(year, mon, day, hour, mins, sec)

###############################################################################

def doy2date(year, doy, out='tuple'):
    '''
    Convert year and yearday into calendar date. Output is a tuple
    (out='tuple': default) ISO string (out='iso'), julian date
    (out='julian'), or p ython date object (out='date')
    '''
    year=int(year)
    doy=int(doy)
    thedate = datetime.date(year, 1, 1) + datetime.timedelta(doy-1)

    if out=='tuple':
        return thedate.timetuple()[:3]
    elif out=='iso':
        return thedate.isoformat()
    elif out=='julian':
        return thedate.toordinal()
    elif out=='date':
        return thedate
    else:
        return None

###############################################################################

def date2doy(year, month, day):
    """
    Convert calendar date into year and yearday.
    """
    year=int(year)
    month=int(month)
    day=int(day)
    thedate = datetime.date(year, month, day)
    return (year, thedate.timetuple()[7])

