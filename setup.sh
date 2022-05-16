#!/usr/bin/env bash
#Shell script to provision an Ubuntu EC2 instance with a Py-ART Jupyter notebook
#Environment. Instance must have 8888 and https open
#Code adapted from https://github.com/openradar/AMS_radar_in_the_cloud/blob/master/ec2_setup/setup_ec2.sh (Modified to Python3.8)

# update this virtual machine
    sudo apt-get -y update
    sudo apt-get -y install gcc gfortran

# install minoconda
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b
    
    echo 'PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/miniconda3/bin:$PATH"

# use conda to install all the things
    conda update -y conda
    conda install python=3.8
    conda install numpy matplotlib
    conda install jupyter
    conda install netcdf4
    conda install xarray
    conda install scipy
    conda install boto
    conda install boto3
    conda install -c conda-forge arm_pyart
    conda install cartopy

# set up SSL cert for Jupyter server
    jupyter notebook --generate-config
    key=$(python -c "from notebook.auth import passwd; print(passwd())")
    
    mkdir certs
    cd certs
    certdir=$(pwd)
    
    openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
    -subj "/C=XX/ST=XX/L=XX/O=generated/CN=generated" \
    -keyout mycert.key -out mycert.pem

# set up Jupyter notebook app
    cd ~
    
    sed -i "1 a\
    c = get_config()\\
    c.NotebookApp.certfile = u'$certdir/mycert.pem'\\
    c.NotebookApp.ip = '*'\\
    c.NotebookApp.open_browser = False\\
    c.NotebookApp.password = u'$key'\\
    c.NotebookApp.port = 8888" .jupyter/jupyter_notebook_config.py
    
    guess_at_aws_fqdn="https://"`curl -s http://169.254.169.254/latest/meta-data/public-hostname`":8888
    echo $guess_at_aws_fqdn

# run it!
    
    . ~/.bashrc
    jupyter notebook --certfile=~/certs/mycert.pem --keyfile ~/certs/mycert.key