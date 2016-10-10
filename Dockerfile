FROM revmischa/ezstream:latest

# deps
RUN ["yum", "-y", "install", "python-virtualenv"]

WORKDIR /home/streamer
ADD playlist.sh s3playlist.py requirements.txt update-config.sh ezstream.xml ./
RUN ["chown", "-R", "streamer", "/home/streamer"]

USER streamer

# python venv
RUN ["virtualenv", "venv"]
RUN ["bash", "-c", "source venv/bin/activate && easy_install pip"]

# python deps
ADD requirements.txt ./
RUN ["bash", "-c", "source venv/bin/activate && pip install -r requirements.txt"]

# configuration
RUN ["chmod", "og-rw", "ezstream.xml", "playlist.sh", "s3playlist.py"]

# # set config from env
# # you should have these set
ENV s3bucket=tunes.llolo.lol\
    stream_uri=http://source.my.server:8000/mountpoint.mp3\
    stream_pass=mycoolpassword

# # CMD cat ezstream.xml
CMD ./update-config.sh && echo "Beginning stream..." && ezstream -vv -c ezstream.xml