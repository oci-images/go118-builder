# -*- coding: utf-8 -*-
import pathlib
import os
import sys
import itertools

#guarda todos los argumentos de entrada en un diccionario para su uso dentro del programa
args_iter = iter(sys.argv[1:])
diccionario_args = dict(itertools.zip_longest(args_iter, args_iter, fillvalue = None))
print(diccionario_args)

#crea el directorio y archivo Dockerfile
args_app = ""
directory="docker-image"
pathlib.Path(directory).mkdir(parents=True, exist_ok=True)
file="docker-image/Dockerfile"
print("archivo Dockerfile creado...")

if  diccionario_args.__contains__("-app"):
    #abre el archivo en modo escritura para su uso
    f = open(file, 'wb')
    print("abre archivo...")
    #comienza a escribir el archivo con los parametros de entrada
    if diccionario_args.__contains__("-i") and ((diccionario_args["-i"]) != ""):
        print((diccionario_args["-i"]).isnumeric())
        line = "FROM {-i}:latest\nWORKDIR /local/bin/\nVOLUME /go/src/apigolang\n".format(**diccionario_args)
        f.write(line.encode())
    else:
        f.write("FROM registry.access.redhat.com/ubi8/ubi-minimal:latest\nWORKDIR /local/bin/\nVOLUME /go/src/apigolang\n".encode())

    line = "COPY /go/src/bin/{-app} /local/bin/\nRUN chmod +x /local/bin/{-app}\n".format(**diccionario_args)
    f.write(line.encode())

    if  diccionario_args.__contains__("-p") and (diccionario_args["-p"]).isnumeric():
        line = "EXPOSE {-p}\n".format(**diccionario_args)
        f.write(line.encode())

    if diccionario_args.__contains__("-args"):
        args_app = '"' + diccionario_args["-app"] + '" '
        lista_args = diccionario_args["-args"].split("-")
        for args in lista_args:
            if args != "": args_app += ', "-' + args + '"'

        f.write(f'ENTRYPOINT [ {args_app} ]\n'.encode())
    else:
        line = 'ENTRYPOINT [ "{-app}" ]\n'.format(**diccionario_args)
        f.write(line.encode())

    f.close()
    print("fin de creacion de archivo...")
else:
    print("ERROR - El argumento -app es obligatorio")
