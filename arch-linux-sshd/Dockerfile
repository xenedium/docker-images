FROM archlinux

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

RUN pacman -Syu --noconfirm openssh curl

# Host keys
RUN ssh-keygen -A

EXPOSE 2222
CMD ["/root/entrypoint.sh"]