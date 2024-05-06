{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}
program ejercicio7practica2;
type
	registroAves = record
		codigo:integer;
		nombre:string[40];
		familia:string[40];
		descripcion:string[40];
		zona:string[20];
	end;
	archivoAves = file of registroAves;
	
	procedure leerAve(var rega:registroAves);
	begin
		writeln('Ingrese el codigo');
		readln(rega.codigo);
		if (rega.codigo <> 0) then begin
			writeln('Ingrese el nombre');
			readln(rega.nombre);
			writeln('Ingrese la familia');
			readln(rega.familia);
			writeln('Ingrese la descripcion');
			readln(rega.descripcion);
			writeln('Ingrese la zona');
			readln(rega.zona);
		end;
	end;
	
	procedure crearArchivo(var arch:archivoAves);
	var
		rega:registroAves;
	begin
		assign(arch,'archivoAves');
		rewrite(arch);
		leerAve(rega);
		while (rega.codigo <> 0) do begin
			write(arch,rega);
			leerAve(rega);
		end;
		close(arch);
	end;
	
	procedure bajaLogicaEspecies(var arch:archivoAves);
	var
		codigo:integer;
		rega:registroAves;
	begin
	    rega.codigo:= 0;
		reset(arch);
		writeln('Ingrese el codigo de la especie que quiere eliminar');
		readln(codigo);
		while (codigo <> 5000) do begin
			while (not eof(arch)) and (rega.codigo <> codigo) do
				read(arch,rega);
			if (rega.codigo = codigo) then begin
				rega.codigo := rega.codigo*(-1);
				seek(arch,filepos(arch)-1);
				write(arch,rega);
				writeln('Baja logica realizada');
			end
			else writeln('No se pudo realizar la baja logica');
			seek(arch,0);
			writeln('Ingrese el codigo de la especie que quiere eliminar');
			readln(codigo);
		end;
		close(arch);
	end;
	
	procedure bajaFisicaEspecies(var arch:archivoAves);
	var
		rega:registroAves;
		pos:integer;
	begin
		reset(arch);
		while (not eof(arch)) do begin
			read(arch,rega);
			if (rega.codigo < 0) then begin
				writeln('El codigo borrado es: ', rega.codigo*(-1));
				pos := filepos(arch)-1;
				seek(arch, filesize(arch)-1);
				read(arch, rega);
				seek(arch, pos);
				write(arch, rega);
				seek(arch, filesize(arch)-1);
				truncate(arch);
			end;
		end;
		close(arch);
	end;
	
	procedure informarArchivo(var arch:archivoAves);
	var
		rega:registroAves;
	begin
		reset(arch);
		writeln('Codigos del archivo de aves actualizado');
		while (not eof(arch)) do begin
			read(arch,rega);
			writeln('Codigo: ',rega.codigo);
		end;
		close(arch);
	end;
	
var
	archAves:archivoAves;
begin
	crearArchivo(archAves); // se dispone
	bajaLogicaEspecies(archAves);
	bajaFisicaEspecies(archAves);
	informarArchivo(archAves);
end.
