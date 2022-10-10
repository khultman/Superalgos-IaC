
# # Configuration Variables

# ## AWS AL2 Settings
#  # ASDF_VERSION is used manage the installation version of node
# ASDF_VERSION="v0.10.2"
ASDF_VERSION="v0.10.2"

# INSTALL_DIR="/opt/customer"
INSTALL_DIR="/opt/customer"

# ### INSTALL_USER="ec2-user"
INSTALL_USER="ec2-user"

# ## GITHUB_USER="<you>"
# GITHUB_USER=""

# ## GIT_URI=${GITHUB_USER}@github.com:${GITHUB_USER}/Superalgos.git
GIT_URI="${GITHUB_USER}@github.com:${GITHUB_USER}/Superalgos.git"

# ## NODEJS_BINARY="/usr/bin/node"
NODEJS_BINARY="${HOME}/.asdf/shims/node"

# ## NODEJS_VERSION="lts"
NODEJS_VERSION="lts"

# ## PLATFORM_EXCHANGE=alpaca
PLATFORM_EXCHANGE="alpaca"

# ## PLATFORM_OPTS="minMemo noBrowser"
PLATFORM_OPTS="minMemo noBrowser"

# ## PYTHON_VERSION="3.9.10"
PYTHON_VERSION="3.9.10"

# ## PYTHON_URI=https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
PYTHON_URI="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"


# ## SUPERALGOS_TCP_DEFAULT=34248
SUPERALGOS_TCP_DEFAULT=34248


# ## start: systemctl service file
# SERVICE_FILE=$(cat << EOF
# [Unit]
# Description=Superalgos Platform Client
# 
# [Service]
# Type=simple
# User=ec2-user
# WorkingDirectory=${INSTALL_DIR}/Superalgos
# ExecStart=${NODEJS_BINARY} platform ${PLATFORM_OPTS} ${PLATFORM_EXCHANGE}
# 
# [Install]
# WantedBy=multi-user.target
# EOF)
SERVICE_FILE=$(cat << EOF
[Unit]
Description=Superalgos Platform Client

[Service]
Type=simple
User=ec2-user
WorkingDirectory=${INSTALL_DIR}/Superlagos
ExecStart=${NODEJS_BINARY} platform ${PLATFORM_OPTS} ${PLATFORM_EXCHANGE}

[Install]
WantedBy=multi-user.target
EOF
# ### end: systemctl service file


# # Install Pre-Requisites

# ## Install system pre-requisites: YUM
sudo yum -y groupinstall "Development Tools"
sudo yum -y install openssl-devel bzip2-devel libffi-devel


# Create customer installation directory
sudo mkdir -p ${INSTALL_DIR}
sudo chown -R ${INSTALL_USER} ${INSTALL_DIR}
cd ${INSTALL_DIR}

# ## Install asdf to manage the correct version of node

git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch ${ASDF_VERSION}
. ${HOME}/.asdf/asdf.sh

# ## Install node
asdf plugin add nodejs
asdf install nodejs ${NODEJS_VERSION}

# Install Python 3 from source
curl -o ${PYTHON_VERSION}.tgz "${PYTHON_URI}"
tar xvf ${PYTHON_VERSION}.tgz
cd ${PYTHON_VERSION}
./configure --enable-optimizations
sudo make altinstall


# Install 

##

git clone ${GIT_URI}

mkdir -p ${INSTALL_DIR}/Superalgos/Headless
cd ${INSTALL_DIR}/Superalgos/Headless
touch superalgos.service
echo ${SERVICE_FILE} > superalgos.service


sudo ln -s ${INSTALL_DIR}/Superalgos/Headless/superalgos.service /etc/systemd/system/superlagos.service
sudo systemctl daemon-reload
sudo systemctl enable superalgos
sudo systemctl start superalgos


# # superalgos-host-inbound







