FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y install \
        hostapd \
	    nano \
	    iw \
        wireless-tools \
        ifupdown \
        python3 \
        python3-pip \
        python3-dev \
        iptables \
        net-tools \
        rfkill \
        libpcap-dev \
	libglib2.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# Copy all files to app folder
COPY . /usr/src/app
WORKDIR /usr/src/app
COPY config/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
#RUN update-alternatives --install /usr/bin/python3 python3 1
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install pyqt5==5.14
RUN python3 -m pip install -r requirements.txt 
RUN python3 setup.py install
WORKDIR /root/.config/wifipumpkin3
CMD /usr/local/bin/wifipumpkin3 -i wlan1 --pulp scripts/hackpack.pulp --wireless-mode docker --no-colors --rest --restport 54445 --username $WP3USERNAME --password $WP3PASSWORD

