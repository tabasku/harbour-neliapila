# -*- coding: utf-8 -*

from getdata import req
import json
import threading
import storage
import sys
if sys.platform != 'win32':
    import pyotherside
import utils


def get_default():
    database = storage.Storage()
    default_board = database.get_default()
    return default_board

def get_pages(board):
    database = storage.Storage()
    pages = int(database.get_pages(board))
    return pages


def get_threads(board,page):
    threads = json.loads(req("https://a.4cdn.org/{board}/{page}.json".format(board=board, page=page)))

    thread_list = []

    for thread in threads['threads']:
        thread_list.append(thread['posts'][0])

    ## PYTHONIC PARSING. HTML TAGS dont work well yet, until fix use js method directly from qml
    thread_list = utils.parse_posts(thread_list,board)
    pyotherside.send('threads', thread_list)

def thread_archived(postNo):
    is_archived = False
    archived = json.loads(req("https://a.4cdn.org/adv/archive.json"))
    if postNo in archived:
        is_archived = True

    return is_archived


def get_threads_info(board,post_no=None):

    thread_info = json.loads(req("https://a.4cdn.org/{board}/threads.json".format(board=board)))

    def search_no(post_no,list):
        for thread in list:
            if thread['no'] == post_no:
                return thread['last_modified']

    if post_no:
        for info in thread_info:
            thread_alive = search_no(post_no,info['threads'])
            if thread_alive:
                thread = {'last_modified':thread_alive,'page':info['page']}
                return thread



class Threads:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def thread_this(self,target_method,args):
        if self.bgthread.is_alive():
            return

        if target_method == "get":
            board = args['board']
            page = args['page']
            self.bgthread = threading.Thread(target=get_threads(board,page))

        self.bgthread.start()

data = Threads()