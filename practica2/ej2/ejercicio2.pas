{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}
program ejercicio2practica1;
const
  valoralto = 9999;
type
  str12 = string[12];
  alumno = record
    codigo:integer;
    nomape:string;
    cursadasAprobadas:integer;
    materiasAprobadas:integer;
  end;
  maestro = file of alumno;
  
  info = record
    codigo:integer;
    aprobo:integer; {1 aprobo cursada, 2 aprobo materia}
  end;
  detalle = file of info;
  
  procedure importarMaestro(var mae:maestro);
  var
    a:alumno;
    txt:text;
  begin
    assign(mae, 'maestro');
    rewrite(mae); {creo el archivo binario}
    writeln('Realizando importacion de archivo maestro.txt');
    assign(txt, 'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, a.codigo, a.cursadasAprobadas, a.materiasAprobadas, a.nomape);
      write(mae, a);
    end;
    writeln('La importacion se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure importarDetalle(var det:detalle);
  var
    i:info;
    txt:text;
  begin
    assign(det, 'detalle');
    rewrite(det); {creo el archivo binario}
    writeln('Realizando importacion de archivo detalle.txt');
    assign(txt, 'detalle.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, i.codigo, i.aprobo);
      write(det, i);
    end;
    writeln('La importacion se realizo con exito');
    close(det);
    close(txt);
  end;
  
  procedure leer(var det:detalle; var i:info);
  begin
    if (not eof(det)) then
      read(det,i)
    else
      i.codigo:= valoralto;
  end;
  
  procedure actualizarEstado(var mae:maestro; var det:detalle);
  var
    regd:info;
    regm:alumno;
    codigoAct,cantAprobadas,cantCursadas:integer;
  begin
    reset(mae);
    reset(det);
    regd.codigo := 0; // si no lo hago no me compilaba nose porque
    leer(det,regd); // leo el detalle
    read(mae,regm); // leo el maestro
    while (regd.codigo <> valoralto) do begin
      codigoAct:= regd.codigo;
      cantCursadas:= 0;
      cantAprobadas:= 0;
      while (regd.codigo = codigoAct) do begin
        if (regd.aprobo = 1) then
          cantCursadas:= cantCursadas + 1
        else
          cantAprobadas:= cantAprobadas + 1;
        leer(det,regd);
      end;
      while (regm.codigo <> codigoAct) do
        read(mae,regm);
      // se modifican el estado de las materias
      regm.cursadasAprobadas:= regm.cursadasAprobadas + cantCursadas;
      regm.cursadasAprobadas:= regm.cursadasAprobadas - cantAprobadas;
      regm.materiasAprobadas:= regm.materiasAprobadas + cantAprobadas;
      writeln('Fue modificado un alumno');
      seek(mae, filepos(mae)-1); // se reubica el puntero del maestro
      write(mae,regm);
      if (not eof(mae)) then
        read(mae,regm);
    end;
    close(det);
    close(mae);
  end;
  
  procedure listarAlumnosConMasFinales(var mae:maestro);
  var
    a:alumno;
  begin
    reset(mae);
    while (not eof(mae)) do begin
      read(mae,a);
      writeln('Codigo ',a.codigo,' Cursadas aprobadas: ',a.cursadasAprobadas, ' Materias aprobadas: ',a.materiasAprobadas, ' Alumno: ',a.nomape);
    end;
    close(mae);
  end;
  
  procedure exportarATxtActualizacion(var mae:maestro);
  var
    txt:text;
    a:alumno;
  begin
    writeln('Exportando el archivo maestro actualizado, a maestro.txt');
    assign(txt,'maestro.txt');
    // deberia hacer reset o rewrite para actualizar el archivo de texto?
    rewrite(txt);
    assign(mae,'maestro');
    reset(mae);
    while (not eof(mae)) do begin
      read(mae,a);
      writeln(txt, a.codigo, ' ', a.cursadasAprobadas, ' ', a.materiasAprobadas, ' ', a.nomape);
    end;
    close(mae);
    close(txt);
  end;
  
  procedure exportarATxtAlumnos(var mae:maestro);
  var
    txt:text;
    a:alumno;
  begin
    writeln('Importando archivo binario a archivo de texto aquellos alumnos que posean mas materias aprobadas que materias sin finall aprobado');
	assign(txt, 'alumnos.txt');
	rewrite(txt);
	reset(mae);
	while(not eof(mae))do begin
		read(mae, a);
		if(a.materiasAprobadas > a.cursadasAprobadas)then 
			writeln(txt, a.codigo, ' ', a.cursadasAprobadas, ' ', a.materiasAprobadas, ' ', a.nomape);
	end;	
	close(mae);
	close(txt);	
  end;
  
var
  opt:integer;
  mae:maestro;
  det:detalle;
begin
  importarMaestro(mae);
  importarDetalle(det);
  writeln('Menu de opciones: ');
  writeln('1. Actualizar los estados de las materias de los alumnos.');
  writeln('2. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados que materias sin finales aprobados');
  writeln('0. Finalizar el programa.');
  readln(opt);
  assign(mae, 'maestro');
  assign(det, 'detalle');
  // hacer el reset y close dentro de cada modulo
  while (opt <> 0) do begin
    case opt of
      1: begin
        actualizarEstado(mae,det);
        exportarATxtActualizacion(mae);
      end;
      2: begin 
       listarAlumnosConMasFinales(mae);
       exportarATxtAlumnos(mae);
      end;
      0:
      else writeln('Opcion invalida.');
    end;
    writeln('1. Actualizar los estados de las materias de los alumnos.');
    writeln('2. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales aprobados que materias sin finales aprobados');
    writeln('0. Finalizar el programa.');
    readln(opt);
  end;
end.
