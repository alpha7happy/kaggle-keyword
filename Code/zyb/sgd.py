import cPickle
import gzip
import numpy as np
import sys
import utils
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import SGDClassifier


def train(X, y, loss="log", penalty="l2"):
    n_iter = min(np.ceil(10.0**6/X.shape[0]+1), 5)
    print 'number of iterations: %d' % n_iter
    c = SGDClassifier(loss=loss,
                      penalty=penalty,
                      n_jobs=-1,
                      n_iter=n_iter,
                      verbose=1,
                      shuffle=True)
    return c.fit(X, y)


def main():
    operation = sys.argv[1]
    if operation == 'train':
        loss = sys.argv[2]
        output_file = sys.argv[5]        

        X, y = utils.load_data(feature_file=sys.argv[3],
                               label_file=sys.argv[4],
                               dtype=np.float64)

        scaler = StandardScaler(with_mean=False)
        # scaler.fit(X)

        X, y = utils.to_single_output(X, y)
        # X = scaler.transform(X)

        with gzip.open(output_file + '.scaler', 'wb') as f:
            cPickle.dump(scaler, f, cPickle.HIGHEST_PROTOCOL)

        print 'training...'
        model = train(X, y, loss)

        with gzip.open(output_file, 'wb') as f:
            cPickle.dump(model, f, cPickle.HIGHEST_PROTOCOL)
            print 'model saved to %s.' % output_file            
    
    elif operation == 'test':
        model_file = sys.argv[2]
        feature_file = sys.argv[3]
        output_file = sys.argv[4]
        X = utils.load_data(feature_file,
                            dtype=np.float64)
        with gzip.open(model_file + '.scaler', 'rb') as f:
            scaler = cPickle.load(f)
        with gzip.open(model_file, 'rb') as f:
            print 'loading model...'
            model = cPickle.load(f)

        print 'testing...'
        with open(output_file, 'wb') as f:
            # X = scaler.transform(X)
            y = model.predict_log_proba(X)
            utils.write_prediction(f, y, model.classes_)


if __name__ == '__main__':
    main()
