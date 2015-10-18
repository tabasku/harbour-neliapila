#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

import urllib.request

def getdirs (dir):
    dirs = []
    if os.path.abspath(dir) != os.getenv('HOME'):
        dirs.append("..")
    dirs = dirs + next(os.walk(dir))[1]
    return dirs

def save (dir, name, url):
    with urllib.request.urlopen(url) as res:
        if res.getcode() == 200:
            f = open(os.path.abspath(dir) + "/" + name, 'wb')
            f.write(res.read())
            f.close()

