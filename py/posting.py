# -*- coding: utf-8 -*-
import mimetypes
import os.path
import re
import time
import warnings
import pyotherside
import sys
import inspect

sys.path.append('./lib')
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"lib")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import requests

board = None
threadno = None

bp = None 

user_agent = 'Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0'

def post(nickname="", comment="", subject="", file_attach="", captcha_response="", board="", challenge="",threadno=""):
    '''
    file_attach: (/path/to/file.ext) will be uploaded as "file" + extension
    '''
    cookies = None
    #file_attach = None
    try:
            
        if nickname == None:
            nickname = ""
        else:
            nickname = u''.join(nickname)
        
        # Read file / get mime type
        try:
            if file_attach:
                
                _, file_ext = os.path.splitext(file_attach)
                filename = "file" + file_ext
                content_type, _ = mimetypes.guess_type(filename)
                with open(file_attach, "rb") as f:
                    filedata = f.read()
                    
                if content_type is None:
                    raise TypeError("Could not detect mime type of file " + str(filename))
            else:
                filename = filedata = content_type = ""
        except Exception as e:
            print(e)
            raise

        #url = 'http://requestbin.fullcontact.com/1iwk8r21'
        url = "https://sys.4chan.org/" + board + "/post"

        values = {  
                    'MAX_FILE_SIZE' : (None, '4194304'),
                    'mode' : (None, 'regist'),
                    # 'pwd' : ('', 'tefF92alij2j'),
                    'name' : (None, str(nickname)),
                    'sub' : (None, str(subject)),
                    'resto' : (None, str(threadno)),
                    # 'email' : ('', ''),
                    'com' : (None, str(comment)),
                    't-response' : (None, str(captcha_response)),
                    't-challenge' : (None, str(challenge)),
                    'upfile' : (filename, filedata, content_type)
                }
        
        headers = { 'User-Agent' : user_agent }
        response = requests.post(url, headers=headers, files=values, cookies=cookies)
        
        # raise exception on error code
        response.raise_for_status()
        if re.search("is_error = \"true\"", response.text):
            perror = "Unknown Error."
            
            try:
                #perror = re.search(r"Error: ([A-Za-z.,]\w*\s*)+", response.text).group(0)
                perror = re.search(r"banned", response.text).group(0)
            except:
                if re.search("blocked due to abuse", response.text):
                    perror = "You are range banned ;_;"
            finally:
                if threadno:
                    pyotherside.send('reply_failed', [str(response.status_code),perror])
                else:
                    pyotherside.send('post_failed', [str(response.status_code),perror])
                return
        
        if response.status_code == 200:
            print("post succesful!")
            print(response.content)
            if threadno:
                replyno = re.search(r"thread\:(\d+),no\:(\d+)",str(response.content)).group(2)
                pyotherside.send('reply_successfull', [str(response.status_code),replyno])
            else:
                newthreadno = re.search(r"thread\:(\d+),no\:(\d+)",str(response.content)).group(2)
                pyotherside.send('post_successfull', [str(response.status_code),newthreadno])
        else:
            print("response.status_code: " + str(response.status_code))
            if threadno:
                pyotherside.send('reply_failed', [str(response.status_code)])
            else:
                pyotherside.send('post_failed', [str(response.status_code)])

        return response.status_code
    
    except Exception as e:
        print(e)
        raise
