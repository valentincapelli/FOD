{4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ejercicio4practica2;
const
  valoralto = 'ZZZZ';
type
  str20 = string[20];
  registroMaestro = record
    provincia:str20;
    cantAlfabetizados:integer;
    cantEncuestados:integer;
  end;
  maestro = file of registroMaestro;
  
  registroDetalle = record
    provincia:str20;
    codigoLocalidad:integer;
    cantAlfabetizados:integer;
    cantEncuestados:integer;
  end;
  detalle = file of registroDetalle;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    regm:registroMaestro;
  begin
    rewrite(mae);
    writeln('Realizando importacion del archivo maestro.txt');
    assign(txt,'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, regm.cantEncuestados, regm.cantAlfabetizados, regm.provincia);
      write(mae,regm);
    end;
    writeln('La importacion se realizo con exito');
    close(txt);
    close(mae);
  end;
  
  procedure importarDetalle(var det:detalle; nombre:string);
  var
    txt:text;
    regd:registroDetalle;
  begin
    rewrite(det);
    writeln('Realizando importacion del archivo detalle.txt');
    assign(txt,nombre);
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, regd.cantEncuestados, regd.cantAlfabetizados, regd.codigoLocalidad, regd.provincia);
      write(det,regd);
    end;
    writeln('La importacion se realizo con exito');
    close(txt);
    close(det);
  end;
  
  //procedure actualizarMaestro(var mae:maestro; var det1,det2:detalle);
  //procedure informarMaestro(mae);
var
  mae:maestro;
  det1,det2:detalle;
begin
  assign(mae,'maestro');
  importarMaestro(mae);
  assign(det1,'detalle1');
  importarDetalle(det1,'detalle1.txt');
  assign(det2,'detalle2');
  importarDetalle(det2,'detalle2.txt');
  
  //actualizarMaestro(mae,det1,det2);
  //informarMaestro(mae);
end.
