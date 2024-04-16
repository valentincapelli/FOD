{7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}
program ejercicio7practica2;
const
  cantDetalles = 1;
  valorAltoInt = 9999;
  valorAltoStr = 'ZZZZ';
type
  registroDetalle = record
    codigoLocalidad:integer;
    codigoCepa:integer;
    casosActivos:integer;
    casosNuevos:integer;
    recuperados:integer;
    fallecidos:integer;
  end;
  detalle = file of registroDetalle;
  
  vectorDetalles = array [1..cantDetalles] of detalle;
  vectorRegistroDetalle = array [1..cantDetalles] of registroDetalle;
  
  registroMaestro = record
    codigoLocalidad:integer;
    nombreLocalidad:string;
    codigoCepa:integer;
    nombreCepa:string;
    casosActivos:integer;
    casosNuevos:integer;
    recuperados:integer;
    fallecidos:integer;
  end;
  maestro = file of registroMaestro;
  
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
      readln(txt, regm.codigoLocalidad, regm.codigoCepa, regm.casosActivos, regm.casosNuevos, regm.recuperados, regm.fallecidos, regm.nombreCepa);
	  readln(txt, regm.nombreLocalidad);
      write(mae, regm);
      writeln('Escribi');
    end;
    writeln('La importacion del archivo maestro se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure importarDetalle(var det:detalle);
  var
    txt:text;
    regd:registroDetalle;
    nombre:string;
  begin
    writeln('Ingrese el nombre del archivo binario detalle');
    readln(nombre);
    assign(det,nombre);
    rewrite(det);
    
    writeln('Ingrese el nombre del archivo txt detalle');
    readln(nombre);
    assign(txt,nombre);
    reset(txt);
  
    
    while (not eof(txt)) do begin
      readln(txt, regd.codigoLocalidad, regd.codigoCepa, regd.casosActivos, regd.casosNuevos, regd.recuperados, regd.fallecidos); 
      write(det, regd);
      writeln('Escribi');
    end;
    writeln('La importacion del archivo detalle se realizo con exito');
    close(det);
    close(txt);
  end;
  
  procedure cargarVectorDetalles(var v:vectorDetalles);
  var
    i:integer;
  begin
    for i:= 1 to cantDetalles do
      importarDetalle(v[i]);
  end;
  
  procedure abrirDetalles(var v:vectorDetalles);
  var
    i:integer;
  begin
    for i:= 1 to cantDetalles do
      reset(v[i]);
  end;
  
  procedure cerrarDetalles(var v:vectorDetalles);
  var
    i:integer;
  begin
    for i:= 1 to cantDetalles do
      close(v[i]);
  end;
  
  procedure leer(var det:detalle; var regd:registroDetalle);
  begin
    if (not eof(det)) then
      read(det,regd)
    else
      regd.codigoLocalidad:= valoraltoInt;
  end;
  
  procedure leerDetalles(var vd:vectorDetalles; var vrd:vectorRegistroDetalle);
  var
    i:integer;
  begin
    for i:= 1 to cantDetalles do
      leer(vd[i],vrd[i]);
  end;
  
  procedure minimo(var vd:vectorDetalles; var vrd:vectorRegistroDetalle; var min:registroDetalle);
  var
    i,posMin:integer;
  begin
    min.codigoLocalidad := valorAltoInt;
    min.codigoCepa := valorAltoInt;
    for i:= 1 to cantDetalles do begin
      if (vrd[i].codigoLocalidad <= min.codigoLocalidad) and (vrd[i].codigoCepa <= min.codigoCepa) then begin
        min:= vrd[i];
        posMin:= i;
      end;
    end;
    if(min.codigoLocalidad <> valorAltoInt)then
      leer(vd[posMin],vrd[posMin]);
  end;
  
  procedure actualizarMaestro(var mae:maestro; var vd:vectorDetalles);
  var
    actual:registroMaestro;
    vrd:vectorRegistroDetalle;
    min:registroDetalle;
  begin
    reset(mae);
    abrirDetalles(vd);
    leerDetalles(vd,vrd);
    minimo(vd,vrd,min);
    read(mae,actual);
    while (min.codigoLocalidad <> valorAltoInt) do begin
      while (min.codigoLocalidad <> actual.codigoLocalidad) do
        read(mae,actual); // si sale de este loop es porque las localidades son iguales
      while (min.codigoLocalidad <> valorAltoInt) and (actual.codigoLocalidad = min.codigoLocalidad) do begin
        while (actual.codigoCepa <> min.codigoCepa) do
          read(mae,actual); //busco la cepa igual
        while (min.codigoLocalidad <> valorAltoInt) and (actual.codigoLocalidad = min.codigoLocalidad) do begin
          actual.casosActivos:= min.casosActivos;
          actual.casosNuevos:= min.casosNuevos;
          actual.recuperados:= actual.recuperados + min.recuperados;
          actual.fallecidos:= actual.fallecidos + min.fallecidos;
          minimo(vd,vrd,min);
        end;
        seek(mae,filepos(mae)-1);
        write(mae,actual);
      end;
    end;
    writeln('El archivo maestro fue actualizado.');
    close(mae);
    cerrarDetalles(vd);
  end;
  
  procedure informarMaestro(var mae:maestro);
  var
    regm:registroMaestro;
    cantLocalidades:integer;
  begin
    reset(mae);
    cantLocalidades:= 0;
    while (not eof(mae)) do begin
      read(mae,regm);
      writeln('Nombre localidad: ', regm.nombreLocalidad,' Codigo localidad: ',regm.codigoLocalidad,' Nombre cepa: ',regm.nombreCepa,' Codigo cepa:',regm.codigoCepa);
      writeln('Casos activos:',regm.casosActivos,' Casos nuevos: ',regm.casosNuevos,' Recuperados:', regm.recuperados,' Fallecidos: ',regm.fallecidos);
      if (regm.casosActivos > 50) then
        cantLocalidades:= cantLocalidades + 1;
    end;
    writeln('La cantidad de localidades con mas de 50 casos activos son: ', cantLocalidades);
    close(mae);
  end;
  
var
  mae:maestro;
  vd:vectorDetalles;
begin
  importarMaestro(mae);
  cargarVectorDetalles(vd);
  actualizarMaestro(mae,vd);
  informarMaestro(mae);
end.
// Anda mal el informe del maestro. Me imprime caracteres raros. La cantidad de localidades con mas de 50 casos imprime bien.
