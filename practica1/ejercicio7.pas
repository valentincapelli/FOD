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
    nomArchText, nomArchNovelas:string[20];
  begin
    writeln('Nombre del archivo de novelas');
    readln(nomArchNovelas);
    assign(novelas,nomArchNovelas);
    
    writeln('Nombre del archivo de texto');
    readln(nomArchText);
    assign(archText,nomArchText);
    
    reset(archText);
    rewrite(novelas);
    
    while (not eof(archText)) do begin
      readln(archText, n.codigo, n.precio, n.genero);
      readln(archText, n.nombre);
      write(novelas,n);
    end;
    writeln('Archivo binario cargado.');
    readln;
    close(archText);
    close(novelas);
  end;
  
  procedure modificarNovela(var novelas:archivo_novelas):
  var
    cod:integer;
  begin
    writeln('Ingrese el codigo de novela que desea modificar');
    readln(cod);
    reset(novelas);
    encontre:= false;
    while (not eof(novelas)) and (encontre = false) do begin
      read(novelas, n);
      if (n.codigo = cod) then begin
        // codigo para modificar novela
        encontre = true;
      end;
    end;
    close(novelas);
  end;
  
  procedure actualizarArchivoBinario(var novelas:archivo_novelas);
  var
    cod:integer;
    encontre:boolean;
    n:novela;
    opt:string[5];
  begin
    writeln('Ingrese 1 si quiere agregar una novela');
    writeln('Ingrese 2 si quiere modificar una novela');
    writeln('Ingrese 3 si desea salir');
    readln(opt);
    case opt of
      '1': agregarNovela(novelas);
      '2': modificarNovela(novelas);
        
    end;
  end;
  
var
  opt:string[5];
  novelas:archivo_novelas;
begin
  opt:= 'd';
  while (opt <> 'c') do begin
    writeln('Novelas');
    writeln('Seleccione una opcion.');
    writeln('Ingrese "a" si desea crear un archivo binario de novelas a partir de la información almacenada en un archivo de texto.');
    writeln('Ingrese "b" si desea abrir el archivo binario y permitir la actualización del mismo.');
    writeln('Ingrese "c" si desea listar las novelas');
    writeln('Ingrese "c" si desea salir');
    readln(opt);
    case opt of
      'a': crearArchivoBinario(novelas);
      'b': actualizarArchivoBinario(novelas);
      'c': listarNovelas(novelas);
    end
  end;
end.
