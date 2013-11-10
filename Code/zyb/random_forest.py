import sys
import utils
import numpy as np
from sklearn.ensemble import ExtraTreesClassifier
from scipy.sparse import csc_matrix

EMPTY_TAG_START = 1000000L
current_empty_tag = EMPTY_TAG_START


def empty_tag_id():
    global current_empty_tag
    current_empty_tag += 1
    return current_empty_tag


def train(X, y):
    model = ExtraTreesClassifier(max_features=np.int(np.sqrt(y.shape[1])), n_estimators=10, max_depth=5)
    return model.fit(np.transpose(X).toarray(), np.transpose(y).toarray())


def load_data(feature_file, label_file):
    # n_samples = utils.count_lines(feature_file)
    n_samples = 10000
    values, indices, indptr = utils.load_data(feature_file, n_samples=n_samples)
    X = csc_matrix((values, indices, indptr))

    values, indices, indptr = utils.load_data(label_file, dtype=np.intc, n_samples=n_samples)
    y = csc_matrix((values, indices, indptr))
    return X, y


def main():
    operation = sys.argv[1]
    if operation == 'train':
        X, y = load_data(feature_file=sys.argv[2], label_file=sys.argv[3])
        model = train(X, y)

        output_file = sys.argv[3]
        with open(output_file, 'wb') as f:
            f.write(utils.zdumps(model))
            print 'model saved to %s.' % output_file


if __name__ == '__main__':
    main()