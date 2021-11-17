##################################################################################################
# Actualizacion de Paquetes y repositorios.
##################################################################################################

# Solucion de resolucion de dominio.
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

# Limpiar repositorios.
sudo apt clean

# Actualizar repositorios.
sudo apt-get update -y

# Actualizar paquetes y/o dependencias.
sudo apt-get upgrade -y

##################################################################################################
# Instalacion de KVM.
##################################################################################################

# Checar que nuestro sistema operativo en realidad sea la version 21.04.
lsb_release -a

# Checar que Ubuntu sea compatible con KVM. (Si el resultado > 0, el procesador soporta virtualizacion de hardware)
egrep -c '(vmx|svm)' /proc/cpuinfo

# En caso de que de un error el comando de arriba, ejecutar:
sudo apt install cpu-checker

# Checar si Ubuntu soporta KVM.
sudo kvm-ok 

# Instalar KVM.
sudo apt install -y qemu qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Habiliitar el servicio libvirtd que arranque junto a ubuntu.
sudo systemctl enable --now libvirtd

##################################################################################################
# Instalacion de LXD.
##################################################################################################

# Instalacion de linux containers.
sudo snap install lxd

# Inicializacion de linux containers.
sudo lxd init --auto

##################################################################################################
# Instalacion de dependencias adicionales.
##################################################################################################

# Instalacion.
sudo apt install mysql-client-core-8.0
sudo apt-get install -y git
sudo apt-get install -y ntp
sudo apt-get install -y iptables arptables ebtables
sudo apt-get install -y python3-pip
/usr/bin/python3.9 -m pip install --upgrade pip
/usr/bin/python3.9 -m pip install --upgrade PyYAML
rm -rf /usr/lib/python3/dist-packages/simplejson*

##################################################################################################
# Instalacion de DevStack.
##################################################################################################

# Se clona el repositorio de devstack.
git clone https://github.com/openstack/devstack.git

# Creacion del usuario stack.
# sudo ./devstack/tools/create-stack-user.sh

# Copiar el archivo de configuracion a la raiz de devstack.
cp local.conf devstack/local.conf

# Actualizar reglas del firewall.
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy || true
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy || true
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy || true
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy || true

# Creacion de directorios, archivos y variables de entorno necesarios para la instalacion.
export XDG_SESSION_TYPE=wayland

# Agrega las siguientes lineas a /etc/sysctl.conf.
# net.ipv6.conf.all.disable_ipv6 = 0
# net.ipv6.conf.default.disable_ipv6 = 0
# net.ipv6.conf.lo.disable_ipv6 = 0
# sudo sysctl -p

# Agregar al usuario de vagrant al grupo de sudo.
sudo usermod -aG sudo vagrant

# Instalar devstack.
# FORCE=yes ./devstack/stack.sh