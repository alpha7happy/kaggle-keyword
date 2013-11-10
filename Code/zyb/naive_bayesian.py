import sys
import utils
import numpy as np
from scipy.sparse import csc_matrix
from sklearn.naive_bayes import MultinomialNB


def transform(X, y):
    n_new_samples = sum(sum(y != 0))
    new_y = utils.make_int_array()
    p = csc_matrix((X.shape(2), n_new_samples))

    idx_r, idx_c = np.where(y != 0)
    for j in idx_c:
        for i in idx_r:
            new_y.append()

def train(X, y):
    model = MultinomialNB()
    return model.fit(, )


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