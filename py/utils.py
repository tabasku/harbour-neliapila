import html,re
#from collections import defaultdict
import datetime
import time
from html.parser import HTMLParser



class MLStripper(HTMLParser):
    def __init__(self):
        self.reset()
        self.strict = False
        self.convert_charrefs= True
        self.fed = []
    def handle_data(self, d):
        self.fed.append(d)
    def get_data(self):
        return ''.join(self.fed)

def epoch_to_readable(timestamp):
    FMT = '%m/%d/%Y (%a) %I:%M:%S'

    timestamp = time.strftime(FMT, time.localtime(timestamp))

    return timestamp


def strip_tags(html):
    s = MLStripper()
    s.feed(html)
    return s.get_data()

def parse_posts(list,post_replies=None):
    def comp(all, tagged):
        fixlist = []
        for val in all:
            if val not in tagged:
                fixlist.append(val)
        return fixlist

    def parse_com(com):
        com = html.unescape(com)
        #this thing still splits our urls..
        #com = re.sub(r'\<wbr\>', '',com)

        #Here are regex for matching every uri and only tagged
        tag = r'<a[^>]* href="([^"]*)"\>.*?\<\/a\>'
        ##uri = r'[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,6}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?'
        uri = r'\b((?:[a-z][\w\-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]' \
              r'|\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\)|[^\s`!()\[\]{}' \
              r';:".,<>?«»“”‘’]))'

        #Fetch em boy!
        rtag = re.findall(tag,com)
        ruri = re.findall(uri,com)

        #Then we compare if comment has urls without tags
        fixlist = comp(ruri,rtag)

        #If someone has been lazy, lets fix
        for untagged_url in fixlist:
            fixed_url = re.sub(re.compile(uri, re.MULTILINE),r'<a href="\1">\1</a>',str(untagged_url))
            if "boards.4chan" not in untagged_url:
                com = com.replace(untagged_url, fixed_url)

        #Make greentext green
        com = re.sub(r'\<span class=\"quote\"\>\>(.*?)\<\/span\>', r'<font color="#32CD32">>\1</font>',com)

        return com

    for post in list:
        if 'sub' in post and 'com' in post:
            post['com'] = parse_com("<b>"+post['sub']+"</b><br>"+post['com'])
            #print(post['com'])
        elif 'com' in post:
            post['com'] = parse_com(post['com'])
        else:
            post['com'] = ""
        #parser.feed(post['com'])

        if 'filedeleted' in post:
            post['thumbUrl'] ="https://s.4cdn.org/image/filedeleted.gif"

        if 'replies' in post:
            post['replies_count'] = post['replies']

        if post_replies:

                if str(post['no']) in post_replies:
                    replies = post_replies[str(post['no'])]
                    post['replies'] = len(replies)
                    post['repliesList'] = str(replies)

        #FMT = '%m/%d/%Y (%a) %I:%M:%S'

        #post['now'] = time.strftime(FMT, time.localtime(post['time']))

        post['now'] = epoch_to_readable(post['time'])

        post['pin'] = 0
        post['threadDead'] = False
        post['threadArchived'] = False
        post['postCount'] = 0
        post['board'] = ''

    return list

def collect_replies(com):
    quotelink = r'<a[^>]* href="#p([^"]*)" class="quotelink">\>.*?\<\/a\>'
    com = html.unescape(com)
    replies = re.findall(quotelink,com)
    return replies
