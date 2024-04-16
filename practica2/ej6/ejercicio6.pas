{6. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}
program ejercicio6practica2;
const
  cantMaquinas = 3;
  valoralto = 9999;
type
  drango = 1..31;
  mrango = 1..12;
  arango = 2000..2030;
  fec = record
    dia:drango;
    mes:mrango;
    anio:arango;
  end;

  registro = record
    cod_usuario:integer;
    fecha:string;//fec;
    tiempo_sesion:real;
  end;
  detalle = file of registro;
  
  //registroMaestro = record
  //  cod_usuario:integer;
  //  fecha:string;//fec;
  //  tiempo_total_de_sesiones_abiertas:integer;
  //end;
  maestro = file of registro;
  
  vectorDetalles = array [1..cantMaquinas] of detalle;
  vectorRegistro = array [1..cantMaquinas] of registro;
  
  procedure importarDetalle(var det:detalle);
  var
    txt:text;
    regd:registro;
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
      read(txt, regd.cod_usuario, regd.tiempo_sesion, regd.fecha); // CHEQUEAR SI FECHA TIENE QUE SER UN REG O UN STRING
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
    for i:= 1 to cantMaquinas do
      importarDetalle(v[i]); // voy cargando los archivos detalle.txt en cada posicion del vector de detalles, ahora en binario
  end;
  
  procedure abrirDetalles(var v:vectorDetalles);
  var
    i:integer;
  begin
    for i:= 1 to cantMaquinas do
      reset(v[i]);
  end;
  
  procedure cerrarDetalles(var v:vectorDetalles);
  var
    i:integer;
  begin
    for i:= 1 to cantMaquinas do
      close(v[i]);
  end;
  
  procedure leer(var det:detalle; var regd:registro);
  begin
    if (not eof(det)) then
      read(det,regd)
    else
      regd.cod_usuario:= valoralto;
  end;
  
  procedure leerDetalles(var v:vectorDetalles; var va:vectorRegistro);
  var
    i:integer;
  begin
    for i:= 1 to cantMaquinas do
      leer(v[i],va[i]);
  end;
  
  procedure minimo(var v:vectorDetalles; var va:vectorRegistro; var min:registro);
  var
    i,posMin:integer;
  begin
    min.cod_usuario:= valoralto;
    min.fecha := 'ZZZZ';
    for i:= 1 to cantMaquinas do begin
      if (va[i].cod_usuario <= min.cod_usuario) then begin
        min:= va[i];
        posMin:= i;
      end;
    end;
    if(min.cod_usuario <> valoralto)then
      leer(v[posMin],va[posMin]);
  end;
  
  procedure informarMaestro(var mae:maestro);
  var
    regm:registro;
  begin
    reset(mae);
    while (not eof(mae)) do begin
      read(mae,regm);
      writeln('Codigo: ',regm.cod_usuario,' Fecha: ', regm.fecha,' Tiempo de sesion: ',regm.tiempo_sesion:0:2);
    end;
    close(mae);
  end;
  
  procedure crearMaestroActualizado(var mae:maestro; var v:vectorDetalles);
  var
    min,actual:registro;
    va:vectorRegistro;
  begin
    //assign(mae, '/var/log/maestro');
    assign(mae, 'maestro');
    rewrite(mae);
    abrirDetalles(v);
    leerDetalles(v,va);
    minimo(v,va,min);
    while (min.cod_usuario <> valoralto) do begin
      actual.cod_usuario := min.cod_usuario;
      while (min.cod_usuario = actual.cod_usuario) do begin
        actual.fecha := min.fecha;
        actual.tiempo_sesion:= 0;
        while (min.cod_usuario = actual.cod_usuario) and (min.fecha = actual.fecha) do begin
          actual.tiempo_sesion:= actual.tiempo_sesion + min.tiempo_sesion;
          minimo(v,va,min);
        end;
        write(mae,actual);
      end;
    end;
    close(mae);
    cerrarDetalles(v);
    writeln('Se creo el archivo maestro');
  end;
var
  mae:maestro;
  vector:vectorDetalles;
begin
  cargarVectorDetalles(vector); // importo el vector de detalles en tipo txt
  crearMaestroActualizado(mae, vector);
  informarMaestro(mae);
end.
