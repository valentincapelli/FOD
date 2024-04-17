{13. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}
program ejercicio13practica2;
const
  valoralto = 'ZZZZ';
type
  registroMaestro = record
    destino:string;
    fecha:string;
    hora:string;
    asientosDisponibles:integer;
  end;
  maestro = file of registroMaestro;
  
  registroDetalle = record
    destino:string;
    fecha:string;
    hora:string;
    asientosComprados:integer;
  end;
  detalle = file of registroDetalle;
  
  vuelo = record
    destino:string;
    fecha:string;
    hora:string;
  end;
  
  lista = ^nodo;
  nodo = record
    dato:vuelo;
    sig:lista;
  end;
  
 { procedure cargarRegMaestro(var regm:registroMaestro); //se dispone
  begin
    writeln('Ingrese destino: ');
    readln(regm.destino);
    if (regm.destino <> valoralto) then begin
        writeln('Ingrese fecha: ');readln(regm.fecha);
        writeln('Ingrese hora de salida: ');readln(regm.hora);
        regm.asientosDisponibles:=random(150)+1;
    end;
  end;
  
  procedure cargarArchivoMaestro(var mae:maestro);
  var
    regm:registroMaestro;
  begin
    assign(mae,'maestro');
    rewrite(mae);
    cargarRegMaestro(regm);
    while (regm.destino<>valoralto) do begin
        write(mae,regm);
        cargarRegMaestro(regm);
    end;
    close(mae);
  end;
  
  procedure cargarRegDetalle(var regd:registroDetalle);
  begin
    writeln('Ingrese destino: ');readln(regd.destino);
    if (regd.destino<>valoralto) then begin
        writeln('Ingrese fecha: ');readln(regd.fecha);
        writeln('Ingrese hora de salida: ');readln(regd.hora);
        regd.asientosComprados:=random(20)+1;
    end;
  end;

  procedure cargarArchivoDetalle(var det:detalle);
  var
    regd:registroDetalle;
    name:string;
  begin
    writeln('Ingrese el nombre del archivo binario detalle');
    readln(name);
    assign(det,name);
    rewrite(det);
    cargarRegDetalle(regd);
    while (regd.destino<>valoralto) do begin
        write(det,regd);
        cargarRegDetalle(regd);
    end;
    close(det);
  end; }
  
  procedure importarMaestro(var mae : maestro);
  var
	txt : text;
	regm : registroMaestro;
  begin
	assign(mae, 'maestro');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	while(not eof(txt))do begin
		readln(txt, regm.asientosDisponibles, regm.destino);
		readln(txt, regm.fecha);
		readln(txt, regm.hora);
		write(mae, regM);
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
  end;
  
  procedure importarDetalle(var det : detalle);
  var
	ruta : string;
    txt : text;
    regd : registroDetalle;
  begin
	writeln('Ingrese la ruta del archivo detalle binario');
	readln(ruta);
    assign(det, ruta);
    rewrite(det);
    writeln('Ingrese la ruta del archivo detalle.txt');
	readln(ruta);
    assign(txt, ruta);
    reset(txt);
    while(not eof(txt)) do begin
        readln(txt, regd.asientosComprados, regd.destino);
		readln(txt, regd.fecha);
		readln(txt, regd.hora);
        write(det, regd);
    end;
    writeln('Archivo detalle creado');
    close(det);
    close(txt);
  end;
  
  procedure agregarAdelante(var L:lista ; v:vuelo);
  var
	nue:lista;
  begin
	new(nue);
	nue^.dato:= v;
	nue^.sig:= L;
	L:= nue;
  end;
  
  procedure recorrerLista(L:lista);
  begin
    while (L <> nil) do begin
      writeln(L^.dato.destino,'   ',L^.dato.fecha,'   ',L^.dato.hora);
      L:= L^.sig;
    end;
  end;
  
  procedure leer(var det:detalle; var regd:registroDetalle);
  begin
    if (not eof(det)) then
      read(det,regd)
    else
      regd.destino:= valoralto;
  end;
  
  procedure minimo(var det1,det2:detalle; var r1,r2,min:registroDetalle);
  begin
    if (r1.destino < r2.destino) then begin
      min:= r1;
      leer(det1,r1);
    end
    else begin
      min:= r2;
      leer(det2,r2);
    end;
  end;
  
  procedure actualizarMaestroYGenerarLista(var mae:maestro; var det1,det2:detalle; var L:lista);
  var
    regm:registroMaestro;
    regd1,regd2,min:registroDetalle;
    v:vuelo;
    cantidad:integer;
  begin
    writeln('Ingrese una cantidad de asientos disponibles ');
	readln(cantidad);
    reset(mae);
    reset(det1);
    reset(det2);
    read(mae,regm);
    leer(det1,regd1);
    leer(det2,regd2);
    minimo(det1,det2,regd1,regd2,min);
    while (min.destino <> valoralto) do begin
        read(mae,regm);
        while (regm.destino <> min.destino) do
            read(mae,regm);
		while (regm.destino = min.destino) do begin
			while (regm.fecha <> min.fecha) do
				read(mae,regm);
		    while (regm.destino = min.destino) and (regm.fecha = min.fecha) do begin
				while (regm.hora <> min.hora) do
		            read(mae,regm);
		        writeln('Ingrese una cantidad de asientos disponibles ');
		        while ((min.destino = regm.destino) and (regm.fecha = min.fecha) and (regm.hora = min.hora)) do begin
		            regm.asientosDisponibles:= regm.asientosDisponibles - min.asientosComprados;
					minimo(det1,det2,regd1,regd2,min);
		        end;
		        if (regm.asientosDisponibles < cantidad) then begin
		          v.destino:= regm.destino;
		          v.fecha:= regm.fecha;
		          v.hora:= regm.hora;
		          agregarAdelante(L,v);
		        end;
		        seek(mae,filepos(mae)-1);
		        write(mae,regm);
		    end;
		end;
    end;
    close(mae);
    close(det1);
    close(det2);
  end;
  {procedure actualizarMaestroYGenerarLista(var mae:maestro; var det:detalle; var L:lista);
  var
    regm:registroMaestro;
    regd:registroDetalle;
    v:vuelo;
  begin
    reset(mae);
    reset(det);
    leer(det,regd);
    while (regd.destino <> valoralto) do begin
      read(mae,actual);
      while (actual.destino <> regd.destino) do begin
        read(mae,actual);
      end;
      while (actual.destino = regd.destino) do begin
        
      end;
    end;
  end;}
  
var
  mae:maestro;
  det1,det2:detalle;
  L: lista;
begin
  L:= nil;
  //cargarArchivoMaestro(mae); // se dispone
  //cargarArchivoDetalle(det1);  // se dispone
  //cargarArchivoDetalle(det2);  // se dispone
  importarMaestro(mae);
  importarDetalle(det1);
  importarDetalle(det2);
  actualizarMaestroYGenerarLista(mae,det1,det2,L);
  recorrerLista(L);
end.
