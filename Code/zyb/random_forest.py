import sys
import utils
import numpy as np
import gzip
from sklearn.ensemble import ExtraTreesClassifier, RandomForestClassifier
from scipy.sparse import csc_matrix
import cPickle
import array


def train(X, y, target_model):
    print 'training...'
    if target_model == 'ExtraTree':
        model = ExtraTreesClassifier(n_estimators=10, max_depth=5)
    elif target_model == 'RandomForest':
        model = RandomForestClassifier(n_estimators=10, min_samples_leaf=15, n_jobs=2)
    else:
        raise ValueError('Target model %s is not supported.' % target_model)

    return model.fit(np.transpose(X).toarray(), y)


def load_data(feature_file, label_file, n_samples=None):
    if not n_samples:
        n_samples = utils.count_lines(feature_file)
    values, indices, indptr = utils.load_data(feature_file, dtype=np.intc, n_samples=n_samples)
    X = csc_matrix((values, indices, indptr))

    if label_file:
        # values, indices, indptr = utils.load_data(label_file, dtype=np.intc, n_samples=n_samples)
        # # one label first
        # y = [indices[i] for i in indptr if i<len(values)]
        # y = array.array('i', y)
        y = utils.load_label(label_file, n_samples=n_samples)

        return X, y
    else:
        return X


def main():
    operation = sys.argv[1]
    if operation == 'train':
        model = sys.argv[2]
        X, y = load_data(feature_file=sys.argv[3], label_file=sys.argv[4], n_samples=100000)
        model = train(X, y, model)

        output_file = sys.argv[5]
        with gzip.open(output_file, 'wb') as f:
            cPickle.dump(model, f, cPickle.HIGHEST_PROTOCOL)
            print 'model saved to %s.' % output_file

    if operation == 'test':
        model_file = sys.argv[2]
        feature_file = sys.argv[3]
        output_file = sys.argv[4]
        X = load_data(feature_file=feature_file, label_file=None, n_samples=100000)
        with gzip.open(model_file, 'rb') as f:
            model = cPickle.load(f)

        with open(output_file, 'wb') as f:
            y = model.predict_log_proba(np.transpose(X).toarray())
            for i in range(0, len(y[0])):
                for p in range(0, 5):
                    mx = np.argsort(y[p][i])[-2:][::-1]
                    if model.classes_[p][mx[0]] != -1:
                        f.write('%d:%f ' % (model.classes_[p][mx[0]], y[p][i][mx[0]]))
                    else:
                        f.write('%d:%f ' % (model.classes_[p][mx[1]], y[p][i][mx[1]]))
                f.write('\n')

            #for row in y:
            #    ind = np.argsort(row)[::-1]
            #    for count, i in enumerate(ind):
            #        if count >= 20:
            #            break
            #        f.write('%d:%f ' % (model.classes_[i], row[i]))
            #    f.write('\n')


if __name__ == '__main__':
    main()