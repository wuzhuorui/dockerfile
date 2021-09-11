FROM ubuntu:18.04
COPY sources.list /etc/apt/
ARG user 
ARG password
RUN set -ex && apt update -y 2> /dev/null && apt install vim -y 2> /dev/null && apt install sudo -y 2> /dev/null \
    && apt install python -y 2> /dev/null \
    && apt install python3 -y 2> /dev/null \
    && apt install python-pip -y 2> /dev/null \
    && apt install python3-pip -y 2> /dev/null \ 
    && apt install git -y 2> /dev/null \
    && apt install wget -y 2> /dev/null 

RUN echo "root:root" | chpasswd \
    && useradd -d /home/$user -m $user \
    && echo "$user:$password" | chpasswd \
    && chmod 750 /home/$user \
    && chmod u+w /etc/sudoers \
	&& sed -i '/# User privilege specification/a\'"${user}"' ALL=(ALL:ALL)   ALL' /etc/sudoers \
    && chmod u-w /etc/sudoers

USER $user

ARG proxy
RUN git config --global https.proxy $proxy \
    && git config --global http.proxy $proxy

RUN mkdir -p /home/$user/.vim/bundle \
    && cd /home/$user/.vim/bundle \
    && git clone https://github.com/scrooloose/nerdtree.git \
    && git clone --recursive https://github.com/Valloric/YouCompleteMe.git \
    && git clone https://github.com/VundleVim/Vundle.vim.git \
    && git clone https://github.com/tpope/vim-fugitive.git

RUN cd /home/$user\
    && mkdir cmake \
    && cd cmake \
    && wget https://cmake.org/files/v3.16/cmake-3.16.4-Linux-x86_64.tar.gz \
    && tar -zxvf cmake-3.16.4-Linux-x86_64.tar.gz \
    && set -ex && echo "$password" | sudo -S ln -sf /home/$user/cmake/cmake-3.16.4-Linux-x86_64/bin/*  /usr/bin/

RUN set -ex && echo "$password" | sudo -S apt-get install g++-8 -y \
    && sudo rm /usr/bin/g++ \
    && sudo rm /usr/bin/gcc \
    && sudo ln -sf /usr/bin/g++-8 /usr/bin/g++ \
    && sudo ln -sf /usr/bin/gcc-8 /usr/bin/gcc

RUN echo "$password" | sudo -S apt install libncurses5-dev libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev python3-dev ruby-dev lua5.2 lua5.2-dev libperl-dev git -y \
    && sudo apt remove vim vim-runtime gvim -y \
    && cd /home/$user/ \
    && git clone https://github.com/vim/vim.git \
    && cd vim \
    && ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-python3interp=yes \
            --with-python3-config-dir=$(python3-config --configdir) \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=/usr/local \
    && make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
RUN cd /home/$user/vim/ &&  echo "$password" | sudo -S make install

RUN echo "$password" | sudo -S apt install clang-8 libclang-8-dev -y

RUN cd ~/.vim/bundle/YouCompleteMe/ \
    && python3 install.py

RUN mkdir ~/.ycm_build \
    && cd ~/.ycm_build \
    && cmake -G "Unix Makefiles" -DUSE_SYSTEM_BOOST=ON -DEXTERNAL_LIBCLANG_PATH=/usr/lib/x86_64-linux-gnu/libclang-8.so . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp \
    && cmake --build . --target ycm_core


COPY .ycm_extra_conf.py /home/$user/.vim/.ycm_extra_conf.py
COPY .vimrc /home/$user/.vimrc
RUN vim +PluginInstall +qall

RUN sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/g" ~/.bashrc

#安装 qt
WORKDIR /home/build

RUN cd /home/build && wget http://qt.mirror.constant.com/archive/qt/5.12/5.12.11/qt-opensource-linux-x64-5.12.11.run && chmod +x qt-opensource-linux-x64-5.12.11.run 

RUN echo "$password" | sudo -S apt-get install build-essential libgl1-mesa-dev -y \
	&& sudo apt install libxkbcommon-x11-0 -y \
	&& sudo apt-get install -y libwayland-cursor0

RUN sleep 3000

ARG displayip
RUN cd /home/build \
	&& export DISPLAY=$displayip:0.0 \ 
	&& export LIBGL_ALWAYS_INDIRECT=1 \
	&& sudo /etc/init.d/dbus start &> /dev/null \
	&& ./qt-opensource-linux-x64-5.12.11.run

WORKDIR /home/$user
