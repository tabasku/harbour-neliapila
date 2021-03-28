# -*- coding: utf-8 -*

import threading
import storage
import pyotherside
import os,sys,inspect

cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"lib")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import basc_py4chan

def setting_default_board():
    database = storage.Storage()
    default = database.fetch_settings('default_board')
    print(default)

def favorites():
    database = storage.Storage()
    favorites = database.fetch_favorites()

    print(favorites)

def list():
    database = storage.Storage()
    boards = database.fetch_boards()
    board_list = []
    favorites_list = []

    for board in boards:

        attributes = {
                      'board': board['board'],
                      'title': board['title'],
                      #'pages': board['pages'],
                      'favorite': board['favorite'],
                      'default_board': board['default_board'],
                      'last_used': board['last_used']
                      }

        if board['favorite']:
            favorites_list.append(attributes)
        else:
            board_list.append(attributes)

    for board in reversed(favorites_list):
        board_list.insert(0, board)

    return board_list


def refresh(table_exists=True):
    database = storage.Storage()
    boards_data = basc_py4chan.get_all_boards()
    database.insert_boards(boards_data)
    get()

def get():
    database = storage.Storage()

    #if not database.table_exist("BOARDS"):
    #    refresh()

    if database.table_exist("BOARDS"):
        board_list = list()
        pyotherside.send('boards', board_list)

    else:
        refresh(False)


def toggle_favorite(board):
    database = storage.Storage()
    database.favorite(board)

    board_list = list()
    count = 0
    index = None

    for b in board_list:
        if b['board'] == board:
            index=count
        else:
            count += 1

    return index


def set_default(board):
    database = storage.Storage()
    database.set_default(board)


class Boards:
    def __init__(self):
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def thread_this(self,target_method):
        if self.bgthread.is_alive():
            return

        if target_method == "get":
            self.bgthread = threading.Thread(target=get)
        elif target_method == "refresh":
            self.bgthread = threading.Thread(target=refresh)


        self.bgthread.start()

    def refresh_boards(self):
        if self.bgthread.is_alive():
            return

        self.bgthread = threading.Thread(target=refresh)
        self.bgthread.start()

    def get_boards(self,target_method):
        if self.bgthread.is_alive():
            return

        self.bgthread = threading.Thread(target=target_method)
        self.bgthread.start()

    def set_favorite(self,board):
        if self.bgthread.is_alive():
            return

        self.bgthread = threading.Thread(target=toggle_favorite(board))
        self.bgthread.start()

#print(get())
data = Boards()
#data.thread_this('get')
#data.get_boards()
#default_board()
#favorites()
#data.refresh_boards()
#data.get_boards()
#data.set_favorite("b")
#data.refresh_boards()
#default_board()
#get()
#data.thread_this('refresh')
#set_default('b')
#refresh()