import sys
import utils
import numpy as np
from sklearn.ensemble import ExtraTreesClassifier, RandomForestClassifier
from scipy.sparse import csc_matrix
import array

EMPTY_TAG_START = 1000000L
current_empty_tag = EMPTY_TAG_START


def empty_tag_id():
    global current_empty_tag
    current_empty_tag += 1
    return current_empty_tag


def train(X, y, target_model):
    if target_model == 'ExtraTree':
        model = ExtraTreesClassifier(n_estimators=100, max_depth=5)
    elif target_model == 'RandomForest':
        model = RandomForestClassifier(n_estimators=10, min_samples_leaf=2)
    else:
        raise ValueError('Target model %s is not supported.' % target_model)

    return model.fit(np.transpose(X).toarray(), y)


def load_data(feature_file, label_file):
    n_samples = utils.count_lines(feature_file)
    # n_samples = 10000
    values, indices, indptr = utils.load_data(feature_file, dtype=np.intc, n_samples=n_samples)
    X = csc_matrix((values, indices, indptr))

    if label_file:
        values, indices, indptr = utils.load_data(label_file, dtype=np.intc, n_samples=n_samples)
        # one label first
        y = [indices[i] for i in indptr if i<len(values)]
        y = array.array('i', y)
        #y = csc_matrix((values, indices, indptr))
        return X, y
    else:
        return X


def main():
    operation = sys.argv[1]
    if operation == 'train':
        model = sys.argv[2]
        X, y = load_data(feature_file=sys.argv[3], label_file=sys.argv[4])
        model = train(X, y, model)

        output_file = sys.argv[5]
        with open(output_file, 'wb') as f:
            f.write(utils.zdumps(model))
            print 'model saved to %s.' % output_file

    if operation == 'test':
        model_file = sys.argv[2]
        feature_file = sys.argv[3]
        output_file = sys.argv[4]
        X = load_data(feature_file=feature_file, label_file=None)
        with open(model_file, 'rb') as f:
            model = utils.zloads(f.read())

        with open(output_file, 'wb') as f:
            y = model.predict_log_proba(np.transpose(X).toarray())
            for row in y:
                ind = np.argsort(row)[::-1]
                for count, i in enumerate(ind):
                    if count >= 20:
                        break
                    f.write('%d:%f ' % (i, row[i]))
                f.write('\n')


if __name__ == '__main__':
    main()