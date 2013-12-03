import gzip
import numpy as np
import sys
import utils
from scipy.sparse import coo_matrix

class CooccurrenceMatrix:
	def __init__(self, y):
		self.n_tags = n_tags = y.max()
		
		c = coo_matrix((n_tags, n_tags), dtype=np.intc)
		for row in y:
			for i in xrange(len(y)):
				for j in xrange(i+1, len(y)):
					c[y[i],y[j]] += 1
					c[y[j],y[i]] += 1
		self.mat = c
		self.row_sum = c*numpy.ones((n_tags, 1))

	def get_conditional_proba(self, b, a):
		'''
		Calculate probability of P(b|a)
		'''
		if a>self.n_tags or b>self.n_tags:
			raise ValueError('Tag id must be smaller than %d.' % self.n_tags)

		return float(self.mat[a,b]+1)/(self.row_sum[a,1]+self.n_tags)

	def get_log_conditional_proba(self, b, a):
		proba = self.get_conditional_proba(b, a)
		return log(proba)

	@classmethod
	def create(label_file, output_file):
		y = utils._load_label(label_file, n_labels=5)
		
		print 'creating co-occurrence matrix...'
		c = CooccurrenceMatrix(y)
		
		with gzip.open(output_file, 'wb') as f:
			print 'saving co-occurrence matrix...'
	        cPickle.dump(c, f, cPickle.HIGHEST_PROTOCOL)
	        print 'matrix saved to %s.' % output_file

	@classmethod
	def load(input_file):
        with gzip.open(model_file, 'rb') as f:
            print 'loading co-occurrence matrix...'
            return cPickle.load(f)
