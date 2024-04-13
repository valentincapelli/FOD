{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad}
program ejercicio9practica2;
const
  valorAlto = 9999;
type
  registroMaestro = record
    codigoProvincia:integer;
    codigoLocalidad:integer;
    numeroDeMesa:integer;
    cantVotosMesa:integer;
  end;
  maestro = file of registroMaestro;
  
  procedure leer(var mae:maestro; var regm:registroMaestro);
  begin
    if (not eof(mae))then
      read(mae,regm)
    else
      regm.codigoProvincia:= valorAlto;
  end;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    regm:registroMaestro;
    nombre:string;
  begin
    writeln('Ingrese el nombre del archivo binario maestro');
    readln(nombre);
    assign(mae,nombre);
    rewrite(mae);
    
    writeln('Ingrese el nombre del archivo txt maestro');
    readln(nombre);
    assign(txt,nombre);
    reset(txt);
    
    while (not eof(txt)) do begin
      readln(txt, regm.codigoProvincia, regm.codigoLocalidad, regm.numeroDeMesa, regm.cantVotosMesa);
      write(mae, regm);
    end;
    writeln('La importacion del archivo maestro se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure informarMaestro(var mae:maestro);
  var
    regm,actual:registroMaestro;
    totalVotos,totalProvincia,totalLocalidad:integer;
  begin
    reset(mae);
    regm.numeroDeMesa:= 0;
    leer(mae,regm);
    totalVotos:= 0;
    while(regm.codigoProvincia <> valorAlto) do begin
      actual.codigoProvincia:= regm.codigoProvincia;
      totalProvincia:= 0;
      writeln('Codigo provincia:', actual.codigoProvincia);
      while (regm.codigoProvincia = actual.codigoProvincia) do begin
        actual.codigoLocalidad := regm.codigoLocalidad;
        totalLocalidad:= 0;
        writeln('Codigo Localidad      Total de votos');
        while (regm.codigoLocalidad = actual.codigoLocalidad) and (regm.codigoProvincia = actual.codigoProvincia) do begin
          totalLocalidad:= totalLocalidad + regm.cantVotosMesa;
          leer(mae,regm);
        end;
        totalProvincia:= totalProvincia + totalLocalidad;
        writeln(actual.codigoLocalidad,'                     ',totalLocalidad);
      end;
      totalVotos:= totalVotos + totalProvincia;
      writeln('Total votos provincia: ',totalProvincia);
    end;
    writeln('Total general de votos: ',totalVotos);
    close(mae);
  end;
var
  mae:maestro;
begin
  importarMaestro(mae);
  informarMaestro(mae);
end.
