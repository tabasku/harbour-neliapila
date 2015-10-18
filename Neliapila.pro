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
TARGET = Neliapila

CONFIG += sailfishapp

SOURCES += src/Neliapila.cpp

OTHER_FILES += qml/Neliapila.qml \
    qml/cover/CoverPage.qml \
    rpm/Neliapila.changes.in \
    rpm/Neliapila.spec \
    rpm/Neliapila.yaml \
    translations/*.ts \
    Neliapila.desktop \
    qtlogo.png \
    qml/pages/PostsPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AbstractPage.qml \
    qml/pages/AboutPage.qml \
    WebmView.qml \
    qml/items/ThreadPageFooter.qml \
    qml/items/InfoBanner.qml \
    qml/items/PostsPageFooter.qml \
    qml/pages/ThreadsPage.qml \
    qml/pages/SaveFilePage.qml \
    qml/py/savefile.py \
    qml/pages/ImageViewPage.qml \
    qml/items/OpenLinkDialog.qml \
    qml/py/requests/cacert.pem \
    qml/py/requests/adapters.py \
    qml/py/requests/api.py \
    qml/py/requests/auth.py \
    qml/py/requests/certs.py \
    qml/py/requests/compat.py \
    qml/py/requests/cookies.py \
    qml/py/requests/exceptions.py \
    qml/py/requests/hooks.py \
    qml/py/requests/models.py \
    qml/py/requests/sessions.py \
    qml/py/requests/status_codes.py \
    qml/py/requests/structures.py \
    qml/py/requests/utils.py \
    qml/py/requests/packages/urllib3/__init__.py \
    qml/py/requests/packages/urllib3/_collections.py \
    qml/py/requests/packages/urllib3/connection.py \
    qml/py/requests/packages/urllib3/connectionpool.py \
    qml/py/requests/packages/urllib3/exceptions.py \
    qml/py/requests/packages/urllib3/fields.py \
    qml/py/requests/packages/urllib3/filepost.py \
    qml/py/requests/packages/urllib3/poolmanager.py \
    qml/py/requests/packages/urllib3/request.py \
    qml/py/requests/packages/urllib3/response.py \
    qml/py/requests/packages/urllib3/util.py \
    qml/py/requests/packages/chardet/__init__.py \
    qml/py/requests/packages/chardet/big5freq.py \
    qml/py/requests/packages/chardet/big5prober.py \
    qml/py/requests/packages/chardet/chardetect.py \
    qml/py/requests/packages/chardet/chardistribution.py \
    qml/py/requests/packages/chardet/charsetgroupprober.py \
    qml/py/requests/packages/chardet/charsetprober.py \
    qml/py/requests/packages/chardet/codingstatemachine.py \
    qml/py/requests/packages/chardet/compat.py \
    qml/py/requests/packages/chardet/constants.py \
    qml/py/requests/packages/chardet/cp949prober.py \
    qml/py/requests/packages/chardet/escprober.py \
    qml/py/requests/packages/chardet/escsm.py \
    qml/py/requests/packages/chardet/eucjpprober.py \
    qml/py/requests/packages/chardet/euckrfreq.py \
    qml/py/requests/packages/chardet/euckrprober.py \
    qml/py/requests/packages/chardet/euctwfreq.py \
    qml/py/requests/packages/chardet/euctwprober.py \
    qml/py/requests/packages/chardet/gb2312freq.py \
    qml/py/requests/packages/chardet/gb2312prober.py \
    qml/py/requests/packages/chardet/hebrewprober.py \
    qml/py/requests/packages/chardet/jisfreq.py \
    qml/py/requests/packages/chardet/jpcntx.py \
    qml/py/requests/packages/chardet/langbulgarianmodel.py \
    qml/py/requests/packages/chardet/langcyrillicmodel.py \
    qml/py/requests/packages/chardet/langgreekmodel.py \
    qml/py/requests/packages/chardet/langhebrewmodel.py \
    qml/py/requests/packages/chardet/langhungarianmodel.py \
    qml/py/requests/packages/chardet/langthaimodel.py \
    qml/py/requests/packages/chardet/latin1prober.py \
    qml/py/requests/packages/chardet/mbcharsetprober.py \
    qml/py/requests/packages/chardet/mbcsgroupprober.py \
    qml/py/requests/packages/chardet/mbcssm.py \
    qml/py/requests/packages/chardet/sbcharsetprober.py \
    qml/py/requests/packages/chardet/sbcsgroupprober.py \
    qml/py/requests/packages/chardet/sjisprober.py \
    qml/py/requests/packages/chardet/universaldetector.py \
    qml/py/requests/packages/chardet/utf8prober.py \
    qml/py/requests/packages/urllib3/contrib/__init__.py \
    qml/py/requests/packages/urllib3/contrib/ntlmpool.py \
    qml/py/requests/packages/urllib3/contrib/pyopenssl.py \
    qml/py/requests/packages/urllib3/packages/__init__.py \
    qml/py/requests/packages/urllib3/packages/ordered_dict.py \
    qml/py/requests/packages/urllib3/packages/six.py \
    qml/py/requests/packages/urllib3/packages/ssl_match_hostname/__init__.py \
    qml/py/requests/packages/urllib3/packages/ssl_match_hostname/_implementation.py \
    qml/py/libs/requests/cacert.pem \
    qml/py/libs/requests/adapters.py \
    qml/py/libs/requests/api.py \
    qml/py/libs/requests/auth.py \
    qml/py/libs/requests/certs.py \
    qml/py/libs/requests/compat.py \
    qml/py/libs/requests/cookies.py \
    qml/py/libs/requests/exceptions.py \
    qml/py/libs/requests/hooks.py \
    qml/py/libs/requests/models.py \
    qml/py/libs/requests/sessions.py \
    qml/py/libs/requests/status_codes.py \
    qml/py/libs/requests/structures.py \
    qml/py/libs/requests/utils.py \
    qml/py/libs/requests/packages/chardet/__init__.py \
    qml/py/libs/requests/packages/chardet/big5freq.py \
    qml/py/libs/requests/packages/chardet/big5prober.py \
    qml/py/libs/requests/packages/chardet/chardetect.py \
    qml/py/libs/requests/packages/chardet/chardistribution.py \
    qml/py/libs/requests/packages/chardet/charsetgroupprober.py \
    qml/py/libs/requests/packages/chardet/charsetprober.py \
    qml/py/libs/requests/packages/chardet/codingstatemachine.py \
    qml/py/libs/requests/packages/chardet/compat.py \
    qml/py/libs/requests/packages/chardet/constants.py \
    qml/py/libs/requests/packages/chardet/cp949prober.py \
    qml/py/libs/requests/packages/chardet/escprober.py \
    qml/py/libs/requests/packages/chardet/escsm.py \
    qml/py/libs/requests/packages/chardet/eucjpprober.py \
    qml/py/libs/requests/packages/chardet/euckrfreq.py \
    qml/py/libs/requests/packages/chardet/euckrprober.py \
    qml/py/libs/requests/packages/chardet/euctwfreq.py \
    qml/py/libs/requests/packages/chardet/euctwprober.py \
    qml/py/libs/requests/packages/chardet/gb2312freq.py \
    qml/py/libs/requests/packages/chardet/gb2312prober.py \
    qml/py/libs/requests/packages/chardet/hebrewprober.py \
    qml/py/libs/requests/packages/chardet/jisfreq.py \
    qml/py/libs/requests/packages/chardet/jpcntx.py \
    qml/py/libs/requests/packages/chardet/langbulgarianmodel.py \
    qml/py/libs/requests/packages/chardet/langcyrillicmodel.py \
    qml/py/libs/requests/packages/chardet/langgreekmodel.py \
    qml/py/libs/requests/packages/chardet/langhebrewmodel.py \
    qml/py/libs/requests/packages/chardet/langhungarianmodel.py \
    qml/py/libs/requests/packages/chardet/langthaimodel.py \
    qml/py/libs/requests/packages/chardet/latin1prober.py \
    qml/py/libs/requests/packages/chardet/mbcharsetprober.py \
    qml/py/libs/requests/packages/chardet/mbcsgroupprober.py \
    qml/py/libs/requests/packages/chardet/mbcssm.py \
    qml/py/libs/requests/packages/chardet/sbcharsetprober.py \
    qml/py/libs/requests/packages/chardet/sbcsgroupprober.py \
    qml/py/libs/requests/packages/chardet/sjisprober.py \
    qml/py/libs/requests/packages/chardet/universaldetector.py \
    qml/py/libs/requests/packages/chardet/utf8prober.py \
    qml/py/libs/requests/packages/urllib3/contrib/__init__.py \
    qml/py/libs/requests/packages/urllib3/contrib/ntlmpool.py \
    qml/py/libs/requests/packages/urllib3/contrib/pyopenssl.py \
    qml/py/libs/requests/packages/urllib3/packages/__init__.py \
    qml/py/libs/requests/packages/urllib3/packages/ordered_dict.py \
    qml/py/libs/requests/packages/urllib3/packages/six.py \
    qml/py/libs/requests/packages/urllib3/packages/ssl_match_hostname/__init__.py \
    qml/py/libs/requests/packages/urllib3/packages/ssl_match_hostname/_implementation.py \
    qml/py/libs/requests/packages/__init__.py \
    qml/py/getdata.py \
    qml/py/storage.py \
    qml/py/boards.py \
    qml/py/threads.py \
    qml/py/utils.py \
    qml/py/posts.py \
    qml/js/stripper.js \
    qml/js/utils.js \
    qml/pages/TextPage.qml \
    qml/py/pinned.py \
    qml/py/image_provider.py \
    qml/pages/NaviPage.qml \
    qml/items/PageDialog.qml \
    qml/pages/TextPage.qml \
    qml/items/PostItem.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/Neliapila-de.ts

HEADERS += \
    qmlutils.h

