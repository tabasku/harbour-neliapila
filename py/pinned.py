from getdata import req
#from threads import get_threads
import json
import threading
import storage
import sys
import html
from utils import strip_tags,epoch_to_readable
from posts import get_posts_info,get_new_posts_count
from threads import get_threads_info,thread_archived
import re
import time
import pyotherside
import os,sys,inspect

cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"lib")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

def check_pinned(pinned_list):
    print(pinned_list)

def get_pins_db(post_no=None,board=None):
    database = storage.Storage()
    pins = database.get_pins(post_no,board)

    pins_list=[]

    if post_no is None and board is None:
        for pin in pins:
            short_com = pin['SHORT_COM']
            short_com = html.unescape(short_com)

            if len(re.findall(r'\d+s.jpg',pin['THUMB_URL'])) != 0:
                filename = database.get_thumb_dir() + "/" + re.findall(r'\d+s.jpg',pin['THUMB_URL'])[0]
            else:
                filename = None

            thread_dead = False
            archived = False
            post_count = 0

            now = epoch_to_readable(pin['TIME_CREATED'])

            print("GETTIng INFO BOUT {}".format(pin['POSTNO']))

            pins_list.append({'no':pin['POSTNO'],'post_board':pin['BOARD'],'thisBoard':pin['BOARD'],'com':short_com,'postCount':post_count,
                              'thumbUrl':filename,'threadArchived':archived,'threadDead':thread_dead,
                              'now':now,'has_file':1,'pin':1,'name':'','closed':0,'images':0,'sticky':0,'replies':0})
            #POSTNO,BOARD,SHORT_COM,THUMB_URL,TIME_ADDED,TIME_READ,TIME_CREATED

        pyotherside.send('pinned_all', pins_list)

        pins_list = []

        for pin in pins:
            post_count = get_new_posts_count(pin['BOARD'],pin['POSTNO'],pin['REPLIES_COUNT'])
            if post_count is None:
                thread_dead = True
                archived = False
            else:
                archived = thread_archived(pin['POSTNO'])

            pins_list.append({'no':pin['POSTNO'],'postCount':post_count,
                              'threadArchived':archived,'threadDead':thread_dead})

        pyotherside.send('pinned_all_update', pins_list)

    elif post_no and board is None:

        for pin in pins:
            pins_list.append({'postNo':pin['POSTNO'],'board':pin['BOARD']})

        print(pins_list)
        if sys.platform != 'win32':
            pyotherside.send('pinned_postno', pins_list)

    elif board and post_no is None:
        for pin in pins:
            pins_list.append(pin['POSTNO'])

        if sys.platform != 'win32':
            pyotherside.send('pinned_board', pins_list)


def get_pinned_from_board(board):
    database = storage.Storage()
    pins = database.get_pins(board)
    print(pins)


def add_pin(post_no,board,short_com,thumb_url,time_created,replies_count):
    timestamp = int(time.time())
    database = storage.Storage()

    # This regex should detect any tags and strip them out.
    tagStripper = re.compile(r'<[^>]+>')
    short_com = tagStripper.sub('', short_com)

    # limit length of pin
    if len(short_com) > 100:
        short_com = short_com[0:100]

    html.escape(short_com).encode('ascii', 'xmlcharrefreplace')
    short_com = short_com.replace("\"","&#034;")
    try:
        thumb_url
    except NameError:
        thumb_url = None

    database.add_pin(post_no,board,short_com,thumb_url,timestamp,time_created,replies_count)


def update_pin(post_no,board,replies_count):
    timestamp = int(time.time())
    database = storage.Storage()
    database.update_pin(post_no,board,timestamp,replies_count)


def delete_pins(post_no=None,board=None):
    database = storage.Storage()
    database.delete_pins(post_no,board)


class Pinned:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def thread_this(self,target_method,args):
        if self.bgthread.is_alive():
            return

        if target_method == "get_by_postno":
            post_no = args['postno']
            self.bgthread = threading.Thread(target=get_pins_db(post_no,None))
        elif target_method == "get_by_board":
            board = args['board']
            self.bgthread = threading.Thread(target=get_pins_db(None,board))
        elif target_method == "get_all":
            self.bgthread = threading.Thread(target=get_pins_db())
        elif target_method == "set":
            print("SET")
            post_no = args['postno']
            self.bgthread = threading.Thread(target=get_pins_db(post_no))

        self.bgthread.start()


data = Pinned()
