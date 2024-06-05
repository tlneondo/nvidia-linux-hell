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

#install driver through negativ017 guide

#https://negativo17.org/nvidia-driver/#Repository_installation

#add the repo
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo

#install
#
#driver libs i686 are 32 bit libs needed for steam
#dnf -y install nvidia-driver nvidia-settings nvidia-driver-libs.i686
#may need rawhide (experimental) to get the beta driver
dnf --releasever=rawhide -y install nvidia-driver nvidia-settings nvidia-driver-libs.i686 nvidia-driver-NvFBCOpenGL nvidia-driver-cuda cuda-devel 

#add to kernel command line
#nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_EnableGpuFirmware=0
#NVreg_UsePageAttributeTable=1 NVreg_PreserveVideoMemoryAllocations=1 nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_EnableGpuFirmware=0

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