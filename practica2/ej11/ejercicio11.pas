{11. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idusuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idusuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idusuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idusuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}

program ejercicio11practica2;
const
  valorAlto = 9999;
type
  registroMaestro = record
	anio:integer;
	mes:integer;
	dia:integer;
	idUsuario:integer;
	tiempoDeAcceso:real;
  end;
  maestro = file of registroMaestro;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    regm:registroMaestro;
    //nombre:string;
  begin
    //writeln('Ingrese el nombre del archivo binario maestro');
    //readln(nombre);
    //assign(mae,nombre);
    assign(mae,'maestro');
    rewrite(mae);
    
    //writeln('Ingrese el nombre del archivo txt maestro');
    //readln(nombre);
    //assign(txt,nombre);
    assign(txt,'maestro.txt');
    reset(txt);
    
    while (not eof(txt)) do begin
      readln(txt, regm.anio, regm.mes, regm.dia, regm.idUsuario, regm.tiempoDeAcceso);
      write(mae, regm);
    end;
    writeln('La importacion del archivo maestro se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure ingresarAnio(var anio:integer);
  begin
    writeln('Ingrese un año para realizar un informe.');
    readln(anio);
  end;
  
  procedure leer(var mae:maestro; var regm:registroMaestro);
  begin
    if (not eof(mae)) then
      read(mae,regm)
    else
      regm.anio:= valorAlto;
  end;
  
  procedure informarMaestro(var mae:maestro; anio:integer);
  var
    regm,actual:registroMaestro;
    existe:boolean;
    totalAnio,totalMes,totalDia,totalUsuario:real;
  begin
    reset(mae);
    existe:= false;
    while (existe = false) do begin
      ingresarAnio(anio);
	  leer(mae,regm);
      while (regm.anio <> valorAlto) and (regm.anio <> anio) do
        leer(mae,regm);
      if (regm.anio <> anio) then
        writeln('Ese año no se encuentra en el archivo.Ingrese uno nuevo.')
      else
        existe:= true;
    end;
    
    writeln('Año:',anio);
    totalAnio:= 0;
    while (regm.anio = anio) do begin
      actual.mes:= regm.mes;
      totalMes:= 0;
      writeln('Mes:',actual.mes);
      while (regm.mes = actual.mes) do begin
        actual.dia:= regm.dia;
        totalDia:= 0;
        writeln('Dia:',actual.dia);
        while (regm.dia = actual.dia) do begin
          actual.idUsuario:= regm.idUsuario;
          totalUsuario:= 0;
          write('Id Usuario:',actual.idUsuario);
          while (regm.idUsuario = actual.idUsuario) do begin
            totalUsuario:= totalUsuario + regm.tiempoDeAcceso;
            leer(mae,regm);
          end;
          writeln(' tiempo total de acceso en el dia ',actual.dia,' mes ',actual.mes);
          writeln(totalUsuario:0:2,' minutos.');
          totalDia:= totalDia + totalUsuario;
        end;
        writeln('Tiempo total acceso dia ',actual.dia,' mes ',actual.mes);
        writeln(totalDia:0:2,' minutos.');
        totalMes:= totalMes + totalDia;
      end;
      writeln('Total tiempo de acceso mes ',actual.mes);
      writeln(totalMes:0:2,' minutos.');
      totalAnio:= totalAnio + totalMes;
    end;
    writeln('Total tiempo de acceso año ',anio);
    writeln(totalAnio:0:2,' minutos.');
    close(mae);
  end;
  
var
  mae:maestro;
  anio:integer;
begin
  anio:= 0;
  importarMaestro(mae);
  informarMaestro(mae,anio);
end.
