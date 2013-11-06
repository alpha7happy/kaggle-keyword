import array
import cPickle
import itertools
import numpy as np
import re
import subprocess
import zlib


def _make_int_array():
    """Construct an array.array of a type suitable for scipy.sparse indices."""
    return array.array(str("i"))


def _make_float_array():
    return array.array(str("f"))


def _init_data(dtype):
    if dtype == np.intc:
        values = _make_int_array()
    elif dtype == np.float16:
        _make_float_array()
    else:
        raise ValueError('Unknown dtype.')

    indices = _make_int_array()
    indptr = _make_int_array()
    indptr.append(0)
    return values, indices, indptr


def _convert_data(values, indices, indptr, dtype):
    indices = np.frombuffer(indices, dtype=np.intc)
    indptr = np.frombuffer(indptr, dtype=np.intc)
    values = np.frombuffer(values, dtype=dtype)
    return values, indices, indptr


def load_data_batch(file_name, batch_size, dtype=np.float16, n_samples=None):
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

            if i % 1000 == 0:
                if n_samples:
                    print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*i/n_samples, i, n_samples),
                else:
                    print 'loading samples %d...\r' % i

        yield _convert_data(values, indices, indptr, dtype)


def load_data(file_name, dtype=np.float16, n_samples=None):
    with open(file_name, 'r') as f:
        values, indices, indptr = _init_data(dtype)
        for i, line in enumerate(f):
            sp = re.split('[: ]', line)
            for j in range(0, len(sp), 2):
                indices.append(sp[j])
                values.append(dtype(sp[j+1]))
            indptr.append(len(indices))

            if i % 1000 == 0:
                if n_samples:
                    print 'loading samples %.1f%%(%d/%d)...\r' % (100.0*i/n_samples, i, n_samples),
                else:
                    print 'loading samples %d...\r' % i

        return _convert_data(values, indices, indptr, dtype)


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
