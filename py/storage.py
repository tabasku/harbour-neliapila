# -*- coding: utf-8 -*-
from os.path import expanduser,exists,isfile
from os import makedirs,remove
from savefile import save
import sqlite3 as lite
import re
import sys
import pyotherside


class Storage:
    def __init__(self):
        pass

    def get_thumb_dir(self):
        home = None
        if sys.platform is 'win32':
            home = expanduser("~")+"\\.Neliapila\\pinned_thumbs"
        else:
            home = expanduser("~")+"/.local/share/harbour-neliapila/pinned_thumbs"

        if not exists(home):
            makedirs(home)

        return home

    def get_dir(self):
        home = None
        if sys.platform is 'win32':
            home = expanduser("~")+"\\.Neliapila\\"
        else:
            home = expanduser("~")+"/.local/share/harbour-neliapila/"


        if not exists(home):
            makedirs(home)
        home += "neliapila.db"
        return home


    def dict_factory(cursor, row):
        d = {}
        for idx, col in enumerate(cursor.description):
            d[col[0].lower()] = row[idx]
        return d

    def db_commit(self, cmd, script=False):
        con = None
        home = self.get_dir()

        try:
            con = lite.connect(home)
            if(script):
                con.executescript(cmd)
            else:
                con.execute(cmd)

        except lite.Error as err:
            return("SQLite error {}:".format(err))
            pyotherside.send('DBERR',str(err.__dict__))
            sys.exit(1)

        finally:

            if con:
                con.commit()
                con.close()

    def db_query(self,query,fetch,get_dict=False):
        con = None
        data = None
        home = self.get_dir()

        try:
            con = lite.connect(home)
            if get_dict:
                #con.row_factory = self.dict_factory
                con.row_factory = lite.Row
            cur = con.cursor()
            cur.execute(query)

            if fetch == "one":
                data = cur.fetchone()
            elif fetch == "all":
                data = cur.fetchall()

        except lite.Error as err:
            print("SQLite Error {}:".format(err))
            sys.exit(1)

        finally:

            if con:
                con.close()
                return data

    def table_exist(self,table):
        query = "SELECT name FROM sqlite_master WHERE type='table';"
        tables = self.db_query(query,"all")
        t_exists = False

        for t in tables:
            if t[0] == table:
                t_exists = True

        return t_exists

    def get_default(self):

        if self.table_exist("BOARDS"):
            query = "select BOARD from BOARDS WHERE DEFAULT_BOARD = 1;"
            default_board = self.db_query(query,"one")
            if default_board is None:
                default_board=None
            else:
                default_board = default_board[0]
        else:
            default_board=None
         #   default_board="g"

        return default_board

    def get_pages(self,board):

        if self.table_exist("BOARDS"):
            query = "select PAGES from BOARDS WHERE BOARD = '{board}';".format(board=board)
            pages = self.db_query(query,"one")
            pages = pages[0]
        else:
            pages = 10

        return pages

    def fetch_favorites(self):
        query = "select BOARD from BOARDS WHERE FAVORITE = 1;"
        favorites = self.db_query(query,"all")
        favorite_list = []
        for fav in favorites:
            favorite_list.append(fav[0])
        return favorite_list

    def fetch_boards_old(self):
        query = "select BOARD,TITLE,FAVORITE,DEFAULT_BOARD from BOARDS;"
        boards = self.db_query(query,"all")
        return boards

    def fetch_boards(self):
        query = "select BOARD,TITLE,PAGES,FAVORITE,DEFAULT_BOARD,LAST_USED from BOARDS ORDER BY BOARD ASC;"
        boards = self.db_query(query,"all",True)
        return boards

    def create_boards_table(self):
        cmd = '''CREATE TABLE IF NOT EXISTS  BOARDS
        (BOARD           TEXT PRIMARY KEY    NOT NULL,
        TITLE            TEXT     NOT NULL,
        PAGES            INT        NULL,
        FAVORITE         INT     DEFAULT 0,
        DEFAULT_BOARD           INT     DEFAULT 0,
        LAST_USED         INT     DEFAULT 0);'''
        self.db_commit(cmd)

    def default_settings(self):
        defaults = ["INSERT OR IGNORE INTO SETTINGS(SETTING,VALUE) VALUES('default_board','g');",
                    "INSERT OR IGNORE INTO SETTINGS(SETTING,VALUE) VALUES('first_run','yes');"]

        for cmd in defaults:
            self.db_commit(cmd)


    def create_settings_table(self):
        cmd = '''CREATE TABLE IF NOT EXISTS  SETTINGS
        (SETTING           TEXT PRIMARY KEY    NOT NULL,
        VALUE            TEXT     NOT NULL);'''
        self.db_commit(cmd)
        self.default_settings()

    def delete_tables(self):

        drop_defaults = ["DROP TABLE IF EXISTS PINNED;",
                    "DROP TABLE IF EXISTS BOARDS;"]

        for cmd in drop_defaults:
            self.db_commit(cmd)

        pyotherside.send('legacy_db_empty')

    def fetch_settings(self,value=None):

        #Make sure settings table exists before query
        if not self.table_exist("SETTINGS"):
            self.create_settings_table()

        if value is None:
            query = 'SELECT SETTING,VALUE FROM SETTINGS;'
            settings = self.db_query(query,"all")
        else:
            query = 'SELECT VALUE FROM SETTINGS WHERE SETTING = "{}";'.format(value)
            settings = self.db_query(query,"one")[0]

        return settings

    def insert_boards(self,boards_data):

        if not self.table_exist('BOARDS'):
            self.create_boards_table()
            table_exists_already = False
        else:
            table_exists_already = True

        cmd = ''

        for board in boards_data:
            if table_exists_already:
                cmd += '''
                INSERT OR REPLACE INTO BOARDS (BOARD,TITLE,PAGES,FAVORITE,DEFAULT_BOARD,LAST_USED)
                VALUES (
                "{board}",
                "{title}",
                "{pages}",
                (SELECT FAVORITE FROM BOARDS WHERE BOARD = "{board}"),
                (SELECT DEFAULT_BOARD FROM BOARDS WHERE BOARD = "{board}"),
                (SELECT LAST_USED FROM BOARDS WHERE BOARD = "{board}")
                );
                '''.format(board=board.name, title=board.title,pages=board.page_count)
            else:
                cmd += '''
                INSERT OR REPLACE INTO BOARDS (BOARD,TITLE,PAGES)
                VALUES (
                "{board}",
                "{title}",
                "{pages}"
                );
                '''.format(board=board.name, title=board.title,pages=board.page_count)

        self.db_commit(cmd,True)

    def favorite(self,board):

        query = 'select BOARD,FAVORITE from BOARDS WHERE BOARD = "{board}";'.format(board=board)
        board_found = self.db_query(query,"one")[1]

        if board_found:
            cmd = 'UPDATE BOARDS SET FAVORITE="{favorite}" WHERE BOARD ="{board}";'.format(favorite=0, board=board)
        else:
            cmd = 'UPDATE BOARDS SET FAVORITE="{favorite}" WHERE BOARD ="{board}";'.format(favorite=1, board=board)

        self.db_commit(cmd)
        #print(self.get_favorites())

    def set_default(self,board):

        self.db_commit('UPDATE BOARDS SET DEFAULT_BOARD="0";')

        cmd = 'UPDATE BOARDS SET DEFAULT_BOARD="1" WHERE BOARD ="{board}";'.format(board=board)

        self.db_commit(cmd)

    def create_pinned_table(self):
        cmd = '''CREATE TABLE IF NOT EXISTS  PINNED
        (POSTNO           INT PRIMARY KEY    NOT NULL,
        BOARD            TEXT     NOT NULL,
        SHORT_COM        TXT         NULL,
        THUMB_URL             TXT         NOT NULL,
        TIME_ADDED      INT         NOT NULL,
        TIME_READ       INT         NULL,
        TIME_CREATED      INT         NOT NULL,
        REPLIES_COUNT      INT         NOT NULL);'''
        self.db_commit(cmd)

    def add_pin(self,post_no,board,short_com,thumb_url,time,time_created,replies_count):

        if not self.table_exist('PINNED'):
            self.create_pinned_table()

        if thumb_url is not None:
            file_name = re.findall(r'\d+s.jpg',thumb_url)[0]
            thumb_dir = self.get_thumb_dir()
            save(thumb_dir, file_name, thumb_url)
        else:
            thumb_url="none"

        cmd = '''INSERT OR IGNORE INTO PINNED(POSTNO,BOARD,SHORT_COM,THUMB_URL,TIME_ADDED,TIME_READ,TIME_CREATED,REPLIES_COUNT) VALUES''' \
              '''("{post_no}","{board}","{short_com}","{thumb_url}","{time_added}","{time_read}","{time_created}","{replies_count}");'''\
            .format(post_no=post_no,board=board,short_com=short_com,thumb_url=thumb_url,time_added=time,time_read=time,time_created=time_created,replies_count=replies_count)

        self.db_commit(cmd)

        dir = self.get_thumb_dir()



    def update_pin(self,post_no,board,time,replies_count):

        if not self.table_exist('PINNED'):
            self.create_pinned_table()

        cmd = '''UPDATE PINNED SET TIME_READ = "{time_read}",
         REPLIES_COUNT = "{replies_count}" WHERE POSTNO = "{post_no}" AND BOARD = "{board}";
         '''.format(post_no=post_no,board=board,time_read=time,replies_count=replies_count)

        self.db_commit(cmd)

    def get_pins(self,post_no=None,board=None):

        if not self.table_exist('PINNED'):
            self.create_pinned_table()

        if post_no == None and board == None:
            query = 'SELECT * FROM PINNED;'
            pins = self.db_query(query,"all",True)
        elif post_no and board == None:
            query = 'SELECT POSTNO,BOARD FROM PINNED WHERE POSTNO = "{}";'.format(post_no)
            pins = self.db_query(query,"all",True)
        elif board and post_no == None:
            query = 'SELECT POSTNO FROM PINNED WHERE BOARD = "{}";'.format(board)
            pins = self.db_query(query,"all",True)

        return pins

    def delete_pins(self,post_no=None,board=None):

        if not self.table_exist('PINNED'):
            self.create_pinned_table()

        cmd = None
        query = None

        def remove_thumbnail(pin_thumbs):
            dir = self.get_thumb_dir()
            for thumb in pin_thumbs:

                file_name = re.findall(r'\d+s.jpg',thumb['THUMB_URL'])
                if len(file_name) != 0:
                    file = dir + '/' + file_name[0]
                    if isfile(file):
                        remove(file)
                        #print(file)

        if post_no is None:
            query = 'SELECT THUMB_URL FROM PINNED;'
            pin_thumbs = self.db_query(query,"all",True)
            remove_thumbnail(pin_thumbs)
            cmd = 'DELETE FROM PINNED;'
        else:
            query = 'SELECT THUMB_URL FROM PINNED WHERE POSTNO="{}";'.format(post_no)
            pin_thumbs = self.db_query(query,"all",True)
            remove_thumbnail(pin_thumbs)
            cmd = 'DELETE FROM PINNED WHERE POSTNO = "{post_no}" AND BOARD = "{board}";'.format(post_no=post_no,board=board)

        self.db_commit(cmd)

legacy_db = Storage()
