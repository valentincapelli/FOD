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
  
  procedure leer(var det:detalle; var regd:registroDetalle);
  begin
    if (not eof(det)) then
      read(det,regd)
    else
      regd.provincia:= valoralto;
  end;
  
  procedure minimo(var det1,det2:detalle; var r1,r2,min:registroDetalle);
  begin
    if (r1.provincia <= r2.provincia) then begin
      min:= r1;
      leer(det1,r1);
    end
    else begin
      min:= r2;
      leer(det2,r2);
    end;
  end;
  
  procedure actualizarMaestro(var mae:maestro; var det1,det2:detalle);
  var
    regd1,regd2,min:registroDetalle;
    regm:registroMaestro;
  begin
    reset(det1);
    reset(det2);
    reset(mae);
    regd1.codigoLocalidad:= 0;
    regd2.codigoLocalidad:= 0;
    leer(det1,regd1);
    leer(det2,regd2);
    minimo(det1,det2,regd1,regd2,min);
    while (min.provincia <> valoralto) do begin
      read(mae,regm);
      while (regm.provincia <> min.provincia) do
        read(mae,regm);
      while (regm.provincia = min.provincia) do begin
        regm.cantEncuestados:= regm.cantEncuestados + min.cantEncuestados;
        regm.cantAlfabetizados:= regm.cantAlfabetizados + min.cantAlfabetizados;
        minimo(det1,det2,regd1,regd2,min);
      end;
      seek(mae,filepos(mae)-1);
      write(mae,regm);
    end;
    close(det1);
    close(det2);
    close(mae);
    writeln('El maestro fue actualizado.');
  end;
  
  procedure informarMaestro(var mae:maestro);
  var
    regm:registroMaestro;
  begin
    reset(mae);
    while (not eof(mae)) do begin
      read(mae,regm);
      writeln('Provincia ', regm.provincia, ' Cantidad de personas alfabetizadas ', regm.cantAlfabetizados, ' Total de encuestados ', regm.cantEncuestados);
    end;
    close(mae);
  end;
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
  
  actualizarMaestro(mae,det1,det2);
  informarMaestro(mae);
end.
