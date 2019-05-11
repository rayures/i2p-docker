#dev
FROM debian:buster
 
ENV I2P_DIR /usr/share/i2p
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

RUN apt-get -y update && \
    apt-get -y install \
	  gnupg \
          locales \
          procps \
	  nano \
	  wget &&\
    apt-get clean
    
ADD preferences /etc/apt/preferences

RUN	echo "deb https://deb.i2p2.de/ buster main" | tee -a /etc/apt/sources.list && \
	echo "deb-src https://deb.i2p2.de/ buster main" | tee -a /etc/apt/sources.list && \
#echo "deb https://deb.i2p2.de/ buster main" > /etc/apt/sources.list.d/i2p.list && \
#echo "deb-src https://deb.i2p2.de/ buster main" > /etc/apt/sources.list.d/i2p.list && \
	wget https://geti2p.net/_static/i2p-debian-repo.key.asc && \
	apt-key add i2p-debian-repo.key.asc && \
	rm i2p-debian-repo.key.asc
#    rm /etc/apt/sources.list	
    
RUN apt-get -y update && \
    apt-get -y install \
      	  i2p-keyring \
          i2p &&\
    apt-get clean
    
RUN echo "RUN_AS_USER=i2psvc" >> /etc/default/i2p && \
    apt-get clean && \
    rm -rf /var/lib/i2p && \
	mkdir -p /var/lib/i2p/i2p-config && \
	chown -R i2psvc:i2psvc /var/lib/i2p && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*
 
# Enable UTF-8, mostly for I2PSnark
RUN sed -i 's/.*\(en_US\.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen && \
    /usr/sbin/update-locale LANG=${LANG} LANGUAGE=${LANGUAGE}

# Edit config 
RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/i2ptunnel.config && \
    sed -i 's/::1,127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/clients.config && \
    printf "i2cp.tcp.bindAllInterfaces=true\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.ipv4.firewalled=false\ni2np.ntcp.ipv6=false\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.udp.ipv6=false\ni2np.upnp.enable=false\n" >> ${I2P_DIR}/router.config

##
# Expose some ports used by I2P
# Description at https://geti2p.net/ports
#
# Main ports:
# 2827 - BOB port
# 4444 — HTTP proxy
# 4445 - HTTPS proxy
# 6668 — Proxy to Irc2P
# 7650 - I2PControl Plugin
# 7656 - SAM port
# 7657 — router console
# 7658 — self-hosted eepsite
# 7659 — SMTP proxy to smtp.postman.i2p
# 7660 — POP3 proxy to pop.postman.i2p
# 7661 - Pebble Plugin / I2PBote Plugin SMTP
# 7662 - Zzzot Plugin / I2PBote Plugin IMAP
# 8998 — Proxy to mtn.i2p-projekt.i2p / Monotone Proxy
# 9111-30777 - Router network port (random, selected at install time) 
##

EXPOSE 2827 4444 4445 6668 7650 7654 7655 7656 7657 7658 7659 7660 7661 7662 8998 9111-30777
 
VOLUME /var/lib/i2p
USER i2psvc
ENTRYPOINT ["/usr/bin/i2prouter"]
CMD ["console"]
