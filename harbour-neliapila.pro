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

QT += qml quick network

CONFIG += sailfishapp

SOURCES += src/harbour-neliapila.cpp \
    src/neliapilanam.cpp

DEPLOYMENT_PATH = /usr/share/$${TARGET}

py.files = py
py.path = $${DEPLOYMENT_PATH}

INSTALLS += py

DISTFILES += \
    py/lib/certifi-2018.8.24.dist-info/metadata.json \
    py/lib/chardet-3.0.4.dist-info/metadata.json \
    py/lib/requests-2.19.1.dist-info/metadata.json \
    py/lib/urllib3-1.23.dist-info/metadata.json \
    py/lib/basc_py4chan/__pycache__/__init__.cpython-37.pyc \
    py/lib/basc_py4chan/__pycache__/board.cpython-37.pyc \
    py/lib/basc_py4chan/__pycache__/file.cpython-37.pyc \
    py/lib/basc_py4chan/__pycache__/post.cpython-37.pyc \
    py/lib/basc_py4chan/__pycache__/thread.cpython-37.pyc \
    py/lib/basc_py4chan/__pycache__/url.cpython-37.pyc \
    py/lib/basc_py4chan/__pycache__/util.cpython-37.pyc \
    py/lib/certifi/__pycache__/__init__.cpython-37.pyc \
    py/lib/certifi/__pycache__/__main__.cpython-37.pyc \
    py/lib/certifi/__pycache__/core.cpython-37.pyc \
    py/lib/chardet/__pycache__/__init__.cpython-37.pyc \
    py/lib/chardet/__pycache__/big5freq.cpython-37.pyc \
    py/lib/chardet/__pycache__/big5prober.cpython-37.pyc \
    py/lib/chardet/__pycache__/chardistribution.cpython-37.pyc \
    py/lib/chardet/__pycache__/charsetgroupprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/charsetprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/codingstatemachine.cpython-37.pyc \
    py/lib/chardet/__pycache__/compat.cpython-37.pyc \
    py/lib/chardet/__pycache__/cp949prober.cpython-37.pyc \
    py/lib/chardet/__pycache__/enums.cpython-37.pyc \
    py/lib/chardet/__pycache__/escprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/escsm.cpython-37.pyc \
    py/lib/chardet/__pycache__/eucjpprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/euckrfreq.cpython-37.pyc \
    py/lib/chardet/__pycache__/euckrprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/euctwfreq.cpython-37.pyc \
    py/lib/chardet/__pycache__/euctwprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/gb2312freq.cpython-37.pyc \
    py/lib/chardet/__pycache__/gb2312prober.cpython-37.pyc \
    py/lib/chardet/__pycache__/hebrewprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/jisfreq.cpython-37.pyc \
    py/lib/chardet/__pycache__/jpcntx.cpython-37.pyc \
    py/lib/chardet/__pycache__/langbulgarianmodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/langcyrillicmodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/langgreekmodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/langhebrewmodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/langhungarianmodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/langthaimodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/langturkishmodel.cpython-37.pyc \
    py/lib/chardet/__pycache__/latin1prober.cpython-37.pyc \
    py/lib/chardet/__pycache__/mbcharsetprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/mbcsgroupprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/mbcssm.cpython-37.pyc \
    py/lib/chardet/__pycache__/sbcharsetprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/sbcsgroupprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/sjisprober.cpython-37.pyc \
    py/lib/chardet/__pycache__/universaldetector.cpython-37.pyc \
    py/lib/chardet/__pycache__/utf8prober.cpython-37.pyc \
    py/lib/chardet/__pycache__/version.cpython-37.pyc \
    py/lib/chardet/cli/__pycache__/__init__.cpython-37.pyc \
    py/lib/chardet/cli/__pycache__/chardetect.cpython-37.pyc \
    py/lib/idna/__pycache__/__init__.cpython-37.pyc \
    py/lib/idna/__pycache__/codec.cpython-37.pyc \
    py/lib/idna/__pycache__/compat.cpython-37.pyc \
    py/lib/idna/__pycache__/core.cpython-37.pyc \
    py/lib/idna/__pycache__/idnadata.cpython-37.pyc \
    py/lib/idna/__pycache__/intranges.cpython-37.pyc \
    py/lib/idna/__pycache__/package_data.cpython-37.pyc \
    py/lib/idna/__pycache__/uts46data.cpython-37.pyc \
    py/lib/requests/__pycache__/__init__.cpython-37.pyc \
    py/lib/requests/__pycache__/__version__.cpython-37.pyc \
    py/lib/requests/__pycache__/_internal_utils.cpython-37.pyc \
    py/lib/requests/__pycache__/adapters.cpython-37.pyc \
    py/lib/requests/__pycache__/api.cpython-37.pyc \
    py/lib/requests/__pycache__/auth.cpython-37.pyc \
    py/lib/requests/__pycache__/certs.cpython-37.pyc \
    py/lib/requests/__pycache__/compat.cpython-37.pyc \
    py/lib/requests/__pycache__/cookies.cpython-37.pyc \
    py/lib/requests/__pycache__/exceptions.cpython-37.pyc \
    py/lib/requests/__pycache__/help.cpython-37.pyc \
    py/lib/requests/__pycache__/hooks.cpython-37.pyc \
    py/lib/requests/__pycache__/models.cpython-37.pyc \
    py/lib/requests/__pycache__/packages.cpython-37.pyc \
    py/lib/requests/__pycache__/sessions.cpython-37.pyc \
    py/lib/requests/__pycache__/status_codes.cpython-37.pyc \
    py/lib/requests/__pycache__/structures.cpython-37.pyc \
    py/lib/requests/__pycache__/utils.cpython-37.pyc \
    py/lib/urllib3/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/__pycache__/_collections.cpython-37.pyc \
    py/lib/urllib3/__pycache__/connection.cpython-37.pyc \
    py/lib/urllib3/__pycache__/connectionpool.cpython-37.pyc \
    py/lib/urllib3/__pycache__/exceptions.cpython-37.pyc \
    py/lib/urllib3/__pycache__/fields.cpython-37.pyc \
    py/lib/urllib3/__pycache__/filepost.cpython-37.pyc \
    py/lib/urllib3/__pycache__/poolmanager.cpython-37.pyc \
    py/lib/urllib3/__pycache__/request.cpython-37.pyc \
    py/lib/urllib3/__pycache__/response.cpython-37.pyc \
    py/lib/urllib3/contrib/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/contrib/__pycache__/appengine.cpython-37.pyc \
    py/lib/urllib3/contrib/__pycache__/ntlmpool.cpython-37.pyc \
    py/lib/urllib3/contrib/__pycache__/pyopenssl.cpython-37.pyc \
    py/lib/urllib3/contrib/__pycache__/securetransport.cpython-37.pyc \
    py/lib/urllib3/contrib/__pycache__/socks.cpython-37.pyc \
    py/lib/urllib3/contrib/_securetransport/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/contrib/_securetransport/__pycache__/bindings.cpython-37.pyc \
    py/lib/urllib3/contrib/_securetransport/__pycache__/low_level.cpython-37.pyc \
    py/lib/urllib3/packages/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/packages/__pycache__/ordered_dict.cpython-37.pyc \
    py/lib/urllib3/packages/__pycache__/six.cpython-37.pyc \
    py/lib/urllib3/packages/backports/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/packages/ssl_match_hostname/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/packages/ssl_match_hostname/__pycache__/_implementation.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/__init__.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/connection.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/queue.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/request.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/response.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/retry.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/ssl_.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/timeout.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/url.cpython-37.pyc \
    py/lib/urllib3/util/__pycache__/wait.cpython-37.pyc \
    py/lib/certifi/cacert.pem \
    py/lib/BASC_py4chan-0.6.4-py3.7.egg-info/dependency_links.txt \
    py/lib/BASC_py4chan-0.6.4-py3.7.egg-info/installed-files.txt \
    py/lib/BASC_py4chan-0.6.4-py3.7.egg-info/PKG-INFO \
    py/lib/BASC_py4chan-0.6.4-py3.7.egg-info/requires.txt \
    py/lib/BASC_py4chan-0.6.4-py3.7.egg-info/SOURCES.txt \
    py/lib/BASC_py4chan-0.6.4-py3.7.egg-info/top_level.txt \
    py/lib/certifi-2018.8.24.dist-info/DESCRIPTION.rst \
    py/lib/certifi-2018.8.24.dist-info/INSTALLER \
    py/lib/certifi-2018.8.24.dist-info/LICENSE.txt \
    py/lib/certifi-2018.8.24.dist-info/METADATA \
    py/lib/certifi-2018.8.24.dist-info/RECORD \
    py/lib/certifi-2018.8.24.dist-info/top_level.txt \
    py/lib/certifi-2018.8.24.dist-info/WHEEL \
    py/lib/chardet-3.0.4.dist-info/DESCRIPTION.rst \
    py/lib/chardet-3.0.4.dist-info/entry_points.txt \
    py/lib/chardet-3.0.4.dist-info/INSTALLER \
    py/lib/chardet-3.0.4.dist-info/METADATA \
    py/lib/chardet-3.0.4.dist-info/RECORD \
    py/lib/chardet-3.0.4.dist-info/top_level.txt \
    py/lib/chardet-3.0.4.dist-info/WHEEL \
    py/lib/idna-2.7.dist-info/INSTALLER \
    py/lib/idna-2.7.dist-info/LICENSE.txt \
    py/lib/idna-2.7.dist-info/METADATA \
    py/lib/idna-2.7.dist-info/RECORD \
    py/lib/idna-2.7.dist-info/top_level.txt \
    py/lib/idna-2.7.dist-info/WHEEL \
    py/lib/requests-2.19.1.dist-info/DESCRIPTION.rst \
    py/lib/requests-2.19.1.dist-info/INSTALLER \
    py/lib/requests-2.19.1.dist-info/LICENSE.txt \
    py/lib/requests-2.19.1.dist-info/METADATA \
    py/lib/requests-2.19.1.dist-info/RECORD \
    py/lib/requests-2.19.1.dist-info/top_level.txt \
    py/lib/requests-2.19.1.dist-info/WHEEL \
    py/lib/urllib3-1.23.dist-info/DESCRIPTION.rst \
    py/lib/urllib3-1.23.dist-info/INSTALLER \
    py/lib/urllib3-1.23.dist-info/LICENSE.txt \
    py/lib/urllib3-1.23.dist-info/METADATA \
    py/lib/urllib3-1.23.dist-info/RECORD \
    py/lib/urllib3-1.23.dist-info/top_level.txt \
    py/lib/urllib3-1.23.dist-info/WHEEL \
    py/lib/basc_py4chan/__init__.py \
    py/lib/basc_py4chan/board.py \
    py/lib/basc_py4chan/file.py \
    py/lib/basc_py4chan/post.py \
    py/lib/basc_py4chan/thread.py \
    py/lib/basc_py4chan/url.py \
    py/lib/basc_py4chan/util.py \
    py/lib/bin/chardetect \
    py/lib/certifi/__init__.py \
    py/lib/certifi/__main__.py \
    py/lib/certifi/core.py \
    py/lib/chardet/cli/__init__.py \
    py/lib/chardet/cli/chardetect.py \
    py/lib/chardet/__init__.py \
    py/lib/chardet/big5freq.py \
    py/lib/chardet/big5prober.py \
    py/lib/chardet/chardistribution.py \
    py/lib/chardet/charsetgroupprober.py \
    py/lib/chardet/charsetprober.py \
    py/lib/chardet/codingstatemachine.py \
    py/lib/chardet/compat.py \
    py/lib/chardet/cp949prober.py \
    py/lib/chardet/enums.py \
    py/lib/chardet/escprober.py \
    py/lib/chardet/escsm.py \
    py/lib/chardet/eucjpprober.py \
    py/lib/chardet/euckrfreq.py \
    py/lib/chardet/euckrprober.py \
    py/lib/chardet/euctwfreq.py \
    py/lib/chardet/euctwprober.py \
    py/lib/chardet/gb2312freq.py \
    py/lib/chardet/gb2312prober.py \
    py/lib/chardet/hebrewprober.py \
    py/lib/chardet/jisfreq.py \
    py/lib/chardet/jpcntx.py \
    py/lib/chardet/langbulgarianmodel.py \
    py/lib/chardet/langcyrillicmodel.py \
    py/lib/chardet/langgreekmodel.py \
    py/lib/chardet/langhebrewmodel.py \
    py/lib/chardet/langhungarianmodel.py \
    py/lib/chardet/langthaimodel.py \
    py/lib/chardet/langturkishmodel.py \
    py/lib/chardet/latin1prober.py \
    py/lib/chardet/mbcharsetprober.py \
    py/lib/chardet/mbcsgroupprober.py \
    py/lib/chardet/mbcssm.py \
    py/lib/chardet/sbcharsetprober.py \
    py/lib/chardet/sbcsgroupprober.py \
    py/lib/chardet/sjisprober.py \
    py/lib/chardet/universaldetector.py \
    py/lib/chardet/utf8prober.py \
    py/lib/chardet/version.py \
    py/lib/idna/__init__.py \
    py/lib/idna/codec.py \
    py/lib/idna/compat.py \
    py/lib/idna/core.py \
    py/lib/idna/idnadata.py \
    py/lib/idna/intranges.py \
    py/lib/idna/package_data.py \
    py/lib/idna/uts46data.py \
    py/lib/requests/__init__.py \
    py/lib/requests/__version__.py \
    py/lib/requests/_internal_utils.py \
    py/lib/requests/adapters.py \
    py/lib/requests/api.py \
    py/lib/requests/auth.py \
    py/lib/requests/certs.py \
    py/lib/requests/compat.py \
    py/lib/requests/cookies.py \
    py/lib/requests/exceptions.py \
    py/lib/requests/help.py \
    py/lib/requests/hooks.py \
    py/lib/requests/models.py \
    py/lib/requests/packages.py \
    py/lib/requests/sessions.py \
    py/lib/requests/status_codes.py \
    py/lib/requests/structures.py \
    py/lib/requests/utils.py \
    py/lib/urllib3/contrib/_securetransport/__init__.py \
    py/lib/urllib3/contrib/_securetransport/bindings.py \
    py/lib/urllib3/contrib/_securetransport/low_level.py \
    py/lib/urllib3/contrib/__init__.py \
    py/lib/urllib3/contrib/appengine.py \
    py/lib/urllib3/contrib/ntlmpool.py \
    py/lib/urllib3/contrib/pyopenssl.py \
    py/lib/urllib3/contrib/securetransport.py \
    py/lib/urllib3/contrib/socks.py \
    py/lib/urllib3/packages/backports/__init__.py \
    py/lib/urllib3/packages/ssl_match_hostname/__init__.py \
    py/lib/urllib3/packages/ssl_match_hostname/_implementation.py \
    py/lib/urllib3/packages/__init__.py \
    py/lib/urllib3/packages/ordered_dict.py \
    py/lib/urllib3/packages/six.py \
    py/lib/urllib3/util/__init__.py \
    py/lib/urllib3/util/connection.py \
    py/lib/urllib3/util/queue.py \
    py/lib/urllib3/util/request.py \
    py/lib/urllib3/util/response.py \
    py/lib/urllib3/util/retry.py \
    py/lib/urllib3/util/ssl_.py \
    py/lib/urllib3/util/timeout.py \
    py/lib/urllib3/util/url.py \
    py/lib/urllib3/util/wait.py \
    py/lib/urllib3/__init__.py \
    py/lib/urllib3/_collections.py \
    py/lib/urllib3/connection.py \
    py/lib/urllib3/connectionpool.py \
    py/lib/urllib3/exceptions.py \
    py/lib/urllib3/fields.py \
    py/lib/urllib3/filepost.py \
    py/lib/urllib3/poolmanager.py \
    py/lib/urllib3/request.py \
    py/lib/urllib3/response.py \
    py/boards.py \
    py/getdata.py \
    py/image_provider.py \
    py/pinned.py \
    py/posts.py \
    py/pyotherside.py \
    py/savefile.py \
    py/storage.py \
    py/threads.py \
    py/utils.py \
    qml/pages/NewPost.qml \
    qml/pages/Captcha2Page.qml

HEADERS += \
    src/neliapilanam.h

