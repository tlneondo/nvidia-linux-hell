#make sure kernel modules can be signed for secure boot
#from: https://blog.monosoul.dev/2022/05/17/automatically-sign-nvidia-kernel-module-in-fedora-36/


sudo dnf install kmodtool akmods mokutil openssl
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
sudo reboot

#Enroll the key

#After reboot you will see MOK Manager interface and will be asked to enroll the key. Probably if you ever installed nVidia drivers in Ubuntu with Secure boot enabled, you’ve seen this interface before.
#First select “Enroll MOK“.
#Then “Continue“.
#Hit “Yes” and enter the password from step 3.
#Then select “OK” and your device will reboot again.

#remove old nvidia drivers
sudo dnf -y remove *nvidia*
sudo dnf -y remove xorg-x11-drv-nvidia\*

#official rpmfusion instructions for stable driver
sudo dnf update -y 
# and reboot if you are not on the latest kernel
sudo dnf install akmod-nvidia 
# rhel/centos users can use kmod-nvidia instead
sudo dnf install xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power  vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 nvidia-vaapi-driver libva-utils vdpauinfo
#optional for cuda/nvdec/nvenc support
sudo systemctl enable nvidia-{suspend,resume,hibernate}
#enable Nvidia suspensions


#BETA from RAWHIDE

sudo dnf install "kernel-devel-uname-r >= $(uname -r)"
sudo dnf update -y
sudo dnf install libva-utils vdpauinfo
sudo dnf copr enable kwizart/nvidia-driver-rawhide -y
sudo dnf install rpmfusion-nonfree-release-rawhide -y
sudo dnf --enablerepo=rpmfusion-nonfree-rawhide install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power vulkan xorg-x11-drv-nvidia-cuda-libs xorg-x11-drv-nvidia-libs.i686 nvidia-vaapi-driver --nogpgcheck


########################################################################
#Make sure the kernel modules got compiled
sudo akmods --force

#Make sure the boot image got updated as well
sudo dracut --force

#Reboot your device
sudo reboot

#enable Nvidia suspend services
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

sudo reboot