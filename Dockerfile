FROM archlinux:latest

RUN pacman -Sy && \
    pacman -S --noconfirm gcc git lua make sudo && \
    pacman -Sc --noconfirm

RUN useradd -m shivix

RUN usermod -aG wheel shivix
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

RUN echo "wew" | passwd shivix -s

COPY . /home/shivix/luasys/

WORKDIR /home/shivix/luasys

USER shivix
