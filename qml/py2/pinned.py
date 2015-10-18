__author__ = 'joni'

from getdata import req
#from threads import get_threads
import json
import threading
import storage
import sys
from utils import strip_tags,epoch_to_readable
from posts import get_posts_info,get_new_posts_count
from threads import get_threads_info,thread_archived
import re
import time

if sys.platform != 'win32':
    import pyotherside
#import utils

def check_pinned(pinned_list):
    print(pinned_list)

def get_pins_db(post_no=None,board=None):
    database = storage.Storage()
    pins = database.get_pins(post_no,board)

    pins_list=[]

    if post_no == None and board == None:

        for pin in pins:
            short_com = pin['SHORT_COM'][2:-1].replace("&#039;","'")
            filename = database.get_thumb_dir() + "/" + re.findall(r'\d+s.jpg',pin['THUMB_URL'])[0]
            thread_dead =False
            archived = thread_archived(pin['POSTNO'])
            now = epoch_to_readable(pin['TIME_CREATED'])

            post_count = get_new_posts_count(pin['BOARD'],pin['POSTNO'],pin['REPLIES_COUNT'])
            if post_count is None:
                thread_dead = True

            pins_list.append({'no':pin['POSTNO'],'pinBoardId':pin['BOARD'],'com':short_com,'postCount':post_count,
                              'thumbUrl':filename,'threadArchived':archived,'threadDead':thread_dead,'now':now})
            #pins_list.append({'postNo':pin['POSTNO'],'pinFromBoard':pin['BOARD'],'shortCom':short_com,'postCount':post_count,'pinnedThumbSource':filename,'threadArchived':archived,'threadDead':thread_dead})
            #POSTNO,BOARD,SHORT_COM,THUMB_URL,TIME_ADDED,TIME_READ,TIME_CREATED

        print(pins_list)
        #return pins_list
        if sys.platform != 'win32':
            pyotherside.send('pinned_all', pins_list)

    elif post_no and board == None:

        for pin in pins:
            pins_list.append({'postNo':pin['POSTNO'],'board':pin['BOARD']})

        print(pins_list)
        if sys.platform != 'win32':
            pyotherside.send('pinned_postno', pins_list)

    elif board and post_no == None:
        #pin_dict = {}
        for pin in pins:
            pins_list.append(pin['POSTNO'])

        #print(pins_list)

        #pins_list = dict (zip(my_dict.values(),my_dict.keys()))
        if sys.platform != 'win32':
            pyotherside.send('pinned_board', pins_list)






def get_pinned_from_board(board):
    database = storage.Storage()
    pins = database.get_pins(board)
    print(pins)


def add_pin(post_no,board,short_com,thumb_url,time_created,replies_count):
    timestamp = int(time.time())
    database = storage.Storage()
    #Pretty ghetto way to determine if string has http tags...
    if "<" in short_com:
        short_com = strip_tags(short_com)

    if len(short_com) > 100:
        short_com = short_com[0:100]

    short_com = short_com.replace("'","&#039;")

    short_com = short_com.encode()
    database.add_pin(post_no,board,short_com,thumb_url,timestamp,time_created,replies_count)

def delete_pins(post_no=None):
    database = storage.Storage()
    database.delete_pins(post_no)

class Pinned:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def thread_this(self,target_method,args):
        if self.bgthread.is_alive():
            return

        if target_method == "get_by_postno":
            #print("GET")
            post_no = args['postno']
            self.bgthread = threading.Thread(target=get_pins_db(post_no,None))
        elif target_method == "get_by_board":
            #print("GET")
            board = args['board']
            self.bgthread = threading.Thread(target=get_pins_db(None,board))
        elif target_method == "get_all":
            self.bgthread = threading.Thread(target=get_pins_db())
        elif target_method == "set":
            print("SET")
            post_no = args['postno']
            self.bgthread = threading.Thread(target=get_pins_db(post_no))

        self.bgthread.start()


#get_pins_db()

data = Pinned()
#delete_pins(61167)
#data.thread_this('add',{'postno':123,'board':'b'})
#get_pins_db()
#add_pin(34166621,'g','''I'm 5 episodes into this edgy sick dude anime and I find out they made a reboot of the entire show that is more faithful to the manga.<br><br>Is it worth it to finish the original anime or just start over with hellsing ultimate?''')
#add_pin('667','r','''Didn't see one''')
#data.thread_this('get_by_board',{'board':'helloworld'})
#get_threads_info("g",50665689)
#add_pin('0','au','''Didn't see one time''','https://t.4cdn.org/adv/1444302443728s.jpg',1444302443)
#add_pin('16329228','adv','>fem, 19','http://i.4cdn.org/adv/1444386618975s.jpg','1444386618','100')
#add_pin('645629001','b','YLYL','http://i.4cdn.org/b/1444483625544s.jpg','1444483661','5')
#data.thread_this('get_all',{})
#get_pins_db()
#postno = postno[0]['postNo']
#board = postno[0]['board']
