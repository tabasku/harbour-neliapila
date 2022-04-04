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
        #com = html.unescape(com)
        #this thing still splits our urls..
        com = re.sub(r'&#039;', '\'',com)
        com = re.sub(r'&quot;', '\"',com)

        #Here are regex for matching every uri and only tagged
        tag = r'<a[^>]* href="([^"]*)".*\>.*?\<\/a\>'
        uri = r'(?i)\b((?:https?:(?:/{1,3}|[a-z0-9%])|[a-z0-9.\-]+[.](?:com|net|org|edu|gov|mil|aero|asia|biz|cat|coop|info|int|jobs|mobi|museum|name|post|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|games|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|link|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|moe|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|Ja|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|wiki|ws|ye|yt|yu|za|zm|zw)/)(?:[^\s()<>{}\|\[\]]+|\([^\s()]*?\([^\s()]+\)[^\s()]*?\)|\([^\s]+?\))+(?:\([^\s()]*?\([^\s()]+\)[^\s()]*?\)|\([^\s]+?\)|[^\s`!()\[\]\|\{};:\'\".,<><>\"\'\'])|(?:(?<!@)[a-z0-9]+(?:[.\-][a-z0-9]+)*[.](?:com|net|org|edu|gov|mil|aero|asia|biz|cat|coop|info|int|jobs|mobi|museum|name|post|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|games|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|link|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|moe|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|Ja|sk|sl|sm|sn|so|sr|ss|st|su|sv|sx|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|wiki|ws|ye|yt|yu|za|zm|zw)\b/?(?!@)))'
        ##uri = r'[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,6}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?'
        #uri = r'\b((?:[a-z][\w\-]+:(?:\/{1,3}|[a-z0-9%]\/)|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]' \
              #r'|\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\)|[^\s`!()\[\]{}' \
              #r';:".,<>?«»“”‘’]))'

        #Fetch em boy!
        rtag = re.findall(tag,com)
        ruri = set(re.findall(uri,com))

        #Then we compare if comment has urls without tags
        fixlist = comp(ruri,rtag)

        #If someone has been lazy, lets fix
        for untagged_url in fixlist:
            fixed_url = re.sub(re.compile(uri, re.MULTILINE),r'<a href="\1">\1</a>',str(untagged_url))
            if "boards.4chan" not in untagged_url:

                com = re.sub(r'(^|\s|[^\.a-zA-Z0-9_/?])' + re.escape(untagged_url) + r'($|\s|[^a-zA-Z0-9_/?])', r'\1' + fixed_url + r'\2', com)
        #Make greentext green
        com = re.sub(r'<span class="quote">&gt;(.*?)</span>', r'<font color="#32CD32">>\1</font>',com)
        #Make spoilers blue
        com = re.sub(r'<s>(.*?)</s>', r'<font color="#00CDFF">\1</font>',com)
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
