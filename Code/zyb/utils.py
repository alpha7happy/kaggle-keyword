import os
import array
import cPickle
import itertools
import numpy as np
import re
import subprocess
import zlib
import sys

from scipy.sparse import csr_matrix, csc_matrix


EMPTY_TAG_START = -1
current_empty_tag = EMPTY_TAG_START


def empty_tag_id():
    #global current_empty_tag
    #current_empty_tag += 1
    return current_empty_tag


def make_int_array():
    """Construct an array.array of a type suitable for scipy.sparse indices."""
    return array.array("i")


def _make_float_array():
    return array.array("f")


def _init_data(dtype):
    if dtype == np.intc:
        values = make_int_array()
    elif dtype == np.float32:
        values = _make_float_array()
    else:
        raise ValueError('Unknown dtype.')

    indices = make_int_array()
    indptr = make_int_array()
    indptr.append(0)
    return values, indices, indptr


def _convert_data(values, indices, indptr, dtype):
    indices = np.frombuffer(indices, dtype=np.intc)
    indptr = np.frombuffer(indptr, dtype=np.intc)
    values = np.frombuffer(values, dtype=dtype)
    return values, indices, indptr


def _load_data_batch(file_name, batch_size, dtype=np.float32, n_samples=None):
    with open(file_name, 'r') as f:
        values, indices, indptr = _init_data(dtype)

        for i, line in enumerate(f):
            sp = re.split('[: ]', line)

            r = range(0, len(sp)-1, 2)
            indices.extend([int(sp[j]) for j in r])
            values.extend([dtype(sp[j+1]) for j in r])
            indptr.append(len(indices))

            if (i+1) % 1000 == 0:
                print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*(i+1)/n_samples, (i+1), n_samples),
                sys.stdout.flush()

            if (i+1) == n_samples:
                break

            if (i+1) % batch_size == 0:
                print ''
                yield _convert_data(values, indices, indptr, dtype)
                values, indices, indptr = _init_data(dtype)

        print 'loading samples %.1f%%(%d/%d)...' % (100.0, n_samples, n_samples)
        if len(values) > 0:
            yield _convert_data(values, indices, indptr, dtype)


def _load_data(file_name, n_samples, dtype=np.float32, choices=None):
    idx_c=0
    s = re.compile('[: ]')
    with open(file_name, 'r') as f:
        values, indices, indptr = _init_data(dtype)
        for i, line in enumerate(f):
            if n_samples and i == n_samples:
                break
            if choices is not None:
                if i!=choices[idx_c]:
                    continue
                else:
                    idx_c+=1
                    if idx_c==len(choices):
                        break

            sp = s.split(line)

            r = range(0, len(sp)-1, 2)
            indices.extend([int(sp[j]) for j in r])
            values.extend([dtype(sp[j+1]) for j in r])
            indptr.append(len(indices))

            if choices is None and i % 1000 == 0:
                print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*i/n_samples, i, n_samples),
                sys.stdout.flush()
            elif choices is not None and idx_c % 1000 == 0:
                print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*idx_c/len(choices), idx_c, len(choices)),
                sys.stdout.flush()

        if choices is None:
            print 'loading samples %.1f%%(%d/%d)...' % (100.0, n_samples, n_samples)
        else:
            print 'loading samples %.1f%%(%d/%d)...' % (100.0*idx_c/len(choices), idx_c, len(choices))
            sys.stdout.flush()

        return _convert_data(values, indices, indptr, dtype)


def _load_label(file_name, n_samples=None, n_labels=5, choices=None):
    idx_c=0
    with open(file_name, 'r') as f:
        y = make_int_array()
        for i, line in enumerate(f):
            if n_samples and i == n_samples:
                break
            if choices is not None:
                if i!=choices[idx_c]:
                    continue
                else:
                    idx_c+=1
                    if idx_c==len(choices):
                        break

            sp = re.split('[: ]', line.rstrip())
            added = 0
            if len(sp) > 1:
                for j in range(0, len(sp), 2):
                    v = int(sp[j])
                    if v != -1:
                        y.append(v)
                        added += 1
                    if added >= n_labels:
                        break
                while added < n_labels:
                    y.append(empty_tag_id())
                    added += 1

        return np.ndarray(shape=(len(y)/5, 5), buffer=np.array(y), dtype=int)


def normalize_rows(X, norm='l1'):
    print 'normalizing data...'
    row_idx, col_idx = X.nonzero()

    if norm == 'l1':
        row_sums = np.array(X.sum(axis=1))[:,0]
        X.data /= row_sums[row_idx]
    elif norm == 'l2':
        bak = X.data
        X.data = X.data**2
        norms = np.sqrt(np.array(X.sum(axis=1))[:,0])
        X.data = bak
        X.data /= norms[row_idx]
    return X


def load_data(feature_file, label_file=None, n_samples=None, rate_choices=None, choices=None, normalize=False):
    if not n_samples:
        n_samples = count_lines(feature_file)
    if rate_choices and choices is None:
        n_choices = int(np.ceil(n_samples*rate_choices))
        choices = np.random.choice(n_samples, n_choices, replace=False)
        choices.sort()
    else:
        choices = None

    dtype = np.float32 if normalize else np.intc
    values, indices, indptr = _load_data(feature_file, n_samples, dtype=dtype, choices=choices)
    X = csr_matrix((values, indices, indptr))
    X = normalize_rows(X) if normalize else X

    if label_file:
        # values, indices, indptr = utils.load_data(label_file, n_samples, dtype=np.intc)
        # # one label first
        # y = [indices[i] for i in indptr if i<len(values)]
        # y = array.array('i', y)
        y = _load_label(label_file, n_samples=n_samples, choices=choices)

        return X, y
    else:
        return X


def load_data_batch(feature_file, size_batch, n_samples=None, normalize=False):
    if not n_samples:
        n_samples = count_lines(feature_file)
    for values, indices, indptr in _load_data_batch(feature_file, size_batch, np.intc, n_samples):
        X = csr_matrix((values, indices, indptr))
        yield normalize_rows(X) if normalize else X


def save_data(f, X, fp_precision=6):
    format = '%%d:%%.%dg' % fp_precision
    cx = X.tocoo()
    last_i = 0
    out = []

    for i, j, v in itertools.izip(cx.row, cx.col[::-1], cx.data):
        if i != last_i:
            last_i = i
            f.write(' '.join(out).replace(':0.', ':.').replace(':-0.', ':-.'))
            f.write('\n')
            out = []
        out.append(format % (j, v))

    f.write(' '.join(out).replace(':0.', ':.').replace(':-0.', ':-.'))
    f.write('\n')


def zdumps(o):
    return zlib.compress(cPickle.dumps(o, cPickle.HIGHEST_PROTOCOL), 9)


def zloads(zstr):
    return cPickle.loads(zlib.decompress(zstr))


def count_lines(f):
    output = subprocess.Popen(["wc", "-l", f],
                              stdout=subprocess.PIPE).communicate()[0]
    return int(output.lstrip().split(' ')[0])


def insert_sub_dir(p, dir_name):
    d, n = os.path.split(p)
    sub_dir = os.path.join(d, dir_name)
    if not os.path.exists(sub_dir):
        os.mkdir(sub_dir)
    return os.path.join(sub_dir, n)


def to_single_output(X, y):
    print 'converting to single output...'
    new_y = make_int_array()
    values, indices, indptr = _init_data(np.intc)
    row = 0
    for i in xrange(len(y)):
        yi = y[i]
        for j in xrange(len(yi)):
            if yi[j] != -1:
                new_y.append(yi[j])
                indices.append(row)
                values.append(1)
                row += 1
        indptr.append(len(indices))
    P = csc_matrix(_convert_data(values, indices, indptr, np.intc))
    return P*X, new_y
