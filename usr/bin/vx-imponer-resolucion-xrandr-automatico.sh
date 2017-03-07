#!/bin/bash
# Autor: Arturo Martín Romero - amartinromero@gmail.com - programa de software libre

## Comenzamos importando y definiendo las variables que usaremos posteriormente:
. /etc/default/vx-dga-variables/vx-dga-variables-general.conf

COMANDO="xrandr | grep -v 'disconnected' | grep -v 'unknow' | grep 'connected'"

if test -f /usr/bin/migasfree-tags ; then
	ETIQUETAS="$(sudo migasfree-tags -g | tr -s '"' ' ')"
	echo "=> Las etiquetas Migasfree del equipo son: ${ETIQUETAS}"
fi

RESOLUCION=""
if ! test -z "$1" ; then
	RESOLUCION="$1"
else
	if ( echo "${ETIQUETAS}" | grep "TUBALCAIN.PCSAULA" &> /dev/null ) ; then
		RESOLUCION="1024x768"
		echo "=> Se va a tratar de imponer a TUBALCAIN.PCSAULA la resolución ${RESOLUCION} ..."
	fi
fi

SALIDAS=$(xrandr \
	| grep -v 'disconnected' | grep -v 'unknow' \
	| grep 'connected' | awk -F" " '{ print $1 }' | tr -s "\n" " ")
while test -z "${SALIDAS}" ; do
	sleep 1
	SALIDAS=$(xrandr \
		| grep -v 'disconnected' | grep -v 'unknow' \
		| grep 'connected' | awk -F" " '{ print $1 }' | tr -s "\n" " ")
done

echo "=> Las salidas a tratar de configurar son: ${SALIDAS}"

if ! test -z "${RESOLUCION}" ; then
	# Mediante la variable MODO nos aseguramos que la resolución deseada es posible imponer
	# Su valor, enc caso de éxito, coincidirá con la resolución deseada:
	# MODO="$(xrandr | grep "1024x768" | awk -F" " '{print $1}')"
	if test $(echo ${SALIDAS} | wc -w) -eq 1 ; then
		MODO="$(xrandr | grep "${RESOLUCION}" | awk -F" " '{print $1}')"
		FRECUENCIA="$(xrandr | grep "${RESOLUCION}" | awk -F" " '{print $2}')"
		echo "=> Modo de Salida a imponer: ${MODO} - ${FRECUENCIA}"
		xrandr --output "${SALIDAS}" --mode "${MODO}" --rate "${FRECUENCIA}"
	fi
	if test $(echo ${SALIDAS} | wc -w) -eq 2 ; then
		# Líneas asociadas a las salidas conectadas:
		LINEAS=$(xrandr | grep -v disconnected | grep -v 'unknow' \
			| grep -n connected | cut -d":" -f1)
		LINEAOUTPUT1=$(echo ${LINEAS} | cut -d" " -f1)
		LINEAOUTPUT2=$(echo ${LINEAS} | cut -d" " -f2)
		echo "=> Información de la Salida 1 (linea ${LINEAOUTPUT1}):"

		xrandr | grep -v disconnected | grep -v 'unknow' \
			| sed -n "$LINEAOUTPUT1,$(expr $LINEAOUTPUT2 - 1)p"
		echo "=> Información de la Salida 2 (linea ${LINEAOUTPUT2}):"
		xrandr | grep -v disconnected | grep -v 'unknow' \
			| sed -n "$LINEAOUTPUT2"',$p'

		MODO1=$(xrandr | grep -v disconnected | grep -v 'unknow' \
			| sed -n "$LINEAOUTPUT1,$(expr $LINEAOUTPUT2 - 1)p" | grep -v connected \
			| grep "${RESOLUCION}" | head -1 | awk -F" " '{print $1}')
		FRECUENCIA1=$(xrandr | grep -v disconnected | grep -v 'unknow' \
			| sed -n "$LINEAOUTPUT1,$(expr $LINEAOUTPUT2 - 1)p" | grep -v connected \
			| grep "${RESOLUCION}" | head -1 | awk -F" " '{print $2}' | tr -s "*" " ")
		MODO2=$(xrandr | grep -v disconnected | grep -v 'unknow' \
			| sed -n "$LINEAOUTPUT2"',$p' | grep -v connected \
			| grep "${RESOLUCION}" | head -1 | awk -F" " '{print $1}')
		FRECUENCIA2=$(xrandr | grep -v disconnected | grep -v 'unknow' \
			| sed -n "$LINEAOUTPUT2"',$p' | grep -v connected \
			| grep "${RESOLUCION}" | head -1 | awk -F" " '{print $2}' | tr -s "*" " ")

		echo "=> Modos de Salida a imponer: ${MODO1} - ${FRECUENCIA1} y ${MODO2} - ${FRECUENCIA2}"
		xrandr \
			--output "$(echo ${SALIDAS} | cut -d" " -f1)" --mode "${MODO1}" --rate "${FRECUENCIA1}" \
			--output "$(echo ${SALIDAS} | cut -d" " -f2)" --mode "${MODO2}" --rate "${FRECUENCIA2}"
	fi
	/usr/bin/inicio-conky
fi
