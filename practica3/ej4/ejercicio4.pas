{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:}

{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente}

{procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}
program ejercicio4practica3;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;
	
	procedure ingresarFlor(var nombre:string; var codigo:integer);
	begin
		writeln('Ingrese el codigo de la flor');
		readln(codigo);
		writeln('Ingrese el nombre de la flor');
		readln(nombre);
	end;
	
	procedure leerFlor(var f:reg_flor);
	begin
		writeln('Ingrese el codigo de la flor');
		readln(f.codigo);
		if (f.codigo <> -1) then begin
			writeln('Ingrese el nombre de la flor');
			readln(f.nombre);
		end;
	end;
	
	procedure crearArchivo(var arch:tArchFlores);
	var
        name:string[30];
        f:reg_flor;
    begin
		writeln('Ingrese el nombre del archivo.');
		readln(name);
		assign(arch,name);
		rewrite(arch);
		leerFlor(f);
		while (f.codigo <> -1) do begin
			write(arch,f);
			leerFlor(f);
		end;
		close(arch);
    end;
	
	procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
	var
		f,aux:reg_flor;
	begin
		reset(a);
		f.nombre:= nombre;
		f.codigo:= codigo;
		read(a,aux);
		if (aux.codigo < 0) then begin
			seek(a, aux.codigo*(-1));
			read(a,aux);
			seek(a,filepos(a)-1);
			write(a,f);
			seek(a,0);
			write(a,aux);
		end
		else begin
			seek(a,filesize(a));
			write(a,f);
		end;
		close(a);
		writeln('La flor fue registrada.');
	end;
	
	procedure listarContenido(var arch:tArchFlores);
	var
        f:reg_flor;
    begin
        reset(arch);
        while (not eof(arch)) do begin
			read(arch,f);
			if (f.codigo > 0) then
				writeln('Codigo = ',f.codigo,' Nombre = ',f.nombre);
        end;
        close(arch);
    end;
	
var
	arch:tArchFlores;
	opt:string[10];
	nombre:string;
	codigo:integer;
begin
	crearArchivo(arch); // se dispone
	opt:= 'z';
	while (opt <> 'ZZZZ') do begin
		writeln('Menu de opciones flores');
		writeln('Ingrese A para agregar una flor.');
		writeln('Ingrese B para listar el contenido del archivo omitiendo las flores eliminadas.');
		writeln('Ingrese ZZZZ para terminar el programa.');
		readln(opt);
		case opt of
			'A': begin
				ingresarFlor(nombre,codigo);
				agregarFlor(arch,nombre,codigo);
			end;
			'B': listarContenido(arch);
		end;
	end;
end.
