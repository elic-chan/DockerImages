FROM wephoon/openjdk8:debian-buster

LABEL maintainer="wephoon<wephoon@outlook.com>"

ENV ANT_HOME=/usr/share/ant

RUN set -eux \
       && apt-get update \
       && apt-get --no-install-recommends -yq install locales ca-certificates wget unzip build-essential cmake \
       && apt-get --no-install-recommends -yq install python3-dev python3-numpy libopenblas-dev libjpeg-dev libtiff-dev libpng-dev ant \
       && localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 \
       # && wget -O opencv-4.1.0.zip --progress=dot:giga https://github.com/opencv/opencv/archive/refs/tags/4.1.0.zip \
       && wget --progress=dot:giga -r -np -nd -nH https://github.com/opencv/opencv/archive/refs/tags/4.1.0.zip -O opencv-4.1.0.zip \
       && wget --progress=dot:giga -r -np -nd -nH https://github.com/opencv/opencv_contrib/archive/refs/tags/4.1.0.zip -O opencv_contrib-4.1.0.zip \
       && unzip opencv-4.1.0.zip \
       && unzip opencv_contrib-4.1.0.zip \ 
       && mkdir ./opencv-4.1.0/build \
       && cd ./opencv-4.1.0/build \
       && cmake -DCMAKE_BUILD_TYPE=Release -DCPACK_BINARY_DEB=ON -DOPENCV_GENERATE_PKGCONFIG=ON -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.1.0/modules \
                -DCMAKE_INSTALL_PREFIX=/usr/local/ .. -DEXTRA_MODULES_VCSVERSION=4.1.0 -DOPENCV_VCSVERSION=4.1.0 -DWITH_TBB=ON -DWITH_IPP=ON \
                -DWITH_CUDA=OFF -DWITH_OPENCL=ON -DWITH_LIBV4L=ON -DWITH_OPENMP=ON -DWITH_NVCUVID=OFF -DWITH_CSTRIPES=ON -DWITH_GSTREAMER=ON \
                -DBUILD_opencv_python3=ON -DBUILD_PERF_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DBUILD_DOCS=ON .. \
       && make -j4 \
       && make install \
       && cpack -G DEB \
       # && make uninstall \
       && make clean

CMD ["/bin/bash"]