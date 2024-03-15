{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.}

program ejercicio1practica1;
type
  archivo_enteros = file of integer;
var
  enteros: archivo_enteros;
  nombre_fisico: string[12];
  num:integer;
begin
  write('Ingrese el nombre del archivo: ');
  readln(nombre_fisico);
  assign(enteros, nombre_fisico); {enlace entre el nombre logico y el nombre fisico}
  
  rewrite(enteros); {apertura de archivo para creacion}
  
  writeln('Ingrese un numero entero');
  readln(num);
  while (num <> 3000) do begin
    write(enteros,num); {escritura del entero en el archivo}
    writeln('Ingrese un numero entero');
    readln(num);
  end;
  close(enteros); {cierre del archivo}
end.
