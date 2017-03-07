# Paquete DEB vx-dga-l-imponer-resolucion-xrandr-automatico

Paquete encargado de Imponer una determinada resolución en los equipos

# Usuarios Destinatarios

PCs de aula que tienen problemas con la resolución 

# Aspectos Interesantes:

```
Se puede imponer la resolución en base a etiquetas migasfree o pasándoselo como primer parametro al script vx-imponer-resolucion-xrandr-automatico.sh
```

# De donde obtener el paquete DEB:

http://migasfree.educa.aragon.es/repo/Lubuntu-14.04/STORES/base/vx-dga-l-imponer-resolucion-xrandr-automatico_1.0-1_all.deb

Donde el listado de todos los paquetes esta en:

http://migasfree.educa.aragon.es/repo/Lubuntu-14.04/STORES/base

# Como Crear el paquete DEB a partir del codigo de GitHub
Para crear el paquete DEB será necesario encontrarse dentro del directorio donde localizan los directorios que componen el paquete.  Una vez allí, se ejecutará el siguiente comando (es necesario tener instalados los paquetes apt-get install debhelper devscripts):

```
apt-get install debhelper devscripts
/usr/bin/debuild --no-tgz-check -us -uc
```

# Como Instalar el paquete generado vx-dga-l-*.deb:
Para la instalación de paquetes que estan en el equipo local puede hacerse uso de ***dpkg*** o de ***gdebi***, siendo este último el más aconsejado para que se instalen también las dependencias correspondientes.
```
gdebi vx-dga-l-*.deb
```
