import os
import sys
import utils
import numpy as np
import gzip
from multiprocessing import Pool
from sklearn.ensemble import ExtraTreesClassifier, RandomForestClassifier
import cPickle


def train(X, y, target_model, n_estimators=10, n_jobs=1):
    print 'training...'
    if target_model == 'ExtraTree':
        model = ExtraTreesClassifier(n_estimators=n_estimators, min_samples_leaf=15, n_jobs=n_jobs)
    elif target_model == 'RandomForest':
        model = RandomForestClassifier(n_estimators=n_estimators, min_samples_leaf=15, n_jobs=n_jobs, verbose=1)
    else:
        raise ValueError('Target model %s is not supported.' % target_model)

    return model.fit(X.toarray(), y)


def write_prediction(f, y, classes):
    for i in xrange(0, len(y[0])):
        p = set()
        for l in xrange(0, 5):
            yli = y[l][i]
            np.place(yli, yli == 0, -np.inf)
            yli[0] = -np.inf
            for t in xrange(0, 5):
                pos = np.argmax(yli)
                c = classes[l][pos]
                if c in p:
                    yli[pos] = -np.inf
                else:
                    break
            
            if c != -1 and yli[pos] != 0:
                f.write('%d:%f ' % (c, yli[pos]))
                p.add(classes[l][pos])
        f.write('\n')

    #for row in y:
    #    ind = np.argsort(row)[::-1]
    #    for count, i in enumerate(ind):
    #        if count >= 20:
    #            break
    #        f.write('%d:%f ' % (model.classes_[i], row[i]))
    #    f.write('\n')


def append_prediction(pred, y, classes):
    for i in xrange(0, len(y[0])):
        for l in xrange(0, 5):
            mx = np.argsort(y[l][i])[-50:][::-1]
            pred[l].append([(classes[l][c], y[l][i][c]) for c in mx])
    return pred


def get_class_map(y_classes, classes):
    # Find map
    class_map = []
    for output_k in xrange(len(y_classes)):
        j = 0
        class_map.append([])
        for c in y_classes[output_k]:
            while classes[j] != c:
                j += 1
            class_map[output_k].append(j)
    return class_map


def apply_class_map(y, class_map, n_classes, n_outputs):
    n_samples = y[0].shape[0]

    new_y = []
    for k in xrange(n_outputs):
        # Apply map
        new_y.append(np.zeros((n_samples, n_classes), dtype=np.float16))
        new_y[k][:, class_map[k]] += y[k][:, range(len(class_map[k]))]
    return new_y

def split_train(X, y, model_name, n_estimators, output_file, i):
    model = train(X, y, model_name, n_estimators)

    fname = utils.insert_sub_dir(output_file + '_' + str(i), 'RF')
    with gzip.open(fname, 'wb') as f:
        print 'saving model to ' + fname
        cPickle.dump(model, f, cPickle.HIGHEST_PROTOCOL)
        print 'model %d saved to %s' % (i, fname)

    return fname

def main():
    operation = sys.argv[1]
    if operation == 'train':
        model = sys.argv[2]
        if len(sys.argv) > 6:
            n_samples = int(sys.argv[6])
            X, y = utils.load_data(feature_file=sys.argv[3], label_file=sys.argv[4], n_samples=n_samples)
        else:
            X, y = utils.load_data(feature_file=sys.argv[3], label_file=sys.argv[4])
        model = train(X, y, model)

        output_file = sys.argv[5]            
        with gzip.open(output_file, 'wb') as f:
            cPickle.dump(model, f, cPickle.HIGHEST_PROTOCOL)
            print 'model saved to %s.' % output_file

    elif operation == 'test':
        # test ValRun/RF.model ValFeature/Test.Body.BOW ValRun/RF.predict
        model_file = sys.argv[2]
        feature_file = sys.argv[3]
        output_file = sys.argv[4]
        n_samples = utils.count_lines(feature_file)
        with gzip.open(model_file, 'rb') as f:
            print 'loading model...'
            model = cPickle.load(f)

        with open(output_file, 'wb') as f:
            for i in xrange(5):
                try:
                    os.remove(output_file + '.' + str(i))
                except OSError:
                    pass

            for i_batch, X in enumerate(utils.load_data_batch(feature_file, 10000, n_samples)):
                y = model.predict_log_proba(X.toarray())
                write_prediction(f, y, model.classes_)
                for i in xrange(5):
                    with open(output_file + '.' + str(i), 'a') as ff:
                        utils.write_prediction(ff, y[i], model.classes_[i])

    elif operation == 'split_train':
        model_name = sys.argv[2]
        feature_file=sys.argv[3]
        label_file=sys.argv[4]
        n_models=int(sys.argv[5])
        rate_choices=float(sys.argv[6])
        n_estimators=int(sys.argv[7])
        n_jobs=int(sys.argv[8])
        normalize = sys.argv[9] == 'normalize'
        output_file = sys.argv[10]

        pool = Pool(processes=n_jobs)

        for i in xrange(0, n_models):
            X, y = utils.load_data(feature_file, label_file, rate_choices=rate_choices, normalize=normalize)
            split_train(X, y, model_name, n_estimators, output_file, i)

        # result = []
        # for i in xrange(0, n_models):
        #     X, y = load_data(feature_file, label_file, rate_choices=rate_choices)
        #     result.append(pool.apply_async(split_train, (X, y, model_name, n_estimators, output_file, i)))
        #     if len(result)==n_jobs:
        #         [r.get() for r in result]
        #         del result[:]
        # [r.get() for r in result]
        
        with gzip.open(output_file, 'w') as f:
            f.write(str(n_models))

    elif operation == 'split_test':
        # split_test ValRun/RF_split.model ValFeature/Test.Body.BOW 1500 ValRun/RF_split.y
        model_file = sys.argv[2]
        feature_file = sys.argv[3]
        n_classes = int(sys.argv[4])
        normalize = sys.argv[5] == 'normalize'
        output_file = sys.argv[6]
        
        '''
        For each model,
            go thru the data by 50000 batch and make prediction.
            Output file: RF.predict.m{model_name}.{batch_number}
        '''
        n_samples = utils.count_lines(feature_file)
        classes = range(-1, n_classes)
        with gzip.open(model_file, 'r') as f:
            n_models = int(f.read())

        for i_model in xrange(0, n_models):
            print 'generating prediction from model %d...' % i_model
            fname = utils.insert_sub_dir(model_file + '_' + str(i_model), 'RF')
            print 'loading model...'
            with gzip.open(fname, 'r') as f_model:
                model = cPickle.load(f_model)
                model.n_jobs = 1
            class_map = get_class_map(model.classes_, classes)
            for i_batch, X in enumerate(utils.load_data_batch(feature_file, 10000, n_samples, normalize)):
                print 'predicting...'
                y = model.predict_proba(X.toarray())
                y = apply_class_map(y, class_map, len(classes), 5)

                fname_out = utils.insert_sub_dir('%s.m%d.%d' % (output_file, i_model, i_batch), 'RF')
                with open(fname_out, 'w') as f_out:
                    cPickle.dump(y, f_out, cPickle.HIGHEST_PROTOCOL)
            n_batches = i_batch+1

        with open(output_file, 'w') as f:
            f.write(str(n_batches))

    elif operation == 'combine':
        # combine ValRun/RF_split.model ValRun/RF_split.y 1500 ValRun/RF_split.predict
        model_file = sys.argv[2]
        split_predict_file = sys.argv[3]
        n_classes = int(sys.argv[4])
        output_file = sys.argv[5]

        print 'combining predictions...'
        with gzip.open(model_file, 'r') as f:
            n_models = int(f.read())
        with open(split_predict_file, 'r') as f:
            n_batches = int(f.read())
        classes = range(-1, n_classes)

        with open(output_file, 'w') as f:
            for i_batch in xrange(0, n_batches):
                y = [None]*5
                for i_model in xrange(0, n_models):
                    fname_pred = utils.insert_sub_dir('%s.m%d.%d' % (split_predict_file, i_model, i_batch), 'RF')
                    with open(fname_pred) as f_pred:
                        y_model = cPickle.load(f_pred)
                        for j in xrange(0, len(y_model)):
                            np.place(y_model[j], y_model[j] == -np.inf, -1000)
                            if y[j] is None:
                                y[j] = y_model[j]
                            else:
                                y[j] = y[j] + y_model[j]

                    print 'model %d/%d\r, batch %d/%d...' % (i_model+1, n_models, i_batch+1, n_batches),
                    sys.stdout.flush()

                write_prediction(f, y, [classes]*5)
        print 'All prediction combined successfully.'


if __name__ == '__main__':
    main()
