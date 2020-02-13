import logging
import datetime as datetime
import itertools
from dataset_tools import io
import re

DATA_FD = io.FolderOperator.from_script_path(__file__).to('../data')

fd = DATA_FD.to('raw')
out_fd = DATA_FD.to('clean_data')

logger = logging.getLogger()
logger.setLevel('INFO')
logger.addHandler(logging.StreamHandler())
logger.addHandler(logging.FileHandler(out_fd.fpath('log.txt')))



collate_meta = list(io.read_csv_lines(fd.fpath('orgcodecollate-meta.csv')))
collate_h2i = {line[0]: idx for idx, line in enumerate(collate_meta)}


def flt_conll_space(lines):
    cur = []
    for line in lines:
        components = io.split_line(line)
        if not components:
            assert cur
            yield io.join_line(cur)
            cur = []
        else: 
            cur.append(components[1])
    if not cur:
        yield io.join_line(cur)




pattern = re.compile(r'[A-Z0-9]+')
init_time = datetime.datetime.strptime('2009-01-01 00:00:00', '%Y-%m-%d %H:%M:%S')

cleaned = []
discarded = []

for line in io.read_csv_lines(fd.fpath('orgcodecollate.csv'), tqdm=True):
    orgcode = line[collate_h2i['ORGCODE']]
    matchCode = pattern.match(orgcode)
    crt_time = datetime.datetime.strptime(line[collate_h2i['CREATEDATE']], '%Y-%m-%d %H:%M:%S')
    if matchCode or crt_time < init_time:
        discarded.append(line)
    else:
        csvline = []
        for e in line:
            csvline.append(e)
        cleaned.append(csvline)

io.write_csv_lines(out_fd.fpath('organization_code_cleaned.csv'), [
        e for e in cleaned
])
io.write_lines(out_fd.fpath('organization_code_discarded.txt'), discarded)
