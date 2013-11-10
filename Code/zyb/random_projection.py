from sklearn.random_projection import SparseRandomProjection
from scipy.sparse import csr_matrix

import sys
import numpy as np
import utils


def _get_projection(n_samples, n_features, density='auto', eps=0.1):
    p = SparseRandomProjection(density=density, eps=eps)
    mat = csr_matrix((n_samples, n_features))
    return p.fit(mat)


def fit(sample_file, dict_file, output_file, eps=0.1):
    n_samples = utils.count_lines(sample_file)
    n_features = utils.count_lines(dict_file)

    print 'creating projection matrix... \r',
    sys.stdout.flush()
    p = _get_projection(n_samples, n_features, eps=eps)

    with open(output_file, 'wb') as f:
        f.write(utils.zdumps(p))
        # pickle.dump(p, f)
        print 'projection matrix pickled to %s.' % output_file


def transform(sample_file, dict_file, projection_file, output_file):
    n_samples = utils.count_lines(sample_file)
    n_features = utils.count_lines(dict_file)
    batch_size = 100000

    print 'loading projector...'
    with open(projection_file, 'rb') as f:
        p = utils.zloads(f.read())
        # p = pickle.load(f)

    with open(output_file, 'w') as f:
        for (v, idx, ptr) in utils.load_data_batch(sample_file, batch_size, np.intc, n_samples):
            X = csr_matrix((v, idx, ptr), shape=(len(ptr)-1, n_features))
            print 'transforming... \r',
            sys.stdout.flush()
            T = p.transform(X)

            print 'saving...       \r',
            sys.stdout.flush()
            utils.save_data(f, T)
        print '\nTransform completed.'

if __name__ == '__main__':
    if len(sys.argv) < 6:
        print 'Require 5 arguments.'
        exit(1)
    op = sys.argv[1]
    if op == 'fit':
        sample_f = sys.argv[2]
        dict_f = sys.argv[3]
        output_f = sys.argv[4]
        eps = float(sys.argv[5])

        fit(sample_f, dict_f, output_f, eps)
    elif op == 'transform':
        sample_f = sys.argv[2]
        dict_f = sys.argv[3]
        projection_f = sys.argv[4]
        output_f = sys.argv[5]

        transform(sample_f, dict_f, projection_f, output_f)
