# -*- coding: utf-8 -*

from getdata import req
import json
import threading
import storage
import sys
import pyotherside
import utils
import os,sys,inspect
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"lib")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import basc_py4chan



def get_default():
    database = storage.Storage()
    default_board = database.get_default()
    return default_board

def get_pages(board):
    database = storage.Storage()
    pages = int(database.get_pages(board))
    return pages


def get_threads(board_id,page_no):
    #threads = json.loads(req("https://a.4cdn.org/{board}/{page}.json".format(board=board, page=page)))

    board = basc_py4chan.Board(board_id)
    threads = board.get_threads(page_no)

    thread_list = []

    for thread in threads:
        print(thread.omitted_images)
        topic = thread.topic
        thread_values = {}
        thread_values['no'] = topic.post_number
        thread_values['replies'] = len(thread.posts)-1
        thread_values['sticky'] = int(thread.sticky)
        thread_values['closed'] = int(thread.closed)
        thread_values['name'] = topic.name
        thread_values['time'] = topic.timestamp
        thread_values['ext'] = topic.file_extension
        thread_values['file_deleted'] = int(topic.file_deleted)
        if thread.omitted_images:
            thread_values['images'] = thread.omitted_images
        else:
            thread_values['images'] = int(topic.has_file)
        thread_values['semantic_url'] = topic.semantic_url
        thread_values['thumbUrl'] = topic.thumbnail_url
        thread_values['imgUrl'] = topic.file_url
        thread_values['filename'] = topic.filename
        thread_values['has_file'] = int(topic.has_file)

        if topic.subject and topic.comment:
            thread_values['com'] = '<b>{}</b><br>'.format(topic.subject) + topic.comment
        elif not topic.subject and topic.comment:
            thread_values['com'] = topic.comment
        elif topic.subject and not topic.comment:
            thread_values['com'] = '<b>{}</b>'.format(topic.subject)

        thread_list.append(thread_values)

    thread_list = utils.parse_posts(thread_list)
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

#get_threads('g',1)

