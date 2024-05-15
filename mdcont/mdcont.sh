#!/bin/bash

redColour="\e[0;31m\033[1m"
endColour="\033[0m\e[0m"

echo "
 __  __ ____   ____ ___  _   _ _____ 
|  \/  |  _ \ / ___/ _ \| \ | |_   _|
| |\/| | | | | |  | | | |  \| | | |  
| |  | | |_| | |__| |_| | |\  | | |  
|_|  |_|____/ \____\___/|_| \_| |_|  
                              
"

function panel(){
echo -e "\n\tPanel de ayuda\n"
echo -e "\tQué desea realizar?"
echo -e "\t1) Crear la carptea segura para las contraseña"
echo -e "\t2) Generar una contraseña"
echo -e "\t3) Buscar una contraseña"
}


# ------ exit of program
function salir(){
echo -e "\n\n ${redColour}[!] saliendo del programa...\n${endColour}"
tput cnorm && exit 1
sleep 5
}
# ------ end exit of program

function crear_archivo(){
	echo -e "\t\nEstamos creando una carpeta segura\n"
	sudo mkdir .cont
	echo -e "\nLa carpeta se ha creado de foma oculta con el nombre .cont\n"
	echo -e "\nCreando el archivo que va a contener las contraseñas\n"
	sleep 10
	sudo touch .cont/.mdcont.txt
	echo -e "\t\nLos archivos se han creado con éxito ejecuta el parametro -2 para empezar a generar las contraseñas\n"
}

# ----- Generar la contraseña
# Función para generar una contraseña aleatoria
generate_password() {
    local length=$1
    local use_uppercase=$2
    local use_numbers=$3
    local use_special_chars=$4

    # Caracteres disponibles para generar la contraseña
    local charset='abcdefghijklmnopqrstuvwxyz'
    local uppercase_charset='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local numbers_charset='0123456789'
    local special_charset='!@#$%^&*;><()-_=+{}[]/\\`\"'

    # Variable para almacenar la contraseña
    local password=''

    # Concatenar caracteres según las especificaciones
    charset+=$uppercase_charset
    if [ "$use_numbers" = "true" ]; then
        charset+=$numbers_charset
    fi
    if [ "$use_special_chars" = "true" ]; then
        charset+=$special_charset
    fi

    # Generar la contraseña
    for (( i=0; i<$length; i++ )); do
        rand_index=$(( $RANDOM % ${#charset} ))
        password+="${charset:$rand_index:1}"
    done

    echo "$password"
}

# Función principal
cont() {
    echo -e "\nGenerador de contraseñas aleatorias\n"
    echo -e "Ingrese las especificaciones de la contraseña\n"

    # Pedir la longitud de la contraseña
    read -p "Longitud de la contraseña: " length
    echo ""
    # Pedir si se usarán letras mayúsculas
    read -p "¿Incluir letras mayúsculas? (s/n): " use_uppercase
    if [[ "$use_uppercase" == "s" || "$use_uppercase" == "S" ]]; then
        use_uppercase="true"
    else
        use_uppercase="false"
    fi
    echo ""
    # Pedir si se usarán números
    read -p "¿Incluir números? (s/n): " use_numbers
    if [[ "$use_numbers" == "s" || "$use_numbers" == "S" ]]; then
        use_numbers="true"
    else
        use_numbers="false"
    fi
    echo ""
    # Pedir si se usarán caracteres especiales
    read -p "¿Incluir caracteres especiales? (s/n): " use_special_chars
    if [[ "$use_special_chars" == "s" || "$use_special_chars" == "S" ]]; then
        use_special_chars="true"
    else
        use_special_chars="false"
    fi

    # Generar la contraseña
    password=$(generate_password $length $use_uppercase $use_numbers $use_special_chars)

    echo -e "\nLa contraseña generada es: $password\n"
    
    read -p "Coloca \"s\" para asignar y guardar esta contraseña \"n\" para salir: " savecont
    echo ""
    if [[ $savecont == "s" || $savecont == "S" ]]; then
    read -p "Nombre de la plataforma para esta contraseña: " plataforma
    echo ""
    read -p "nombre de usuario: " usuario
    echo ""
    read -p "Correo asociado: " correo
    echo ""
    read -p "Fecha de hoy: " fecha
    echo ""
    echo "Moviendo tus datos al archivo de contraseñas"
    # Directorio a buscar
    directorio=$(pwd)

    # Nombre del archivo que se busca (patrón de búsqueda)
    patronArchivo="*.mdcont.txt"

    # Buscar el último archivo modificado y asignarlo a la variable "ultimoArchivo"
    ultimoArchivo=$(find "$directorio" -type f -name "$patronArchivo" -mtime -1 | sort | tail -n 1)

    # Imprimir la ruta del último archivo encontrado
    echo -e "\t\nLa nueva contraseñas se guardo con éxito\n"
    echo -e "\n>>>>>>>>>>\n Nombre de la plataforma: $plataforma \n Nombre de usuario: $usuario \n Nombre del correo: $correo \n Contraseña creada: $password \n Fecha de cración: $fecha" >> "$ultimoArchivo"
    else
    salir
    fi
}

# ----- fin de la generacion

# ----- Buscar contraseña
function buscar(){
	read -p "Introduce el nombre de la plataforma: " buscar
	echo ""
	cat .cont/.mdcont.txt | grep "$buscar" -A5
}

# ----- fin de buscar

declare -i contador=0

while getopts "1234" argument; do
	case $argument in
	1) let contador+=1;;
	2) let contador+=2;;
	3) let contador+=3;;
	4) ;;
	esac
done

if [ $contador -eq 1 ]; then
	crear_archivo
elif [ $contador -eq 2 ]; then
	cont
elif [ $contador -eq 3 ]; then
	buscar
else
	panel
fi
