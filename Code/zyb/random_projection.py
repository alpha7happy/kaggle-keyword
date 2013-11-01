from sklearn.random_projection import SparseRandomProjection
from scipy.sparse import lil_matrix

import itertools
import os
import re
import subprocess
import sys

def _get_projection(n_samples, n_features, density='auto', eps=0.1):
	p = SparseRandomProjection()
	mat = lil_matrix((n_samples, n_features))
	return p.fit(mat)

def _load_samples_batch(file_name, n_features, batch_size=50000, value_type=int):
	n_samples = _count_lines(file_name)
	X = lil_matrix((batch_size, n_features))
	i = total = 0
	with open(file_name, 'r') as f:
		for line in f:
			sp = re.split('[: ]', '1:2 3:4')
			for j in range(0, len(sp)/2):
				X[i,int(sp[j*2])] = value_type(sp[j*2+1])
			i += 1
			total += 1
			if total % 100 == 0: 
				print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*total/n_samples, total, n_samples),
			if i == batch_size:
				yield X
				i = 0
				X = lil_matrix((batch_size, n_features))

	print 'loading samples %.1f%%(%d/%d)...' % (100.0*total/n_samples, total, n_samples)
	yield X

def _save_samples(file, X, fp_precision=6):
	format = '%%d:%%.%df ' % fp_precision
	cx = X.tocoo()
	last_i = 0
	for i,j,v in itertools.izip(cx.row, cx.col, cx.data):
		if i <> last_i:
			file.write('\n')
		file.write(format%(j, v))
		last_i = i
	file.write('\n')

def _count_lines(file):
	output = subprocess.Popen(["wc", "-l", file],
					 stdout=subprocess.PIPE).communicate()[0]
	return int(output.lstrip().split(' ')[0])

def transform(sample_file, dict_file, output_file, eps=0.1):
	n_samples = _count_lines(sample_file)
	n_features = _count_lines(dict_file)
	p = _get_projection(n_samples, n_features, eps=eps)
	
	with open(output_file, 'w') as f:
		for X in _load_samples_batch(sample_file, n_features):
			print 'transforming... \r',
			sys.stdout.flush()
			T = p.transform(X)
			
			print 'saving...       \r',
			sys.stdout.flush()
			_save_samples(f, T)
		print '\nTransform completed.'

if __name__ == '__main__':
	if len(sys.argv) < 5:
		print 'Require 4 arguments.'
		exit(1)
	sample_file = sys.argv[1]
	dict_file = sys.argv[2]
	output_file = sys.argv[3]
	eps = float(sys.argv[4])
	
	transform(sample_file, dict_file, output_file, eps)
