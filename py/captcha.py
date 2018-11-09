#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pyotherside
import mimetypes
import os.path
import re
import base64
#import thread
import time
import warnings
import sys
import inspect

sys.path.append('./lib')
cmd_subfolder = os.path.realpath(os.path.abspath(os.path.join(os.path.split(inspect.getfile( inspect.currentframe() ))[0],"lib")))
if cmd_subfolder not in sys.path:
    sys.path.insert(0, cmd_subfolder)

import requests
from bs4 import BeautifulSoup



sitekey = "6Ldp2bsSAAAAAAJ5uyx_lx34lJeEpTLVkP5k04qc"

captcha2_url = "https://www.google.com/recaptcha/api/fallback?k=" + sitekey
captcha2_payload_url = "https://www.google.com/recaptcha/api2/payload"
captcha2_image_base_url = ""
site_ref = "https://boards.4chan.org/"
user_agent = 'Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0'

captcha2_challenge_text = None # "Select all images with ducks."
captcha2_challenge_id = None

captcha2_image = "" # Binary image

captcha2_solution = None # Array of integers associated to the captcha checkboxes, usually 0-8
captcha2_response = None 

def get_challenge_text(soup):            
    try:
        captcha2_challenge_text = soup.find("div", {'class': 'rc-imageselect-desc-no-canonical'}).text
        return captcha2_challenge_text
    except:
        captcha2_challenge_text = soup.find("div", {'class': 'rc-imageselect-desc'}).text

def get_challenge_id(soup):    
    try:      
        captcha2_challenge_id = soup.find("div", {'class': 'fbc-imageselect-challenge'}).find('input')['value']
        return captcha2_challenge_id
    except Exception as err:
        print("Error: {} ".format(err))

def get_challenge_image(captcha2_challenge_id):

    try:
        # Get captcha image
        headers = {'Referer': captcha2_url, 'User-Agent': user_agent}
        r = requests.get(captcha2_payload_url + '?c=' + captcha2_challenge_id + '&k=' + sitekey, headers=headers)
        #captcha2_image = r.content

        # encode imagedata so it can be loaded from QML
        captcha2_image = ("data:" + r.headers['Content-Type'] + ";" + "base64," + str(base64.b64encode(r.content).decode("utf-8")))
        return captcha2_image
    except Exception as err:
        print("Error: {} ".format(err))

def get_challenge():
    try:
        headers = {'Referer': site_ref, 'User-Agent': user_agent}
        r = requests.get(captcha2_url, headers=headers)
        
        r.raise_for_status()

        html_content = r.content
        soup = BeautifulSoup(html_content, 'html.parser')
        
        try:
            captcha2_challenge_text = soup.find("div", {'class': 'rc-imageselect-desc-no-canonical'}).text
        except:
            captcha2_challenge_text = soup.find("div", {'class': 'rc-imageselect-desc'}).text
            
        captcha2_challenge_id = soup.find("div", {'class': 'fbc-imageselect-challenge'}).find('input')['value']
        
        # Fetch captcha image
        headers = {'Referer': captcha2_url, 'User-Agent': user_agent}
        r = requests.get(captcha2_payload_url + '?c=' + captcha2_challenge_id + '&k=' + sitekey, headers=headers)

        # encode imagedata so it can be loaded from QML
        captcha2_image = ("data:" + r.headers['Content-Type'] + ";" + "base64," + str(base64.b64encode(r.content).decode("utf-8")))

        pyotherside.send('set_challenge', [captcha2_challenge_id,captcha2_challenge_text,captcha2_image])
          
    except Exception as err:
        print("Error: {} ".format(err))


def get_response(id,value,reply):

    #if isinstance(value, list):
    #    print("Not list!")
    #else:
    #    print("Yes, its list")
    #print(value)
    # Append checkbox integer values to response array
    try:
        #captcha2_solution = value
        captcha2_challenge_id = id
        captcha2_solution = []
        for i in str(value):
            captcha2_solution.append(str(int(i)))
        captcha2_solution.sort()

            #captcha2_solution.append(str(int(i) - 1))
    except ValueError as err:
        print("Value error: {}".format(err))
    except Exception as err:
        print("Error: {} ".format(err))
    
    try:
        
        headers = {'Referer': captcha2_url, 'User-Agent': user_agent}
        data={'c':captcha2_challenge_id, 'response':captcha2_solution}
        r = requests.post(captcha2_url, headers=headers, data=data)
        html_post = r.content

        pyotherside.send('debug', [html_post])
        soup = BeautifulSoup(html_post, 'html.parser')

        captcha2_response_soup = soup.find("div", {'class': 'fbc-verification-token'})
        if captcha2_response_soup is not None:
            print('I find')
            #captcha2_response = soup.find("div", {'class': 'fbc-verification-token'}).text
            captcha2_response = captcha2_response_soup.text

            if reply:
                pyotherside.send('reply_set_response', [captcha2_response])
            else:
                pyotherside.send('post_set_response', [captcha2_response])
        else:
            print('None found')
            pyotherside.send('failed_challenge','Failed, trying setting new captcha')
            # Try again
            captcha2_challenge_text = get_challenge_text(soup)
            captcha2_challenge_id = get_challenge_id(soup)
            captcha2_image = get_challenge_image(captcha2_challenge_id)
            pyotherside.send('set_challenge', [captcha2_challenge_id,captcha2_challenge_text,captcha2_image])

    except AttributeError as e: 
        print(e)

    except Exception as e: print(e)
    
    

    #try:
    #    print(soup)
    #    captcha2_response = soup.find("div", {'class': 'fbc-verification-token'}).text
    #    print(captcha2_response)
    #except AttributeError as e: print(e)
    #except Exception as e: print(e)
