{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}

program ejercicio1practica3;
type
  str12 = string[12];
  empleado = record
    nro:integer;
    ape:str12;
    nom:str12;
    age:integer;
    DNI:integer;
  end;
  archivo_empleados = file of empleado;
  
{Procedimientos y funciones}
  
  procedure leerEmpleado(var emp:empleado);
  begin
    writeln('Ingrese el numero de empleado');
    readln(emp.nro);
    writeln('Ingrese el apellido');
    readln(emp.ape);
    if (emp.ape <> 'fin') then begin
      writeln('Ingrese el nombre');
      readln(emp.nom);
      writeln('Ingrese la edad');
      readln(emp.age);
      writeln('Ingrese el DNI');
      readln(emp.DNI);
    end;
  end;
  
  procedure crearArchivo(var empleados:archivo_empleados);
  var
    emp:empleado;
  begin
    leerEmpleado(emp);
    while (emp.ape <> 'fin') do begin
      write(empleados,emp);
      leerEmpleado(emp);
    end;
  end;
  
 { b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.}

  procedure listar(emp:empleado);
  begin
    writeln('Informacion sobre: ', emp.ape,' ',emp.nom);
    writeln('Numero de empleado: ',emp.nro, ' Edad: ',emp.age,' DNI: ',emp.dni);
    writeln('------------------------------------------------------------------------');
  end;
  
  procedure listarnomape(var empleados:archivo_empleados);
  var
    nomape:str12;
    i:integer;
    emp:empleado;
  begin
    writeln('Ingrese un nombre o apellido que desea buscar');
    readln(nomape);
    for i:= 1 to fileSize(empleados) do begin
      read(empleados,emp);
      if (nomape = emp.nom) or (nomape = emp.ape) then
        listar(emp);
    end;  
  end;
  
  procedure listardeauno(var empleados:archivo_empleados);
  var
    i:integer;
    emp:empleado;
  begin
    for i:= 1 to fileSize(empleados) do begin
      read(empleados,emp);
      listar(emp);
    end;
  end;
  
  procedure listarmayoresa70(var empleados:archivo_empleados);
  var
    i:integer;
    emp:empleado;
  begin
    for i:= 1 to fileSize(empleados) do begin
      read(empleados,emp);
      if (emp.age > 70) then
        listar(emp);
    end;
  end;
  
  {a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).}
  
  function chequearEmpleado(var empleados:archivo_empleados;  nro:integer):boolean;
  var
    emp:empleado;
    encontre:boolean;
  begin
    encontre:= true;
    while not eof(empleados) do begin
      read(empleados,emp);
      if (emp.nro = nro) then
        encontre:= false;
    end;
    chequearEmpleado:= encontre;
  end;
  
  procedure agregarEmpleado(var empleados:archivo_empleados);
  var
    emp:empleado;
    cant,i:integer;
  begin
    writeln('Cuantos empleados quiere agregar?');
    readln(cant);
    for i:= 1 to cant do begin
      leerEmpleado(emp);
      if (chequearEmpleado(empleados,emp.nro)) then begin
        seek(empleados,fileSize(empleados));
        write(empleados,emp);
      end
      else
        writeln('El numero del empleado que ingresaste ya esta cargado');
    end;
  end;
  
  {b. Modificar la edad de un empleado dado.}
  
  procedure modificarEdad(var empleados:archivo_empleados);
  var
    nro,edad:integer;
    emp:empleado;
    encontre:boolean;
  begin
    writeln('Ingrese el numero de empleado que quiere modificarle la edad');
    readln(nro);
    encontre:= false;
    while not eof(empleados) and encontre = false do begin
      read(empleados,emp);
      if (emp.nro = nro) then 
        encontre:= true;
        writeln('Ingrese la nueva edad que quiere asignarle');
        readln(edad);
        emp.age:= edad;
        seek(empleados, filepos(empleados)-1);
        write(empleados,emp);
    end;
    if encontre = false then
      writeln('Ingresaste un numero de empleado que no existe');
  end;
  
  {c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.}

  procedure exportarContenido(var empleados:archivo_empleados);
  var
    txt:text; //archivo de texto
    emp:empleado;
  begin
    assign(txt,'todos_empleados.txt');
    rewrite(txt); //crea el archivo de texto
    while not eof(empleados) do begin
      read(empleados,emp);//lee empleado del archivo binario
      writeln(txt,emp.nro,' ',emp.age,' ',emp.DNI,' ',emp.ape,' ',emp.nom);
    end;
    close(txt);
  end;
  
  {d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).}
  
  procedure exportarDNIempleados(var empleados:archivo_empleados);
  var
    txt:text; //archivo de texto
    emp:empleado;
  begin
    assign(txt, 'faltaDNIEmpleado.txt');
    rewrite(txt);
    while not eof(empleados) do begin
      read(empleados,emp);//lee empleado del archivo binario
      if (emp.DNI = 00) then
        writeln(txt,emp.nro,' ',emp.age,' ',emp.DNI,' ',emp.ape,' ',emp.nom);
    end;
    close(txt);
  end;
  
  procedure borrarUnRegistro(var empleados:archivo_empleados);
  var
    numero,pos:integer;
    emp:empleado;
    encontre:boolean;
  begin
    writeln('Ingrese el numero de empleado');
    readln(numero);
    encontre:= false;
    while (not eof(empleados)) do begin
      read(empleados,emp);
      if (emp.nro = numero) then
        encontre:= true;
        pos:= filepos(empleados);
    end;
    if (encontre) then begin
      seek(empleados,filesize(empleados)-1);
      read(empleados,emp);
      seek(empleados,pos-1);
      write(empleados,emp);
      seek(empleados,filesize(empleados)-1);
      truncate(empleados);
      writeln('Se ha eliminado el empleado.');
    end
    else
      writeln('El empleado ingresado no existe.');
  end;
  
  procedure interactArchivo(var empleados:archivo_empleados);
  var
    opcion: char;
  begin
    opcion:= '0';
    while (opcion <> '9') do begin
      writeln('Ingrese 1 si desea ver los datos de los empleados que usted decida');
      writeln('Ingrese 2 si desea ver los datos de los empleados de a uno por linea');
      writeln('Ingrese 3 si desea ver los datos de los empleados mayores a 70 años');
      writeln('Ingrese 4 si desea agregar empleados al archivo');
      writeln('Ingrese 5 si desea modificar la edad de un empleado dado');
      writeln('Ingrese 6 si desea exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt');
      writeln('Ingrese 7 si desea exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI');
      writeln('Ingrese 8 si desea realizar una baja.');
      writeln('Ingrese 9 si desea volver al menu principal');
      readln(opcion);
      reset(empleados);
      case opcion of
        '1': listarnomape(empleados);
        '2': listardeauno(empleados);
        '3': listarmayoresa70(empleados);
        '4': agregarEmpleado(empleados);
        '5': modificarEdad(empleados);
        '6': exportarContenido(empleados);
        '7': exportarDNIempleados(empleados);
        '8': borrarUnRegistro(empleados);
      end;
      close(empleados);
    end;
  end;

{Fin de procedimientos y funciones}
var
  empleados: archivo_empleados;
  nombre_fisico: str12;
  opcion:char;
begin
  repeat
    writeln('Ingrese A si desea crear un archivo de empleados');
    writeln('Ingrese B si desea interactuar con un archivo');
    writeln('Ingrese C si desea cerrar el menu');
    readln(opcion);
    if (opcion = 'A')then begin
      write('Ingrese el nombre del archivo a crear: ');
      read(nombre_fisico);
      assign(empleados, nombre_fisico);
      rewrite(empleados);
      crearArchivo(empleados);
      close(empleados);
    end
    else
      if (opcion = 'B') then begin
        write('Ingrese el nombre del archivo a interactuar: ');
        read(nombre_fisico);
        assign(empleados, nombre_fisico);
        interactArchivo(empleados);
      end;
  until (opcion = 'C');
end.
