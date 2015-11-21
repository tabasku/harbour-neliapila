# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-neliapila

CONFIG += sailfishapp

SOURCES += src/harbour-neliapila.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-neliapila.changes.in \
    rpm/harbour-neliapila.spec \
    rpm/harbour-neliapila.yaml \
    translations/*.ts \
    harbour-neliapila.desktop \
    qml/pages/AboutPage.qml \
    qml/pages/AbstractPage.qml \
    qml/pages/ImageViewPage.qml \
    qml/pages/NaviPage.qml \
    qml/pages/PostsPage.qml \
    qml/pages/SaveFilePage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/TextPage.qml \
    qml/pages/ThreadsPage.qml \
    qml/img/dots.png \
    qml/img/image_not_found.png \
    qml/img/neliapila.png \
    qml/js/stripper.js \
    qml/js/utils.js \
    qml/py/lib/basc_py4chan/__init__.py \
    qml/py/lib/basc_py4chan/board.py \
    qml/py/lib/basc_py4chan/post.py \
    qml/py/lib/basc_py4chan/thread.py \
    qml/py/lib/basc_py4chan/url.py \
    qml/py/lib/basc_py4chan/util.py \
    qml/py/lib/requests/packages/chardet/__init__.py \
    qml/py/lib/requests/packages/chardet/big5freq.py \
    qml/py/lib/requests/packages/chardet/big5prober.py \
    qml/py/lib/requests/packages/chardet/chardetect.py \
    qml/py/lib/requests/packages/chardet/chardistribution.py \
    qml/py/lib/requests/packages/chardet/charsetgroupprober.py \
    qml/py/lib/requests/packages/chardet/charsetprober.py \
    qml/py/lib/requests/packages/chardet/codingstatemachine.py \
    qml/py/lib/requests/packages/chardet/compat.py \
    qml/py/lib/requests/packages/chardet/constants.py \
    qml/py/lib/requests/packages/chardet/cp949prober.py \
    qml/py/lib/requests/packages/chardet/escprober.py \
    qml/py/lib/requests/packages/chardet/escsm.py \
    qml/py/lib/requests/packages/chardet/eucjpprober.py \
    qml/py/lib/requests/packages/chardet/euckrfreq.py \
    qml/py/lib/requests/packages/chardet/euckrprober.py \
    qml/py/lib/requests/packages/chardet/euctwfreq.py \
    qml/py/lib/requests/packages/chardet/euctwprober.py \
    qml/py/lib/requests/packages/chardet/gb2312freq.py \
    qml/py/lib/requests/packages/chardet/gb2312prober.py \
    qml/py/lib/requests/packages/chardet/hebrewprober.py \
    qml/py/lib/requests/packages/chardet/jisfreq.py \
    qml/py/lib/requests/packages/chardet/jpcntx.py \
    qml/py/lib/requests/packages/chardet/langbulgarianmodel.py \
    qml/py/lib/requests/packages/chardet/langcyrillicmodel.py \
    qml/py/lib/requests/packages/chardet/langgreekmodel.py \
    qml/py/lib/requests/packages/chardet/langhebrewmodel.py \
    qml/py/lib/requests/packages/chardet/langhungarianmodel.py \
    qml/py/lib/requests/packages/chardet/langthaimodel.py \
    qml/py/lib/requests/packages/chardet/latin1prober.py \
    qml/py/lib/requests/packages/chardet/mbcharsetprober.py \
    qml/py/lib/requests/packages/chardet/mbcsgroupprober.py \
    qml/py/lib/requests/packages/chardet/mbcssm.py \
    qml/py/lib/requests/packages/chardet/sbcharsetprober.py \
    qml/py/lib/requests/packages/chardet/sbcsgroupprober.py \
    qml/py/lib/requests/packages/chardet/sjisprober.py \
    qml/py/lib/requests/packages/chardet/universaldetector.py \
    qml/py/lib/requests/packages/chardet/utf8prober.py \
    qml/py/lib/requests/packages/urllib3/contrib/ntlmpool.py \
    qml/py/lib/requests/packages/urllib3/contrib/pyopenssl.py \
    qml/py/lib/requests/packages/urllib3/packages/ssl_match_hostname/__init__.py \
    qml/py/lib/requests/packages/urllib3/packages/ssl_match_hostname/_implementation.py \
    qml/py/lib/requests/packages/urllib3/packages/__init__.py \
    qml/py/lib/requests/packages/urllib3/packages/ordered_dict.py \
    qml/py/lib/requests/packages/urllib3/packages/six.py \
    qml/py/lib/requests/packages/urllib3/util/__init__.py \
    qml/py/lib/requests/packages/urllib3/util/connection.py \
    qml/py/lib/requests/packages/urllib3/util/request.py \
    qml/py/lib/requests/packages/urllib3/util/response.py \
    qml/py/lib/requests/packages/urllib3/util/retry.py \
    qml/py/lib/requests/packages/urllib3/util/ssl_.py \
    qml/py/lib/requests/packages/urllib3/util/timeout.py \
    qml/py/lib/requests/packages/urllib3/util/url.py \
    qml/py/lib/requests/packages/urllib3/__init__.py \
    qml/py/lib/requests/packages/urllib3/_collections.py \
    qml/py/lib/requests/packages/urllib3/connection.py \
    qml/py/lib/requests/packages/urllib3/connectionpool.py \
    qml/py/lib/requests/packages/urllib3/exceptions.py \
    qml/py/lib/requests/packages/urllib3/fields.py \
    qml/py/lib/requests/packages/urllib3/filepost.py \
    qml/py/lib/requests/packages/urllib3/poolmanager.py \
    qml/py/lib/requests/packages/urllib3/request.py \
    qml/py/lib/requests/packages/urllib3/response.py \
    qml/py/lib/requests/packages/__init__.py \
    qml/py/lib/requests/__init__.py \
    qml/py/lib/requests/adapters.py \
    qml/py/lib/requests/api.py \
    qml/py/lib/requests/auth.py \
    qml/py/lib/requests/certs.py \
    qml/py/lib/requests/compat.py \
    qml/py/lib/requests/cookies.py \
    qml/py/lib/requests/exceptions.py \
    qml/py/lib/requests/hooks.py \
    qml/py/lib/requests/models.py \
    qml/py/lib/requests/sessions.py \
    qml/py/lib/requests/status_codes.py \
    qml/py/lib/requests/structures.py \
    qml/py/lib/requests/utils.py \
    qml/py/boards.py \
    qml/py/getdata.py \
    qml/py/image_provider.py \
    qml/py/pinned.py \
    qml/py/posts.py \
    qml/py/pyotherside.py \
    qml/py/savefile.py \
    qml/py/storage.py \
    qml/py/threads.py \
    qml/py/utils.py \
    qml/items/InfoBanner.qml \
    qml/items/OpenLinkDialog.qml \
    qml/items/PageDialog.qml \
    qml/items/PostItem.qml \
    qml/items/PostsPageFooter.qml \
    qml/items/ThreadPageFooter.qml \
    qml/harbour-neliapila.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-neliapila-de.ts

