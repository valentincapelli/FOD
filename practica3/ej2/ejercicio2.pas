{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}
program ejercicio2practica3;
type
	str40 = string[40];
	asistente = record
		nro:integer;
		apellido:str40;
		nombre:str40;
		email:str40;
		telefono:integer;
		dni:integer;
	end;
	archivo_asistentes = file of asistente;
	
	procedure leerAsistente(var a:asistente);
	begin
	    writeln('Ingrese el numero de asistente.');
	    readln(a.nro);
	    if (a.nro <> 0) then begin
			writeln('Ingrese el apellido.');
	        readln(a.apellido);
	        writeln('Ingrese el nombre.');
			readln(a.nombre);
			writeln('Ingrese el email.');
			readln(a.email);
			writeln('Ingrese el telefono.');
			readln(a.telefono);
			writeln('Ingrese el dni');
			readln(a.dni);
		end;
	end;
	
	procedure cargarArchivo(var arch:archivo_asistentes);
	var
		name:str40;
		a:asistente;
	begin
		writeln('Ingrese el nombre del archivo');
		readln(name);
		assign(arch,name);
		rewrite(arch);
		leerAsistente(a);
	    while (a.nro <> 0) do begin
			write(arch,a);
			leerAsistente(a);
	    end;
	    close(arch);
	end;
	
	procedure eliminarInferiores(var arch:archivo_asistentes);
	var
		a:asistente;
	begin
	    reset(arch);
	    while (not eof(arch)) do begin
			read(arch,a);
			if (a.nro < 1000) then 
				a.nombre:= '#' + a.nombre;
				seek(arch,filepos(arch)-1);
				write(arch,a);
	    end;
		close(arch);
	end;
	
	procedure imprimirArchivo(var arch : archivo_asistentes);
	var
		a : asistente;
	begin
		reset(arch);
		while (not eof(arch)) do begin
			read(arch, a);
			writeln('numero de asistente ', a.nro, ' apellido ' ,a.apellido, ' nombre ', a.nombre, ' email ', a.email, ' telefono ', a.telefono, ' dni ', a.dni);
		end;
		close(arch);
	end;
	
var
    arch:archivo_asistentes;
begin
	cargarArchivo(arch);
	eliminarInferiores(arch);
	imprimirArchivo(arch);
end.
