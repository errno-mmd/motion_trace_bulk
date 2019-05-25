FROM ubuntu:18.10

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# install packages
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get update
RUN apt-get install -y curl unzip lv
RUN apt-get install -y python3-pip
RUN apt-get install -y git
RUN apt-get install -y wget
RUN apt-get install -y libsm6 libgl1 libxrender1

# FCRN-DepthPrediction-vmd
RUN pip3 install python-dateutil
RUN pip3 install pytz
RUN pip3 install pyparsing
RUN pip3 install six
RUN pip3 install matplotlib
RUN pip3 install opencv-python
RUN pip3 install imageio
RUN pip3 install tensorflow
RUN curl -L https://github.com/miu200521358/FCRN-DepthPrediction-vmd/archive/master.tar.gz \
 | tar -zxv \
 && mv FCRN-DepthPrediction-vmd-master FCRN-DepthPrediction-vmd
RUN mkdir /FCRN-DepthPrediction-vmd/tensorflow/data \
 && curl -L -O http://campar.in.tum.de/files/rupprecht/depthpred/NYU_FCRN-checkpoint.zip \
 && unzip NYU_FCRN-checkpoint.zip -d /FCRN-DepthPrediction-vmd/tensorflow/data/ \
 && rm NYU_FCRN-checkpoint.zip

# 3d-pose-baseline-multi
RUN pip3 install h5py
RUN curl -L https://github.com/miu200521358/3d-pose-baseline-vmd/archive/master.tar.gz \
 | tar -zxv \
 && mv 3d-pose-baseline-vmd-master 3d-pose-baseline-vmd
RUN mkdir /3d-pose-baseline-vmd/data \
 && curl -L -O https://www.dropbox.com/s/e35qv3n6zlkouki/h36m.zip \
 && unzip -d /3d-pose-baseline-vmd/data h36m.zip \
 && rm h36m.zip
RUN mkdir /3d-pose-baseline-vmd/experiments \
 && curl -sc /tmp/cookie 'https://drive.google.com/uc?id=1v7ccpms3ZR8ExWWwVfcSpjMsGscDYH7_&export=download' > /dev/null \
 && export TOKEN="$(awk '/_warning_/ {print $NF}' /tmp/cookie)" \
 && curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${TOKEN}&id=1v7ccpms3ZR8ExWWwVfcSpjMsGscDYH7_" -o experiments.zip \
 && rm /tmp/cookie \
 && unzip -d /3d-pose-baseline-vmd/ experiments.zip \
 && rm experiments.zip

# VMD-3d-pose-baseline-multi
RUN pip3 install PyQt5
RUN curl -L https://github.com/miu200521358/VMD-3d-pose-baseline-multi/archive/master.tar.gz \
 | tar -zxv \
 && mv VMD-3d-pose-baseline-multi-master VMD-3d-pose-baseline-multi
RUN mkdir /VMD-3d-pose-baseline-multi/data/saved_sessions
RUN curl -L http://visual.cs.ucl.ac.uk/pubs/liftingFromTheDeep/res/init_session.tar.gz \
 | tar -zxvC /VMD-3d-pose-baseline-multi/data/saved_sessions 
RUN curl -L http://visual.cs.ucl.ac.uk/pubs/liftingFromTheDeep/res/prob_model.tar.gz \
 | tar -zxvC /VMD-3d-pose-baseline-multi/data/saved_sessions 

# tf-pose-estimation
RUN pip3 install Cython
RUN apt-get install -y swig
RUN curl -L https://github.com/errno-mmd/tf-pose-estimation/archive/develop.tar.gz \
 | tar -zxv \
 && mv tf-pose-estimation-develop tf-pose-estimation
RUN cd tf-pose-estimation \
 && pip3 install -r requirements.txt \
 && cd tf_pose/pafprocess \
 && swig -python -c++ pafprocess.i \
 && python3 setup.py build_ext --inplace

CMD ["bash"]
