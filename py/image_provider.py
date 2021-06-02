# -*- coding: utf-8 -*-

import pyotherside
import urllib.request

import os
import random


def image_provider(image_id, requested_size):


    if requested_size == (-1, -1):
        requested_size = (300, 300)

    url = image_id
    response = urllib.request.urlopen(url)
    data = response.read()
    return bytearray(data), requested_size, pyotherside.format_data

#pyotherside.set_image_provider(image_provider)
