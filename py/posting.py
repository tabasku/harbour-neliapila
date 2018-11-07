#!/usr/bin/env python3
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

def post(nickname="", comment="", subject="", file_attach="", captcha_response=""):
    '''
    subject: not implemented
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
                
                # extract file path from ranger file and re-assign it
                #with open(file_attach, "r") as f:
                #    file_attach = f.read()
                
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

        
        #url = "https://sys.4chan.org/" + board + "/post"
        #url = 'http://httpbin.org/status/404'
        #url = "http://localhost/" + board + "/post"
        #url = 'http://httpbin.org/post'
        url = 'http://requestbin.fullcontact.com/12xdx0m1'

        print(subject)


        values = {  
                    'MAX_FILE_SIZE' : (None, '4194304'),
                    'mode' : (None, 'regist'),
                    # 'pwd' : ('', 'tefF92alij2j'),
                    'name' : (None, str(nickname)),
                    'sub' : (None, str(subject)),
                    'resto' : (None, str(threadno)),
                    # 'email' : ('', ''),
                    'com' : (None, str(comment)),
                    'g-recaptcha-response' : (None, captcha_response),
                    'upfile' : (filename, filedata, content_type)
                }

        #print(values)
        #print(values['sub'])

        
        headers = { 'User-Agent' : user_agent }

        response = requests.post(url, headers=headers, files=values, cookies=cookies)
        
        # raise exception on error code
        response.raise_for_status()
        if re.search("is_error = \"true\"", response.text):
            perror = "Unknown Error."
            
            try:
                perror = re.search(r"Error: ([A-Za-z.,]\w*\s*)+", response.text).group(0)
            except:
                if re.search("blocked due to abuse", response.text):
                    perror = "You are range banned ;_;"
            finally:
                pyotherside.send('post_failed', [str(response.status_code)])
        
        if response.status_code == 200:
            print("post succesful!")
            pyotherside.send('post_successfull', [str(response.status_code)])
        else:
            print("response.status_code: " + str(response.status_code))
            pyotherside.send('post_failed', [str(response.status_code)])

        
        
        return response.status_code
    
    except Exception as e:
        print(e)
        raise
