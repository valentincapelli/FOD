{1. Archivos Secuenciales
Suponga que tiene un archivo con información referente a los empleados que trabajan en una multinacional.
De cada empleado se conoce el dni (único), nombre, apellido, edad, domicilio y fecha de nacimiento.
Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de espacio 
llamada lista invertida.

Declare las estructuras de datos necesarias e implemente los siguientes módulos:
Agregar empleado: solicita al usuario que ingrese los datos del empleado y lo agrega al archivo sólo si
el dni ingresado no existe. Suponga que existe una función llamada existeEmpleado que recibe un dni y un 
archivo y devuelve verdadero si el dni existe en el archivo o falso en caso contrario. La función 
existe Empleado no debe implementarla. Si el empleado ya existe, debe informarlo en pantalla.
Quitar empleado: solicita al usuario que ingrese un dni y lo elimina del archivo solo si este dni existe.
Debe utilizar la función existeEmpleado. En caso de que el empleado no exista debe informarse en pantalla.
Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo cambio que se produzca en 
el archivo.}

program parcial2023;
type
    registroEmpleado = record
        dni:integer;
        nombre:string[30];
        apellido:string[30];
        edad:integer;
        domicilio:string[30];
        fecha:string[20];
    end;
    archivoEmpleados = file of registroEmpleado;

    procedure agregarEmpleado(var arch:archivoEmpleados);
    var
        e:registroEmpleado;
    begin
        ingresarEmpleado(e);
        if (not existeEmpleado(arch,e.dni)) then
            reset(arch);
            read(arch,aux);
            if (aux.codigo < 0) then begin
                seek(arch, aux.codigo*(-1));
                read(arch,aux);
                seek(arch, filepos(arch)-1);
                write(arch,e);
                seek(arch,0);
                write(arch,aux); 
            end
            else begin
                seek(arch,filesize(arch));
                write(arch,n);
            end;
            close(arch);
            writeln('El empleado fue registrado.');
        end
        else writeln('El empleado ya existe.');
    end;

    procedure quitarEmpleado(var arch:archivoEmpleados);
    var
        dni:integer;
        newHead, oldHead, aux:empleado;
    begin
        ingreseDNI(dni);
        if (existeEmpleado(arch,dni)) then begin
            reset(arch);
            read(arch, oldHead);
            while (not eof(arch)) and (aux.dni <> dni) do
                read(arch,aux);
            if (aux.dni = dni) then begin
                seek(arch,filepos(arch)-1);
                newHead.dni:= (filepos(arch)*-1)
                write(arch,oldHead);
                seek(arch,0);
                write(arch,newHead);
                writeln('El empleado fue borrado.');
            end;
            close(arch);
        end
        else writeln('El empleado no existe.');
    end;

var
begin
end.