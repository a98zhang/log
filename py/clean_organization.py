import logging
import datetime as datetime
import itertools
from dataset_tools import io

DATA_FD = io.FolderOperator.from_script_path(__file__).to('../data')

fd = DATA_FD.to('raw')
out_fd = DATA_FD.to('clean_data')

logger = logging.getLogger()
logger.setLevel('INFO')
logger.addHandler(logging.StreamHandler())
logger.addHandler(logging.FileHandler(out_fd.fpath('log.txt')))


organization_meta = list(io.read_csv_lines(fd.fpath('organization-meta.csv')))
organization_h2i = {line[0]: idx for idx, line in enumerate(organization_meta)}

cleaned = []
discarded = []

for line in io.read_csv_lines(fd.fpath('organization.csv'), tqdm=True):
    if line[organization_h2i['STATUS']] == '41' and line[organization_h2i['CREATEDATE']] != 'None':
        csvline = []
        for e in line:
            csvline.append(e)
        cleaned.append(csvline)

io.write_csv_lines(out_fd.fpath('organization_cleaned.csv'), [
        e for e in cleaned
])
io.write_lines(out_fd.fpath('organization_discarded.txt'), discarded)
