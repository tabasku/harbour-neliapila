__author__ = 'joni'
# -*- coding: utf-8 -*

from getdata import req
import json
import threading
import time
#import storage
import pyotherside
import utils
import os,sys,inspect
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"lib")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import basc_py4chan


def strip_posts(post_list,posts_to_show):
    stripped_post_list = []
    for post in post_list:
        if post in posts_to_show:
            stripped_post_list.append(post)

    return stripped_post_list


def get_posts(board_id,postno):

    board = basc_py4chan.Board(board_id)
    thread = board.get_thread(postno)

    post_list = []
    post_replies = {}

    if thread != None:
        all_posts = thread.all_posts

        for post in all_posts:

            post_values = {}

            post_values['no'] = post.post_id

            if post.post_id == postno :
                post_values['replies'] = len(thread.posts)
                post_values['sticky'] = int(thread.sticky)
            else:
                post_values['replies'] = 0
                post_values['sticky'] = 0

            post_values['closed'] = int(thread.closed)
            post_values['name'] = post.name
            post_values['time'] = post.timestamp
            post_values['semantic_url'] = post.semantic_url
            post_values['images'] = int(post.has_file)
            post_values['has_file'] = int(post.has_file)

            if post.has_file:
                post_values['ext'] = post.file_extension
                post_values['thumbUrl'] = post.thumbnail_url
                post_values['imgUrl'] = post.file_url
                post_values['filename'] = post.filename
                post_values['file_deleted'] = int(post.file_deleted)

            if post.comment:
                replies = utils.collect_replies(post.comment)
                if replies:
                    for reply in replies:
                        if reply not in post_replies:
                            post_replies[reply]=[]
                        post_replies[reply].append(post.post_id)

            if post.subject and post.comment:
                post_values['com'] = '<b>{}</b><br>'.format(post.subject) + post.comment
            elif not post.subject and post.comment:
                post_values['com'] = post.comment
            elif post.subject and not post.comment:
                post_values['com'] = '<b>{}</b>'.format(post.subject)

            post_list.append(post_values)

        post_list  = utils.parse_posts(post_list,post_replies)
        pyotherside.send('posts', post_list)
    else:
        pyotherside.send('posts_status', post_list)

def get_new_posts_count(board_id,postno,replies_count):

    board = basc_py4chan.Board(board_id)
    thread = board.get_thread(postno)

    if thread is None:
        return None
    else:
        updated_replies_count = len(thread.posts)

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

#data.thread_this("get", {'board' : 'g','postno' : 50769967})
#get_new_posts_count('adv',16329228,10)
