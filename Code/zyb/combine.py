'''
TBD
'''


import cPickle
import gzip
import numpy as np
import sys
import utils

def combine_features(n_dim, files):

def main():
	n_dim = int(sys.argv[1])
	output_file = int(sys.argv[2])
	n_samples = last_n_samples = None
	for i in xrange(2,len(sys.argv)):
		last_n_samples = n_samples
		n_samples = utils.count_lines(sys.argv[i])
		if n_samples != last_n_samples:
			raise ValueError('Number of samples doesn\'t match. %s: %d; previous: %d' % 
				(sys.argv[i], n_samples, last_n_samples))



