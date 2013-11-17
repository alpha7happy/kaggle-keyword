import array
import cPickle
import itertools
import numpy as np
import re
import subprocess
import zlib
import sys


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


def load_data_batch(file_name, batch_size, dtype=np.float32, n_samples=None):
    with open(file_name, 'r') as f:
        values, indices, indptr = _init_data(dtype)

        for i, line in enumerate(f):
            sp = re.split('[: ]', line)
            for j in range(0, len(sp)-1, 2):
                indices.append(int(sp[j]))
                values.append(dtype(sp[j+1]))
            indptr.append(len(indices))

            if (i+1) % batch_size == 0:
                yield _convert_data(values, indices, indptr, dtype)
                values, indices, indptr = _init_data(dtype)

            if i % 1000 == 999:
                if n_samples:
                    print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*(i+1)/n_samples, (i+1), n_samples),
                else:
                    print 'loading samples %d...\r' % i

        yield _convert_data(values, indices, indptr, dtype)


def load_data(file_name, dtype=np.float32, n_samples=None):
    s = re.compile('[: ]')
    with open(file_name, 'r') as f:
        values, indices, indptr = _init_data(dtype)
        for i, line in enumerate(f):
            if n_samples and i == n_samples:
                break
            sp = s.split(line)

            r = range(0, len(sp)-1, 2)
            indices.extend([int(sp[j]) for j in r])
            values.extend([dtype(sp[j]) for j in r])
            indptr.append(len(indices))

            if i % 1000 == 0:
                if n_samples:
                    print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*i/n_samples, i, n_samples),
                    sys.stdout.flush()
                else:
                    print 'loading samples %d...\r' % i
                    sys.stdout.flush()

        print 'loading samples %.1f%%(%d/%d)...' % (100.0, i, i)
        return _convert_data(values, indices, indptr, dtype)


def load_label(file_name, n_samples=None, n_labels=5):
    with open(file_name, 'r') as f:
        y = make_int_array()
        for i, line in enumerate(f):
            if n_samples and i == n_samples:
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
