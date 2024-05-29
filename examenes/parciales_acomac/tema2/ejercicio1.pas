{Se cuenta con un archivo que almacena información sobre los tipos de dinosaurios
que habitaron durante la era mesozoica, de cada tipo se almacena: código, tipo de
dinosaurio, altura y peso promedio, descripción y zona geográfica. El archivo no está
ordenado por ningún criterio. Realice un programa que elimine tipos  de dinosaurios
que estuvieron en el periodo jurásico de la era mesozoica. Para ello se recibe por
teclado los códigos de los tipos a eliminar.
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido. 
Dada la estructura planteada en el ejercicio, implemente los siguientes módulos:

(Abre el archivo y agrega un tipo de dinosaurios, recibido como parámetro
manteniendo la política descripta anteriormente)
a. procedure agregarDinosaurios (var a: tArchDinos ; registro: recordDinos);
b. Liste el contenido del archivo en un archivo de texto, omitiendo los tipos de
dinosaurios eliminados. Modifique lo que considere necesario para obtener el listado.}

program acomac_tema1;
type
    recordDinos = record
        codigo:integer;
        tipo:string[40];
        altura:real;
        peso:real;
        desc:string;
        zona:string[40];
    end;
    tArchDinos = file of recordDinos;
    
procedure leerDino(var d: recordDinos);
begin 
    writeln('Ingrese el codigo del dinosaurio');
    readln(d.codigo);
    if(d.codigo <> -1) then begin
        writeln('Ingrese el tipo de dinosaurio');
        readln(d.tipo);
        writeln('Ingrese la altura del dinosaurio');
        readln(d.altura);
        writeln('Ingrese el peso del dinosaurio');
        readln(d.peso);
        writeln('Ingrese la descripcion del dinosaurio');
        readln(d.desc);
        writeln('Ingrese la zona geografica del dinosaurio');
        readln(d.zona);
    end;
end;

procedure crearArchivo(var a: tArchDinos);
var
    d: recordDinos;
begin
    assign(a, 'Dinosaurios');
    rewrite(a);
    d.codigo := 0;
    d.tipo := '';
    d.altura := 0;
    d.peso := 0.0;
    d.desc := '';
    d.zona := '';
    write(a, d);
    leerDino(d);
    while(d.codigo <> -1) do begin
        write(a, d);
        leerDino(d);
    end;
    close(a);
    writeln('El archivo de dinosaurios se ha creado con exito');
end;


    procedure agregarDinosaurios (var a: tArchDinos ; registro: recordDinos);
    var
        aux:recordDinos;
    begin
        reset(a);
        read(a,aux); // leo la cabecera
        if (aux.codigo < 0) then begin  // si el codigo es negativo recupero espacio
            seek(a,aux.codigo * (-1)); // me paro en la ultima pos borrada
            read(a,aux);  // leo el codigo de esa pos(proxima cabecera)
            seek(a,filepos(a)-1);  // me reposiciono
            write(a,registro);  //escribo el nuevo dino
            seek(a,0);  // me posiciono en la cabecera
            write(a,aux);  // actualizo cabecera
        end
        else begin
            seek(a,filesize(a));
            write(a,registro);
        end;
        close(a);
        writeln('El dinosaurio fue agregado.');
    end;

    procedure eliminarDinos (var a: tArchDinos ; tipoDinosaurio: String);
    var
		aux:recordDinos;
		oldHead, newHead:integer;
    begin
        reset(a);
        read(a,aux);
        oldHead:= aux.codigo;
        while (not eof(a)) and (aux.tipo <> tipoDinosaurio) do
            read(a,aux);
        if (aux.tipo = tipoDinosaurio) then begin
            aux.codigo:= oldHead;
            seek(a,filepos(a)-1);
            newHead:= (-1 * filepos(a));
            write(a,aux);
            seek(a,0);
            aux.codigo:= newHead;
            write(a,aux);
            writeln('El tipo de dinosaurio fue borrado correctamente.');
        end
        else writeln('El tipo de dinosaurio no se encuentra.');
        close(a);
    end;

    procedure generarListado(var a: tArchDinos);
    var
        txt:text;
        reg:recordDinos;
    begin
        reset(a);
        assign(txt,'dinosaurios.txt');
        rewrite(txt);
        while (not eof(a)) do begin
            read(a,reg);
            if (reg.codigo > 0) then
                writeln(txt, reg.codigo, ' ', reg.tipo,' ', reg.altura,' ', reg.peso,' ',reg.desc,' ',reg.zona);
        end;
        close(txt);
        close(a);
        writeln('El archivo se ha exportado.');
    end;

var
    a:tArchDinos;
    registro:recordDinos;
    tipo:string;
begin
    crearArchivo(a);
    writeln('Ingrese los datos del dinosaurio que desea agregar');
    leerDino(registro);
    agregarDinosaurios(a, registro);
    generarListado(a);
    tipo:= 'as';
    while(tipo <> 'zzz') do begin
		writeln('Ingrese el tipo que quiere eliminar.');
		readln(tipo);
		eliminarDinos(a,tipo);
	end;
    generarListado(a);
end.
