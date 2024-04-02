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
    regd.codigo := 0;
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
    reset(txt);
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
  readln(opt);
  assign(mae, 'maestro');
  assign(det, 'detalle');
  // hacer el reset y close dentro de cada modulo
  case opt of
    1: begin
      actualizarEstado(mae,det);
      exportarATxtActualizacion(mae);
    end;
   2: begin 
     listarAlumnosConMasFinales(mae);
     exportarATxtAlumnos(mae);
   end;
    else writeln('Opcion invalida.');
  end;
end.
// me tira error al hacer la opcion 1 y no se me actualiza el archivo maestro
