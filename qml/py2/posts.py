__author__ = 'joni'
# -*- coding: utf-8 -*

from getdata import req
import json
import threading
import time
#import storage
import sys
if sys.platform != 'win32':
    import pyotherside
import utils


def strip_posts(post_list,posts_to_show):
    stripped_post_list = []
    for post in post_list:
        if post in posts_to_show:
            stripped_post_list.append(post)

    return stripped_post_list


def get_posts(board,postno):
    posts = json.loads(req("https://a.4cdn.org/{board}/thread/{postno}.json"
                             .format(board=board, postno=postno)))

    post_list = []
    post_replies = {}

    for post in posts['posts']:
        post_list.append(post)
        if 'com' in post:
            replies = utils.collect_replies(post['com'])
            if replies:
                for reply in replies:
                    if reply not in post_replies:
                        post_replies[reply]=[]
                    post_replies[reply].append(post['no'])

    post_list  = utils.parse_posts(post_list,board,post_replies)
    pyotherside.send('posts', post_list)

def get_new_posts_count(board,postno,replies_count):
    posts = req("https://a.4cdn.org/{board}/thread/{postno}.json"
                             .format(board=board, postno=postno))

    total = None

    if isinstance(posts, str):
        posts = json.loads(posts)
        updated_replies_count = posts['posts'][0]['replies']
        total = updated_replies_count - replies_count

        return total



def get_posts_info(board,postno,time_read):
    posts = json.loads(req("https://a.4cdn.org/{board}/thread/{postno}.json"
                             .format(board=board, postno=postno)))

    post_list = []

    for post in posts['posts']:
        if time_read < post['time']:
            #print(post['time'])
            post['unread'] = int(time.time())
            post_list.append(post)


    return post_list

class Posts:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def thread_this(self,target_method,args):
        if self.bgthread.is_alive():
            return

        if target_method == "get":
            board = args['board']
            postno = args['postno']
            self.bgthread = threading.Thread(target=get_posts(board,postno))

        self.bgthread.start()

data = Posts()

#data.thread_this("get", {'board' : 'g','postno' : 50608527})