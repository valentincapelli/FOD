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
        name:string;
    begin
        writeln('Ingrese el nombre del archivo.');
		readln(name);
		assign(arch,name);
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
	
	procedure darDeAlta(var arch:archivo_novelas);
	var
		n,aux:novela;
	begin
		reset(arch);
		
		leerNovela(n); 
		read(arch,aux); // leo la cabecera
		if (aux.codigo < 0) then begin  // si el codigo es negativo recupero espacio
			seek(arch, aux.codigo*(-1));  // me posiciono en la ultima posicion dada de baja
			read(arch,aux);  // leo el codigo de esa posicion
			seek(arch,filepos(arch)-1);  // me vuelvo a posicionar en la misma pos
			write(arch,n); // escribo la nueva novela en ese pos para recuperar espacio
			seek(arch,0);  // me posiciono en la cabecera
			write(arch,aux);  // escribo el codigo que habia leido en la pos que habia sido dada de baja
		end
		else begin
			seek(arch,filesize(arch));
			write(arch,n);
		end;
		close(arch);
		writeln('La novela fue registrada.');
	end;
	
	procedure darDeBaja(var arch:archivo_novelas);
	var
		codigo,cabecera,head:integer;
		n:novela;
	begin
		writeln('Ingrese un codigo de novela a borrar.');
		readln(codigo);
		reset(arch);
		read(arch,n);
		cabecera:= n.codigo; 
		while (not eof(arch)) and (n.codigo <> codigo) do
			read(arch,n);
		if (n.codigo = codigo) then begin
			n.codigo:= cabecera;  // me guardo el valor de la cabecera actual
			seek(arch,filepos(arch)-1); // se reposiciona en la pos a borrar
			head:= (-1 * filepos(arch)); // paso a negativo la pos a borrar y se lo asigno a la variable de cabecera
			write(arch, n); // escribo la vieja cabecera
			seek(arch,0);
			n.codigo := head; {asigna la nueva cabecera en la misma variable}
			write(arch,n); // actualiza la cabecera para mantener el orden de la lista
			writeln('La novela fue borrada correctamente.');
		end
		else
			writeln('El codigo ingresado no se encontro.');
		close(arch);
	end;
	
	procedure modificarNovela(var arch:archivo_novelas);
	var
		n:novela;
		codigo:integer;
	begin
		reset(arch);
		writeln('Ingrese el codigo de novela que desea modificar.');
		readln(codigo);
		close(arch);
	end;
    
    procedure operaciones(var arch:archivo_novelas);
    var
		opt:integer;
		name:string;
    begin
		opt:= -1;
		writeln('Ingrese el nombre del archivo.');
		readln(name);
		assign(arch,name);
		while (opt <> 0) do begin
			writeln('Menu de operaciones');
			writeln('Ingrese 0 si quiere salir del menu.');
			writeln('Ingrese 1 si quiere dar de alta una novela.');
			writeln('Ingrese 2 si quiere modificar una novela.');
			writeln('Ingrese 3 si quiere dar de baja una novela.');
			readln(opt);
			case opt of
				0: writeln('Saliendo del menu de operaciones...');// termina el loop
				1: darDeAlta(arch);
				2: modificarNovela(arch);
				3: darDeBaja(arch);
				else writeln('Ingrese un numero correcto');
			end;
		end;
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
