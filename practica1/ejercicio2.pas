{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program ejercicio2practica1;
type
  archivo_enteros = file of integer;
var
  enteros: archivo_enteros;
  nombre_fisico: string[12];
  num:integer;
  menoresa1500:integer;
  cantnumeros:integer;
  sumanumeros:integer;
begin
  reset(enteros);
  write('Ingrese el nombre del archivo a procesar: ');
  read(nombre_fisico);
  assign(enteros, nombre_fisico);
  
  menoresa1500:= 0;
  cantnumeros:= 0;
  sumanumeros:= 0;
  while not(eof(enteros))do begin
    read(num);
    if (num < 1500) then
      menoresa1500:= menoresa1500 + 1;
    cantnumeros:= cantnumeros + 1;
    sumanumeros:= sumanumeros + num;
    write(num, ', ');
  end;
  writeln('');
end.



