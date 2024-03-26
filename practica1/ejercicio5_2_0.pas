{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.}
program ejercicio5practica1;
type
  celular = record
    cod:integer;
    nom:string;
    desc:string;
    marca:string;
    precio:real;
    stockMinimo:integer;
    stock:integer;
  end;
  
  archivo_celulares = file of celular;
  
  procedure crearArchivo(var celulares:archivo_celulares);
  var
    txt: text;
    c:celular;
    nomArch:string[20];
  begin
    writeln('Ingrese el nombre del archivo binario a crear');
    readln(nomArch);
    assign(celulares,nomArch);
    rewrite(celulares);
    
    writeln('Importando datos de "celulares.txt"');
    assign(txt, 'celulares.txt');
    reset(txt);
    
    while (not eof(txt)) do begin
      read(txt, c.cod, c.precio, c.marca);
      read(txt, c.stock, c.stockMinimo, c.desc);
      read(txt, c.nom);
      write(celulares, c);
    end;
    writeln('Se cargo el archivo binario con exito');
    close(txt);
    close(celulares);
  end;

var
  opt:Byte;
  celulares:archivo_celulares;
begin
  opt:= 10;
  while (opt <> 0) do begin
    writeln('Seleccione una opcion');
    writeln('1. Crear un archivo binario de celulares y cargarlo con datos desde celulares.txt');
    writeln('2. Listar en pantalla aquellos celulares con stock menor al stock minimo');
    writeln('3. Listar en pantalla los celulares del archivo cuya descripción tenga una cadena de caracteres dada por el usuario');
    writeln('4. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.');
    readln(opt);
    case opt of
      1: crearArchivo(celulares);
      //2: listarStockPorDebajo(celulares);
      //3: listarDescripcionaEspecial(celulares);
      else writeln('Error. Elija una opcion valida.');
    end
  end;
end.
