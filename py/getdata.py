#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib.request
import sys

def req(url):
    try:
        r = urllib.request.urlopen(url).read().decode('utf8')
        return r
    except urllib.error.URLError as err:
        print("URL Error {}:".format(err))
        return err
        #sys.exit(1)
    except urllib.error.HTTPError as err:
        if err.code == 404:
            print("HTTP 404 Error {}:".format(err))
        else:
            print("HTTP Error {}:".format(err))

        return err.code
        #sys.exit(1)




