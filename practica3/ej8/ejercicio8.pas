{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

program ejercicio8practica2;
type
	registroDistribucion = record
		nombre:string[40];
		lanzamiento:integer;
		version:real;
		desarroladores:integer;
		descripcion:string[40];
	end;
	archivoDistribuciones = file of registroDistribucion;
	
	function existeDistribucion(var arch:archivoDistribuciones; nombre:string):boolean;
	var
		regd:registroDistribucion;
		encontre:boolean;
	begin
		reset(arch);
		read(arch,regd);
		while (not eof(arch)) and (regd.nombre <> nombre) do begin
			read(arch,regd);
		end;
		if (regd.nombre = nombre) then
			encontre:= true
		else
			encontre:= false;
		close(arch);
		existeDistribucion:= encontre;
	end;
	
	procedure ingresarDistribucion(var regd:registroDistribucion);
	
	procedure altaDistribucion(var arch:archivoDistribuciones);
	var
		regd,aux:registroDistribucion;
	begin
		ingresarDistribucion(regd);
		if (not existeDistribucion(arch,regd.nombre)) then begin
			reset(arch);
			read(arch,aux);
			if (aux.version < 0) then begin
				seek(arch, aux.version*(-1));
				read(arch,aux);
				seek(arch,filepos(arch)-1);
				write(arch,regd);
				seek(arch,0);
				write(arch,aux);
			end
			else begin
				seek(arch,filesize(arch));
				write(arch,regd);
			end;
			close(arch);
		end
		else writeln('Ya existe la distribución');
	end;
	
	procedure bajaDistribución(var arch:archivoDistribuciones);
	var
		nombre:string[40];
		oldHead,newHead:integer;
		aux:registroDistribucion
	begin
		writeln('Ingrese el nombre de distribucion que desea dar de baja.');
		readln(nombre);
		if (existeDistribucion(codigo)) then begin
			reset(arch);
			read(arch,aux);
			oldHead := aux.codigo;
			while (not eof(arch)) and (aux.nombre <> regd.nombre) do
				read(arch,aux);
			if (aux.nombre = regd.nombre) then begin
				aux.codigo := oldHead;
				seek(arch,filepos(arch)-1);
				newHead := (-1 * filepos(arch));
				write(arch,aux);
				seek(arch,0);
				aux.codigo := newHead;
				write(arch,aux);
				writeln('La distribucion ingresada fue dada de baja correctamente.');
			end;
			close(arch);
		end
		else writeln('El nombre de distribucion no se encuentra en el archivo.');
	end;
	
var
	arch:archivoDistribuciones;
	opt:integer;
begin
	opt:= -1;
	while (opt <> 0) do begin
		writeln('Ingrese 1 si quiere crear un archivo de distribuciones de linux');
		writeln('Ingrese 2 si quiere agregar una distribucion');
		writeln('Ingrese 3 si quiere dar de baja una distribucion');
		readln(opt);
		case opt of
			1: crearArchivo(arch);
			2: altaDistribucion(arch);
			3: bajaDistribución(arch);
		end;
	end;
end.
