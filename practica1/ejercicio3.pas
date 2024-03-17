{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program ejercicio3practica1;
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
    writeln('Numero de empleado; ',emp.nro, ' Edad: ',emp.age,' DNI: ',emp.dni);
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

  procedure interactArchivo(var empleados:archivo_empleados);
  var
    opcion: char;
  begin
    repeat 
      writeln('Ingrese 1 si desea ver los datos de los empleados que usted decida');
      writeln('Ingrese 2 si desea ver los datos de los empleados de a uno por linea');
      writeln('Ingrese 3 si desea ver los datos de los empleados mayores a 70 años');
      writeln('Ingrese 4 si desea volver al menu principal');
      readln(opcion);
      reset(empleados);
      case opcion of
        '1': listarnomape(empleados);
        '2': listardeauno(empleados);
        '3': listarmayoresa70(empleados);
      end;
      close(empleados);
    until opcion = '4';
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
