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
# Instalacion de un cliente de mysql.
##################################################################################################

# Instalacion.
sudo apt install mysql-client-core-8.0

##################################################################################################
# Instalacion de MicroStack.
##################################################################################################

# Instalacion.
sudo snap install microstack --devmode --beta

# Inicialiacion.
sudo microstack init --auto --control

# Ejecucion cada que se inicia la maquina virtual.
sudo snap enable microstack

# Creacion de alias de microstack.
sudo snap alias microstack.openstack openstack

# Obtencion de contrasena del host de horizon.
sudo snap get microstack config.credentials.keystone-password

# Obtencion de contrasena del servidor de mysql de microstack.
sudo snap get microstack config.credentials.mysql-root-password

##################################################################################################
# Instalacion del modulo de ceilometer.
##################################################################################################

# Creacion de usuario para ceilometer.
openstack user create --domain default --password admin ceilometer

# Asignar el rol de administrador al usuario de ceilometer.
openstack role add --project service --user ceilometer admin

# Crear la entidad de servicio de ceilometer.
openstack service create --name ceilometer --description "Telemetry" metering

#--------------------------------------------------------------------------------------------------
# Registrar el servicio de gnocchi en el modulo de keystone.
#--------------------------------------------------------------------------------------------------

# Creacion del usuario de gnocchi.
openstack user create --domain default --password admin gnocchi

# Creacion de la entidad de servicio de gnocchi.
# openstack service create --name gnocchi --description "Metric Service" metric

# Asignar el rol de administrador al usuario de gnocchi.
openstack role add --project service --user gnocchi admin

# Crear los endpoints del servicio de metricas.
# openstack endpoint create --region RegionOne metric public http://controller:8041
# openstack endpoint create --region RegionOne metric internal http://controller:8041
# openstack endpoint create --region RegionOne metric admin http://controller:8041

# Instalacion de los paquetes de gnocchi.
sudo apt-get install -y gnocchi-api gnocchi-metricd python3-gnocchiclient
