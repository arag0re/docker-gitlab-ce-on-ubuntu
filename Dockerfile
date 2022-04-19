FROM ubuntu:20.04
LABEL Maintainer=arag0re.eth
ENV DEBIAN_FRONTEND=noninteractive
# get needed software & configure zsh with autosuggestions
  RUN apt -y update ; \
    apt install -y curl zsh git ca-certificates nano ssh sudo build-essential systemd python runit-systemd ; \
   	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" ; \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ; \
    sed 's,plugins=(git)[^;]*,plugins=(git zsh-autosuggestions),' -i /root/.zshrc ; \
    source /root/.zshrc | bash 
# copy the systemctl from local project-folder 
COPY systemctl.py /usr/bin/systemctl
# configure and prepare ssh server
RUN mkdir /run/sshd
RUN  /usr/bin/ssh-keygen -A 
RUN sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config 
RUN	 sed -i -e 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config 
RUN	 sed -i -e 's/^#X11Forwarding yes/X11Forwarding yes/g' /etc/ssh/sshd_config 
RUN	 sed -i -e 's/^#X11UseLocalhost yes/X11UseLocalhost  no/g' /etc/ssh/sshd_config 
RUN touch /root/.Xauthority
# get latest gitlab-ce build
RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash
RUN apt -y update
RUN apt -y install gitlab-ce
RUN sed -i -e 's#https://gitlab.example.com#http://gitlab-ce-arm64.local#g' /etc/gitlab/gitlab.rb
# expose ports needed by gitlab
EXPOSE 22 25 80 143 443 465 587 5050 9200 
# enable necessary services 
RUN systemctl enable ssh sshd runit
CMD ["/usr/bin/systemctl"]
