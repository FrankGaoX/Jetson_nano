echo Installing Librealsense-required dev packages
sudo apt-get install git cmake libssl-dev freeglut3-dev libusb-1.0-0-dev pkg-config libgtk-3-dev unzip -y
rm -f ./master.zip

echo downloadlibrealses v2.30.0
wget https://github.com/IntelRealSense/librealsense/archive/v2.30.0.zip
unzip ./v2.30.0.zip -d .
cd ./libre<TAB>

echo Install udev-rules
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/ 
sudo udevadm control --reload-rules && sudo udevadm trigger 
mkdir build && cd build

# Build with CUDA (default), the CUDA flag is USE_CUDA, ie -DUSE_CUDA=true
NVCC_PATH=/usr/local/cuda-10.2/bin/nvcc
export CUDACXX=$NVCC_PATH
export PATH=${PATH}:/usr/local/cuda/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

cmake ../ -DBUILD_EXAMPLES=true -DFORCE_LIBUVC=true -DBUILD_WITH_CUDA=true -DCMAKE_BUILD_TYPE=release -DBUILD_PYTHON_BINDINGS=bool:true
make -j2
sudo make install
echo -e "\e[92m\n\e[1mLibrealsense script completed.\n\e[0m"
