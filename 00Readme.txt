PhenoCam Toolkit
================

Overview
--------

The goal of this toolkit is to provide code samples useful for analyzing
images from the PhenoCam network of cameras (http://phenocam.sr.unh.edu/).
These routines also provide a reference to the calculations we use to 
process the data into time-series for comparison with other phenology 
data. In providing this toolkit we hope to encourage the use of data
from the project.

Requirements
------------

MATLAB
The matlab toolkit will require a working version of the MATLAB 
program.  There is an open source project called octave 
(http://www.gnu.org/software/octave/) which provides a language
quite similar to MATLAB.  If possible the routines provide will
be tested against both programs.

PYTHON
The python toolkit depends on two additional (and fairly large)
libraries.  The 'PIL' (Python Imaging Library,
http://www.pythonware.com/products/pil/) is used for the basic image
handling.  The 'numpy' module (Numerical Python, http://numpy.scipy.org/)
is used for numerical calculations.  Python distributions 
containing these module are widely available.  

We hope to provide a toolkit for the R statistics language soon.


test_gcc_calculation
--------------------
This script just calculates a gcc (green chromatic coordinate) value
for a single image and region-of-interest (ROI) mask pair.  The image
and the mask are both included in the test_data directory.


test_timeseries_calculation
---------------------------
This script cycles through a year of images and calculates mean
DN (digital number) values over an ROI.  The output is in CSV format
Additional sample data is required for running the test and can
be downloaded at http://phenocam.sr.unh.edu/data/software/sampledata.zip.
Download the sample data and extract the contents of the zip file
into the test_data directory.  This should create a subdirectory 'bartlett'
containing the images in a structure used by the routines. 


