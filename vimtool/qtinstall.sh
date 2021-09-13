array=(build-essential 
libgl1-mesa-dev
libfontconfig1-dev
libfreetype6-dev
libx11-dev
libxext-dev
libxfixes-dev
libxi-dev
libxrender-dev
libxcb1-dev
libx11-xcb-dev
libxcb-glx0-dev
libxkbcommon-x11-dev
libxcb-keysyms1-dev
libxcb-image0-dev
libxcb-shm0-dev
libxcb-icccm4-dev
libxcb-sync0-dev
libxcb-xfixes0-dev
libxcb-shape0-dev
libxcb-randr0-dev
libxcb-render-util0-dev
)

for(( i=0;i<${#array[@]};i++)) do
#${#array[@]}获取数组长度用于循环
sudo apt-get install ${array[i]} -y;
done;


