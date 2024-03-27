{7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ejercicio7practica1;
type
  novela = record
    codigo:integer;
    nombre:string[20];
    genero:string[20];
    precio:real;
  end;
  
  archivo_novelas = file of novela;
  
  procedure crearArchivoBinario(var novelas:archivo_novelas);
  var
    n:novela;
    archText:text;
    //nomArchText, nomArchNovelas:string[20];
  begin
    //writeln('Nombre del archivo de texto');
    //readln(nomArchText);
    //assign(archText,nomArchText);
    assign(archText,'novelas.txt'); {dejo por defualt que cree el archivo binario a partir de novelas.txt}
    reset(archText);  {abro el archivo de texto} 
    
    rewrite(novelas); {crea el archivo binario}
    
    while (not eof(archText)) do begin
      readln(archText, n.codigo, n.precio, n.genero);
      readln(archText, n.nombre);
      write(novelas,n);
    end;
    writeln('Archivo binario cargado.');
    close(archText);
    close(novelas);
  end;
  
  procedure leerNovela(var n:novela);
  begin
    writeln('Ingrese el codigo');
    readln(n.codigo);
    writeln('Ingrese el nombre');
    readln(n.nombre);
    writeln('Ingrese el genero');
    readln(n.genero);
    writeln('Ingrese el precio');
    readln(n.precio);
  end;
  
  procedure agregarNovela(var novelas:archivo_novelas);
  var
    n:novela;
  begin
    writeln('Ingrese la informacion de la nueva novela');
    leerNovela(n);
    reset(novelas);
    seek(novelas, filesize(novelas));
    write(novelas, n);
    writeln('Se agrego la nueva novela al archivo');
    close(novelas);
  end;
  
  procedure modificarNovela(var novelas:archivo_novelas);
  var
    cod:integer;
    encontre:boolean;
    n:novela;
  begin
    writeln('Ingrese el codigo de la novela que desea modificar');
    readln(cod);
    writeln('Ingrese la informacion de la novela que quiere modificar');
    leerNovela(n);
    
    reset(novelas);
    encontre:= false;
    while (not eof(novelas)) and (encontre = false) do begin
      read(novelas, n);
      if (n.codigo = cod) then begin
        seek(novelas, filepos(novelas)-1);
        write(novelas,n);
        encontre := true;
        writeln('Archivo modificado');
      end;
    end;
    close(novelas);
  end;
  
  procedure actualizarArchivoBinario(var novelas:archivo_novelas);
  var
    opt:string[5];
  begin
    opt := '0';
    while (opt <> '3') do begin
      writeln('Ingrese 1 si quiere agregar una novela');
      writeln('Ingrese 2 si quiere modificar una novela');
      writeln('Ingrese 3 si desea salir');
      readln(opt);
      case opt of
        '1': agregarNovela(novelas);
        '2': modificarNovela(novelas);
        '3': // no hace nada
        else writeln('Ingrese una opcion valida');
      end;
    end;
  end;
  
  procedure listarNovelas(var novelas:archivo_novelas);
  var
    n:novela;
  begin
    reset(novelas);
    while (not eof(novelas)) do begin
      read(novelas,n);
      writeln('Nombre ',n.nombre,' Codigo ',n.codigo,' Genero ',n.genero,' Precio ',n.precio:0:2);
    end;
    close(novelas);
  end;
  
var
  opt:string[5];
  novelas:archivo_novelas;
  nomBin:string;
begin
  opt:= 'h';
  while (opt <> 'z') do begin
    writeln('Novelas');
    writeln('Seleccione una opcion.');
    writeln('Ingrese "a" si desea crear un archivo binario de novelas a partir de la información almacenada en novelas.txt.');
    writeln('Ingrese "b" si desea abrir el archivo binario y permitir la actualización del mismo.');
    writeln('Ingrese "c" si desea listar las novelas');
    writeln('Ingrese "z" si desea salir');
    readln(opt);
    if (opt <> 'z') then begin
      writeln('Nombre del archivo binario de novelas'); {nombre del archivo que quiero crear o interactuar}
      readln(nomBin);
      assign(novelas,nomBin); {Hago una sola vez el assign antes del case}
      case opt of
        'a': crearArchivoBinario(novelas);
        'b': actualizarArchivoBinario(novelas);
        'c': listarNovelas(novelas);
        'z': // no hace nada
        else writeln('Ingrese una opcion valida');
      end;
    end;
  end;
end.
