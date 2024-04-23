{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
 }
program ejercicio3practica3;
type
    str40 = string[40];
    novela = record
      codigo:integer;
      genero:str40;
      nombre:str40;
      duracion:integer;
      director:str40;
      precio:real;
    end;
    archivo_novelas = file of novela;
    
    procedure leerNovela(var n:novela);
    begin
		writeln('Ingrese el codigo.');
		readln(n.codigo);
		if (n.codigo <> -1) then begin
			writeln('Ingrese el genero');
			readln(n.genero);
			writeln('Ingrese el nombre.');
			readln(n.nombre);
			writeln('Ingrese el duracion.');
			readln(n.duracion);
			writeln('Ingrese el director.');
			readln(n.director);
			writeln('Ingrese el precio.');
			readln(n.precio);
		end;
    end;
    
    procedure crearArchivo(var arch:archivo_novelas);
    var
        name:str40;
        n:novela;
    begin
		writeln('Ingrese el nombre del archivo.');
		readln(name);
		assign(arch,name);
		rewrite(arch);
		leerNovela(n);
		n.codigo:= 0;
		while (n.codigo <> -1) do begin
			write(arch,n);
			leerNovela(n);
		end;
		close(arch);
    end;
    
    procedure informarArchivo(var arch:archivo_novelas);
    var
        n:novela;
    begin
        reset(arch);
        while (not eof(arch)) do begin
			read(arch,n);
			writeln('Codigo = ',n.codigo,' Nombre = ',n.nombre,' Genero =',n.genero,' Duracion = ',n.duracion,' Director = ',n.director,' Precio = ',n.precio:0:2);
        end;
        close(arch);
    end;
    
{b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.}
	
	procedure darDeAlta(var arch:archivo);
	var
		codigo:integer;
		n:novela;
	begin
		//reset(arch);
		writeln('Ingrese el codigo de novela que quiere dar de alta');
		readln(codigo);
		while (not eof(arch) and n.codigo <> codigo) do 
			read(arch,n);
		if (n.codigo = codigo) then begin
		    pos:= filepos(arch)-1'
			seek(arch, 0);
			read(arch,n);
			if (n.codigo < 0) then begin
				seek(arch,(n.codigo*(-1)));
				read(arch,n);
			end;
		end;
		//close(arch);
	end;
    
    procedure operaciones(var arch:archivo_novelas);
    var
		opt:integer;
    begin
		reset(arch);
		opt:= -1;
		while (opt <> 0) do begin
			writeln('Menu de operaciones');
			writeln('Ingrese 0 si quiere salir del menu.');
			writeln('Ingrese 1 si quiere dar de alta una novela.');
			readln(opt);
			case opt of
				0: writeln('Saliendo del menu de operaciones...');// termina el loop
				1: darDeAlta(arch);
				2: writeln('fsdf');
				else writeln('Ingrese un numero correcto');
			end;
		end;
		close(arch);
    end;
var
	arch:archivo_novelas;
	opt:str40;
begin
	opt:= 'z';
	while (opt <> 'ZZZZ') do begin
		writeln('Menu de opciones novelas');
		writeln('Ingrese A para crear un archivo de novelas.');
		writeln('Ingrese B para informar el archivo de novelas.');
		writeln('Ingrese C para realizar operaciones con el archivo de novelas.');
		writeln('Ingrese ZZZZ para terminar el programa.');
		readln(opt);
		case opt of
			'A': crearArchivo(arch);
			'B': informarArchivo(arch);
			'C': operaciones(arch);
		end;
	end;
end.
