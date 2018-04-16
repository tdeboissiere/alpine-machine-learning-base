# BSD 3-Clause License
#
# Copyright (c) 2017, Juliano Petronetto
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

FROM alpine:3.7

LABEL maintainer="Juliano Petronetto <juliano@petronetto.com.br>" \
      name="Alpine Machine Learning Base Container" \
      description="Alpine for Machine Learning/Deep Learning stuffs with Python" \
      url="https://hub.docker.com/r/petronetto/alpine-machine-learning-base" \
      vcs-url="https://github.com/petronetto/alpine-machine-learning-base" \
      vendor="Petronetto DevTech" \
      version="1.0"


WORKDIR /home

RUN echo "|--> Updating" \
    && apk update && apk upgrade \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/main | tee /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing | tee -a /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/community | tee -a /etc/apk/repositories \
    && echo "|--> Install basics pre-requisites" \
    && apk add --no-cache tini \
        curl ca-certificates \
        freetype jpeg libpng libstdc++ libgomp graphviz font-noto zsh git\
    && echo "|--> Install Python basics" \
    && curl -o /home/miniconda.sh -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && echo "|--> Done!"

####################################
# Set up locale to avoid zsh errors
####################################
ENV LANG=en_US.UTF-8 \ 
LANGUAGE=en_US.UTF-8 \ 
LC_CTYPE=en_US.UTF-8 \ 
LC_ALL=en_US.UTF-8

ENV LANG en_US.utf8

####################################
# Set up oh my zsh
####################################
ENV HOME /home
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/.oh-my-zsh
COPY zshrc /home/.zshrc
RUN sed -i 's/❯/Docker❯/g' /home/.oh-my-zsh/themes/refined.zsh-theme

RUN cd /home

RUN echo "|--> Python" \
    && chmod +x /home/miniconda.sh
    #&& /home/miniconda.sh -b -p /home/miniconda3  \
    #&& rm /home/miniconda.sh

RUN cd /home

CMD ["/bin/zsh"]
