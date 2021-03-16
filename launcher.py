#!/usr/bin/env python3
"""mythril.py: Bug hunting on the Ethereum blockchain

   http://www.github.com/b-mueller/mythril
"""
'''
from mythril.ether import evm, util
'''

import argparse
import json
import os
import pprint
import random
import signal
import sys
import time
import traceback
from datetime import datetime
from multiprocessing import Process, Queue
from os import walk
from queue import Empty
from subprocess import Popen, PIPE

CONTRACT_FETCH_LIMIT = 50
QUEUE_SIZE_THRESHOLD = 100

DATASET_PATH = '/Users/ningyu/Downloads/dataset/'
RESULT_WRITE_PATH = './result/'


##########################################################
# begin of dump & debug interfaces
##########################################################
def dump_trace():
    exc_type, exc_value, exc_traceback = sys.exc_info()
    print("*** format_exception:")
    print(pprint.pprint(traceback.format_exception(exc_type, exc_value, exc_traceback)))


def dump_trace2():
    exc_type, exc_value, exc_traceback = sys.exc_info()
    print("*** #print_exc:")
    traceback.print_exc()


def sig_quit(signum, frame):
    print("You choose to stop me.")
    sys.exit(-1)


def die(_msg=None):
    if _msg is not None:
        print(_msg)
    sys.exit(-1)


def warn(_msg=None):
    if _msg is not None:
        print(_msg)


def pause(_msg=None):
    msg = "..."
    if _msg is not None:
        msg = _msg
    input(msg)


def escape_string(s):
    return str(s).replace("'", "''")


def print_and_flush(msg):
    print(msg)
    sys.stdout.flush()


def mkdir(dir_path):
    if not os.path.isdir(dir_path):
        os.makedirs(dir_path)


def to_format_str(obj):
    if type(obj) == bytes:
        return obj.decode()

    return str(obj)


def exec_cmd(cmd_str, debug=True):
    p = Popen(cmd_str.split(), stderr=PIPE, stdout=PIPE)
    output, errors = p.communicate()

    msg = to_format_str(output)
    if p.returncode != 0:
        msg = "'{0}' return code '{1}' \n".format(cmd_str, p.returncode)
        msg += to_format_str(errors)

    if debug:
        warn(msg)

    return msg


def get_current_unixtime(now_dt=None):
    if now_dt is None:
        now_dt = datetime.now()
    return int(time.mktime(now_dt.timetuple()))


def get_time_diff(now_dt, last_dt):
    return (int(time.mktime(now_dt.timetuple())) - int(time.mktime(last_dt.timetuple())))


##########################################################
# begin of actual logic
##########################################################
class EOSContract(object):
    def __init__(self, name, st_day, account, code, file_path):
        self.name = name
        self.st_day = st_day
        self.account = account
        self.code = code
        self.file_path = file_path

    def __str__(self):
        ret = "[+] Contract name: " + str(self.name)
        ret += "\n\t[+] account: " + self.account
        ret += "\n\t[+] st_day: " + self.st_day
        ret += "\n\t[+] file path: " + self.file_path
        # ret += "\n\t[+] code: " + str(self.code)
        return ret

    __repr__ = __str__


STATUS_INCOMING = 1  # for vulinfo
STATUS_FETCHING = 3

STATUS_PREPARING_STATIC = 11
STATUS_PREPARING_FINISHED_STATIC = 19
STATUS_VERIFYING_STATIC = 21
STATUS_VERIFYING_FINISHED_STATIC = 29
STATUS_SCANNING_STATIC = 40
STATUS_SCANNING_FINISHED_STATIC = 100

STATUS_UPLOADING_FAILED_STATIC = -11
STATUS_FETCHING_FAILED_STATIC = -21
STATUS_VERIFYING_FAILED_STATIC = -31
STATUS_SCANNING_FAILED_STATIC = -41
STATUS_SCANNING_TIMEOUT_STATIC = -51

SCANNING_MODULE_MIN_STATIC = STATUS_SCANNING_STATIC
SCANNING_MODULE_MAX_STATIC = STATUS_SCANNING_FINISHED_STATIC
# the number of modules
SCANNING_MODULE_NUM_STATIC = 2
SCANNING_MODULE_STEP_STATIC = int(
    (STATUS_SCANNING_FINISHED_STATIC - STATUS_SCANNING_STATIC) / SCANNING_MODULE_NUM_STATIC)


class ScanningModule(object):
    def __init__(self, module_name, module_description, status):
        self.module_name = module_name
        self.module_description = module_description
        self.status = status

    def __str__(self):
        ret = "[+] Module Name: " + str(self.module_name)
        ret += "\n\t[+] Module Desctiption: " + self.module_description
        ret += "\n\t[+] status: " + self.status
        ret += "\n"
        return ret

    __repr__ = __str__


scanning_module_dict = {
    # "fake_eos": ScanningModule("fake_eos", "Fake EOS", SCANNING_MODULE_MIN_STATIC),
    "fake_receipt": ScanningModule("fake_receipt", "Fake Receipt",
                                   SCANNING_MODULE_MIN_STATIC + SCANNING_MODULE_STEP_STATIC * 1),
    # "auth_check": ScanningModule("auth_check", "Authority Check",
    #                              SCANNING_MODULE_MIN_STATIC + SCANNING_MODULE_STEP_STATIC * 2),
}


def build_module_argument(eth_contract, source_output_path, smodule_name):
    module_argument = ''

    if source_output_path and len(source_output_path) > 0:
        module_argument += " --laser " + source_output_path

    return module_argument


class ScanError(Exception):
    pass


class ScanResult(object):
    def __init__(self, name, result_json_str):
        self.name = name
        self.result = []
        try:
            self.result = json.loads(result_json_str, encoding="utf-8")
        except:
            # print_and_flush("[-]Invalid result: %s" % result_json_str)
            raise ScanError

        self.issue_list = []
        if len(self.result) > 0:
            for _issue_dict in self.result:
                self.issue_list.append(_issue_dict)

    def __str__(self):
        ret = "[+] Contract ID: " + str(self.name)
        for issue in self.result:
            for key, value in issue.items():
                ret += "\n\t[+] " + str(key) + ": " + str(value)
            ret += "\n"
        return ret

    __repr__ = __str__


def update_current_status(name_list, status):
    for name in name_list:
        with open('./contract_status/' + name, 'w') as fp:
            json.dump(str(status), fp)

    return True


def fetch_unfinished_contracts(limit=CONTRACT_FETCH_LIMIT):
    # key is the file name
    contract_dict = {}

    num = 0
    names = []
    # fetch contracts according to the key of contract_status but number is not exceeding of limit
    for _, _, files in walk('./contract_status'):
        for name in files:
            if name != '.DS_Store' and num < limit:
                with open('./contract_status/' + name) as fp:
                    status = int(json.load(fp))
                    if status == STATUS_INCOMING:
                        # if status == -41:
                        names.append(name)
                        num += 1
            if num == limit:
                break
        break

    for name in names:
        name_components = name.split('-')
        account, st_day = name_components[0], name_components[1]
        with open(DATASET_PATH + name, 'rb') as fp:
            code = fp.read()
        file_path = DATASET_PATH + name
        contract_dict[name] = EOSContract(name, st_day, account, code, file_path)

    if len(contract_dict) > 0:
        update_current_status(contract_dict.keys(), STATUS_FETCHING)

    return contract_dict


def insert_scan_results(name, issue_list=None):
    if not issue_list or len(issue_list) == 0:
        pass
    else:
        account, date_part = name.split('-')[0], name[-24:-5]
        date = datetime.strptime(date_part, '%Y-%m-%d-%H-%M-%S')

        # insert account name in it
        for issue in issue_list:
            issue['account'] = account
            issue['date'] = str(date)

        with open(RESULT_WRITE_PATH + name, 'w') as fp:
            json.dump(issue_list, fp)
        print_and_flush('[+] inserted the result for file: ' + name)


def do_real_work(name, cmd_str, smodule_name=None):
    issue_count = 0
    result_json_str = ''

    try:
        print_str = "[+] worker(" + str(os.getpid()) + ") is analyzing contract: " + name
        if smodule_name is not None:
            print_str += " (" + smodule_name + ')'
        print_and_flush(print_str)
        result_json_str = exec_cmd(cmd_str)

        scan_result = ScanResult(name, result_json_str)
        issue_count += len(scan_result.result)
        insert_scan_results(name, scan_result.result)
    except:
        if 'timeout' in result_json_str:
            print('[+] current contract analysis is timeout: %s' % name)
            # issue_count -1 means timeout
            return [False, -1]
        else:
            print('[+] catch the scan error for contract: %s' % name)
            return [False, issue_count]

    return [True, issue_count]


def launch_static_analyzer(contract, tmp_dir):
    global py_cmd, static_cmd, static_path
    global scanning_module_dict

    octopus_cmd, octopus_path = static_cmd, static_path
    base_cmd_str = py_cmd + ' ' + octopus_cmd + " --depth 1 "

    cmd_str = None
    # read from file
    if contract.file_path:
        cmd_str = base_cmd_str + " -f " + contract.file_path

    if cmd_str is None:
        print_and_flush(
            "[-] worker(" + str(os.getpid()) + ") cannot fetch code: " + str(contract.name))
        update_current_status([contract.name], STATUS_FETCHING_FAILED_STATIC)
        return

    update_current_status([contract.name], STATUS_PREPARING_FINISHED_STATIC)

    update_current_status([contract.name], STATUS_SCANNING_STATIC)
    ret = True
    issue_count = 0
    # TODO support multiple detectors
    for smodule_name, smodule in scanning_module_dict.items():
        update_current_status([contract.name], smodule.status)
        cur_cmd_str = cmd_str + " --laser " + smodule_name

        print('[+] doing job:', cur_cmd_str)

        [_ret, _issue_count] = do_real_work(contract.name, cur_cmd_str, smodule_name)
        ret &= _ret
        if _issue_count == -1:
            issue_count = -1
            break
        issue_count += _issue_count

    if ret:
        if issue_count == 0:
            insert_scan_results(contract.name, None)
        update_current_status([contract.name], STATUS_SCANNING_FINISHED_STATIC)
    else:
        if issue_count == -1:
            update_current_status([contract.name], STATUS_SCANNING_TIMEOUT_STATIC)
        else:
            update_current_status([contract.name], STATUS_SCANNING_FAILED_STATIC)


def launch(contract, analysis_type, tmp_dir):
    if analysis_type in ["full", "static"]:
        launch_static_analyzer(contract, tmp_dir)


def worker_for_queue(msg_que_send, msg_que_recv, analysis_type, tmp_dir, worker_num):
    worker_pid = os.getpid()

    while True:
        try:
            print_and_flush("[+] worker(" + str(worker_pid) + ") notifying...")
            msg_que_send.put(worker_pid)  # notify the task dispatcher

            contract = msg_que_recv.get(True, 60)  # block with 60s timeout
            print_and_flush("[+] worker(" + str(worker_pid) + ") recv contract: " + str(contract.name))

            time.sleep(random.randint(1, 5))
            launch(contract, analysis_type, tmp_dir)
            time.sleep(random.randint(1, 5))

        except Empty as err:
            time.sleep(random.randint(1, 30))


def dispatcher(analysis_type, worker_num, tmp_dir):
    msg_que_list = []  # [send, recv]
    worker_list = []
    for i in range(worker_num):
        msg_que_send = Queue(QUEUE_SIZE_THRESHOLD)
        msg_que_recv = Queue(QUEUE_SIZE_THRESHOLD)
        msg_que_list.append((msg_que_send, msg_que_recv))
        # Note that send & recv are opposited in worker_for_queue2
        worker = Process(target=worker_for_queue,
                         args=(msg_que_recv, msg_que_send, analysis_type, tmp_dir, worker_num,))
        worker_list.append(worker)
        worker.start()

    analyzed_contract_num = 0
    contract_list = []
    available_msg_que_set = set()

    now_dt = last_dt = 0
    while True:
        now_dt = datetime.now()
        print_and_flush("\n[+] dispatcher (" + str(os.getpid()) + ") >>> Now: " + now_dt.strftime("%Y-%m-%d %H:%M:%S"))

        if (last_dt == 0 or get_time_diff(now_dt, last_dt) > 60) and (len(contract_list) < CONTRACT_FETCH_LIMIT / 10):
            new_contract_dict = fetch_unfinished_contracts()
            new_contract_dict_sorted = sorted(new_contract_dict.items(), key=lambda d: d[0])
            new_contract_list = [value for key, value in new_contract_dict_sorted]
            if len(new_contract_list) > 0:
                contract_list.extend(new_contract_list)
            last_dt = now_dt

        # consume msg_que_recv
        for mq_idx in range(len(msg_que_list)):
            try:
                worker_pid = msg_que_list[mq_idx][1].get(True, 1)  # block with 1 sec timeout
                if mq_idx not in available_msg_que_set:
                    print_and_flush(
                        "[+] dispatcher (%d) recv: %d, add %s to available set!" % (os.getpid(), worker_pid, mq_idx))
                    available_msg_que_set.add(mq_idx)
            except Empty as err:
                continue

        if len(contract_list) == 0:
            time.sleep(5)
            continue

        print_and_flush("[+] dispatcher (%d): [%d in queue, %d being sent]; available msg_que_set: %d" % (
            os.getpid(), len(contract_list), analyzed_contract_num, len(available_msg_que_set)))
        if len(available_msg_que_set) == 0:
            time.sleep(random.randint(1, 15))
            continue

        used_msg_que_set = set()
        for mq_idx in available_msg_que_set:
            try:
                print("[+] dispatcher (%d) send name: %s to %s" % (os.getpid(), contract_list[0].name, mq_idx))
                msg_que_list[mq_idx][0].put(contract_list.pop(0))
                analyzed_contract_num += 1
                used_msg_que_set.add(mq_idx)
            except IndexError as err:
                break

        available_msg_que_set -= used_msg_que_set

    for worker in worker_list:
        worker.join()


def main():
    global py_cmd, static_cmd, static_path, simple_cmd, simple_path, DATASET_PATH

    arg_parser = argparse.ArgumentParser(description="Analyzer Launcher of EOS Contracts")
    arg_parser.add_argument("-t", "--type", dest="analysis_type", choices=['full', 'simple', 'static'],
                            required=False, default='full', help="analysis type: full, simple or static")
    arg_parser.add_argument("-n", "--workernum", dest="worker_num", type=int,
                            required=False, default=1, help="number of worker")
    arg_parser.add_argument("--src", dest="src_path", default=None, required=False, help="dataset src file path")
    args = arg_parser.parse_args()

    py_cmd = "python3.6"
    static_cmd = "octopus_wasm"
    static_path = "./"

    tmp_dir = os.getcwd() + "/tmp"
    mkdir(tmp_dir)

    if args.src_path:
        DATASET_PATH = args.src_path

    cpu_count = os.cpu_count()
    worker_num = args.worker_num
    if worker_num > (cpu_count - 1):
        worker_num = cpu_count - 1

    print_and_flush("\n[+] CPU Count: %d, using %d" % (cpu_count, worker_num))
    dispatcher(args.analysis_type, worker_num, tmp_dir)


if __name__ == "__main__":

    try:
        signal.signal(signal.SIGINT, sig_quit)
        signal.signal(signal.SIGTERM, sig_quit)

        main()
    except Exception as err:
        dump_trace()
