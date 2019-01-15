"""
Copyright (C) 2018-2019 Nguyen Long.
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"""

import os
import traceback
import json
import re
import sqlite3
import pprint
import pyotherside
import requests
from http.cookies import SimpleCookie

BASE_URL = 'https://wap.baidu.com/'
HARBOUR_APP_NAME = 'harbour-tbclient'
HOME = os.path.expanduser('~')
XDG_DATA_HOME = os.environ.get('XDG_DATA_HOME', os.path.join(HOME, '.local', 'share'))
XDG_CONFIG_HOME = os.environ.get('XDG_CONFIG_HOME', os.path.join(HOME, '.config'))
XDG_CACHE_HOME = os.path.join('XDG_CACHE_HOME', os.path.join(HOME, '.cache'))
COOKIE_PATH = os.path.join(XDG_DATA_HOME, HARBOUR_APP_NAME, HARBOUR_APP_NAME, '.QtWebKit', 'cookies.db')
CACHE_PATH = os.path.join(XDG_CACHE_HOME, HARBOUR_APP_NAME, HARBOUR_APP_NAME)

class Api:
    def __init__(self):
        self.sessionId = ''
        self.userId = 0

    def get_other_param(self, username):
        """
        Get BDUSS and uid
        """
        bduss = self.get_session_id_from_cookie()
        uid = self.get_user_id_from_username(username)
        if bduss and uid:
            return {
                "bduss": bduss,
                "uid": uid
            }
        else:
            return None


    def get_session_id_from_cookie(self):
        """
        Try get session Id from WebKit cookies DB
        """

        conn = sqlite3.connect(COOKIE_PATH)
        cursor = conn.cursor()
        params = ('.baidu.comBDUSS',)
        cursor.execute('SELECT * FROM cookies WHERE cookieId = ?', params)
        row = cursor.fetchone()
        if row is not None:
            cookie = SimpleCookie()
            cookie.load(row[1].decode('utf-8'))
            for cookie_name, morsel in cookie.items():
                if cookie_name == 'BDUSS':
                    return morsel.value    
    
    def get_user_id_from_username(self, username):
        """
        Get user_id from username
        """
        user_home_url = "http://tieba.baidu.com/home/main?un=%s" % (username, )
        try:
            r = requests.get(user_home_url, timeout = 10)
            user_info = r.text
            # "home_user_id" : 120127382,
            home_user_index = user_info.index("\"home_user_id\" : ") + len("\"home_user_id\" : ")
            home_user_right_part = user_info[home_user_index:]
            uid = home_user_right_part[:home_user_right_part.index(",")]
            return uid
        except:
            Utils.log(traceback.format_exc())
            utils.error('Could not login. Please try again.')




class Utils:
    def __init__(self):
        pass

    @staticmethod
    def log(str):
        """
        Print log to console
        """

        Utils.send('log', str)

    @staticmethod
    def error(str):
        """
        Send error string to QML to show on banner
        """

        Utils.send('error', str)

    @staticmethod
    def send(event, msg=None):
        """
        Send data to QML
        """

        pyotherside.send(event, msg)

api = Api()
utils = Utils()
