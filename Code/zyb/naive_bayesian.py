import sys
import utils
import numpy as np
from scipy.sparse import csc_matrix
from sklearn.naive_bayes import MultinomialNB


def transform(X, y):
    """
    1. convert row-based features to col-based.
    2. transform multi-label to multiple samples with single-label.
    """
    n_new_samples = sum(sum(y != 0))
    new_y = utils.make_int_array()
    p = csc_matrix((X.shape(1), n_new_samples))

    X = np.transpose(X)
    idx_c, idx_r = np.where(y != 0)
    y = np.transpose(y)

    for i, (i_r, i_c) in enumerate(zip(idx_r, idx_c)):
        new_y.append(y[i_r, i_c])
        p[i_c, i] = 1

    new_X = X*p
    return new_X.toarray(), np. new_y


def train(X, y):
    model = MultinomialNB()
    return model.fit(X, y)


def load_data(feature_file, label_file):
    # n_samples = utils.count_lines(feature_file)
    n_samples = 10000
    values, indices, indptr = utils.load_data(feature_file, n_samples=n_samples)
    X = csc_matrix((values, indices, indptr))

    indices, values, indptr = utils.load_data(label_file, dtype=np.intc, n_samples=n_samples)

    for i in range(0, len(indptr)-1):
        current = indptr[i]
        next = indptr[i+1]
        indices[current:next] = range(0, next-current)
    y = csc_matrix((values, indices, indptr))

    return np.transpose(X), np.transpose(y)


def main():
    operation = sys.argv[1]
    if operation == 'train':
        X, y = load_data(feature_file=sys.argv[2], label_file=sys.argv[3])
        X, y = transform(X, y)
        model = train(X, y)

        output_file = sys.argv[3]
        with open(output_file, 'wb') as f:
            f.write(utils.zdumps(model))
            print 'model saved to %s.' % output_file
