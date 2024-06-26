# This script is offered with NO GUARANTEES. Use at your own risk.
# docker pull elementary/docker:hera-stable #latest
cd ~/Downloads

# ==== Make package managers better ==== 
sudo apt-get install -y software-properties-common
sudo apt install dpkg-sig

# ==== OS enhancements ====
sudo apt-get install com.github.spheras.desktopfolder
# Clipped
if [ $(dpkg-query -W -f='${Status}' com.github.davidmhewitt.clipped 2>/dev/null | grep -c "ok installed") != 1 ]; then
    sudo apt install -y com.github.davidmhewitt.clipped
    echo "Command to get clipboard: com.github.davidmhewitt.clipped –show-paste-window"
fi
# Tweaks
if [ $(dpkg-query -W -f='${Status}' elementary-tweaks 2>/dev/null | grep -c "ok installed") != 1 ]; then
    echo installing tweaks
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:philip.scott/elementary-tweaks
    sudo apt update
    sudo apt install --force-yes -y elementary-tweaks
fi
# Dropbox
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# ~/.dropbox-dist/dropboxd &
if [ $(dpkg-query -W -f='${Status}' nautilus-dropbox 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo apt install -y nautilus-dropbox
    dropbox start &
fi
# dropbox tray icon
if [ $(dpkg-query -W -f='${Status}' wingpanel-indicator-ayatana 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    wget http://ppa.launchpad.net/elementary-os/stable/ubuntu/pool/main/w/wingpanel-indicator-ayatana/wingpanel-indicator-ayatana_2.0.3+r27+pkg17~ubuntu0.4.1.1_amd64.deb 
    sudo dpkg -i wingpanel-indicator-ayatana_2.0.3+r27+pkg17~ubuntu0.4.1.1_amd64.deb 
fi

# ==== Programming languages and editors ==== 
# ghostwriter
if [ $(dpkg-query -W -f='${Status}' ghostwriter 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo add-apt-repository ppa:wereturtle/ppa
    sudo apt-get update --force-yes 
    sudo apt-get install --force-yes -y ghostwriter
fi
# Eclipse
# Beware this bug https://askubuntu.com/questions/1031171/eclipse-doesnt-start-on-ubuntu-18-04
if [ -n $(which eclipse) ]; then
    wget http://mirror.cc.columbia.edu/pub/software/eclipse/technology/epp/downloads/release/2020-06/R/eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz
    tar -xvzf eclipse-cpp-2020-06-R-linux-gtk-x86_64.tar.gz
    sudo cp -r eclipse /opt/
    sudo ln -s /opt/eclipse/eclipse /usr/bin/eclipse    
fi
# R
if [ $(dpkg-query -W -f='${Status}' r-base 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
    sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/"
    sudo apt-get update
    sudo apt-get install -y r-base
fi
# Rstudio (untested)
if [ $(dpkg-query -W -f='${Status}' rstudio 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo apt --fix-broken install
    sudo apt install libclang-dev
    gpg --keyserver keys.gnupg.net --recv-keys 3F32EE77E331692F
    wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.1073-amd64-debian.tar.gz
    dpkg-sig --verify ~/Downloads/rstudio-1.3.1073-amd64-debian.tar.gz
    dpkg -i           ~/Downloads/rstudio-1.3.1073-amd64-debian.tar.gz
fi


sudo apt-get install xzdec
sudo apt-get install texlive-latex-base

# Pandoc 
if [ $(dpkg-query -W -f='${Status}' pandoc 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo apt install -y pandoc
fi

# ==== Everyday stuff ==== 
# Kent utils
sudo rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ /usr/local/bin

# curl
sudo apt install libcurl4-openssl-dev

# LibreOffice
sudo apt install -y libreoffice libreoffice-gtk3 libreoffice-style-elementary
# Firefox
sudo apt-get install -y firefox
# InkScape
sudo add-apt-repository ppa:inkscape.dev/stable
sudo apt update --force-yes 
sudo apt install -y --force-yes inkscape
sudo apt-get install -y --force-yes qpdfview

# ==== Things that make other things work ====
# GCC
sudo apt install -y build-essential
# Wine
if [ $(dpkg-query -W -f='${Status}'  winehq-stable 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo apt remove winehq-stable wine-stable wine1.6 wine-mono wine-geco winetricks
    sudo dpkg --add-architecture i386
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
    sudo add-apt-repository ppa:cybermax-dexter/sdl2-backport
    sudo apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu bionic main"
    sudo apt update --force-yes && sudo apt install -y --force-yes --install-recommends winehq-stable
fi
# Docker
if [ $(dpkg-query -W -f='${Status}'  docker 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo dpkg --configure -a
fi

if [ $(dpkg-query -W -f='${Status}'  singularity-container 2>/dev/null | grep -c "ok installed")  != 1 ]; then
    $ singularity --version
    # Singularity
    wget -O- http://neuro.debian.net/lists/bionic.us-tn.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
    sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
    sudo apt-get update
    sudo apt-get install -y singularity-container
    singularity --version
fi
