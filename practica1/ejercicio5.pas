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
    codigo:integer;
    nombre:string;
    desc:string;
    marca:string;
    precio:real;
    stockMinimo:integer;
    stock:integer;
  end;
  
  archivo_celulares = file of celular;
  
  procedure cargarArchivoBinario(var celulares:archivo_celulares);
  var
    cel:celular;
    carga: Text; {Archivo de texto con datos de los celulares, se lee de el y se genera un archivo binario}
  begin
    //writeln('Nombre del archivo binario de celulares'); {nombre del archivo que quiero crear}
    //readln(nomBin);
    //assign(celulares,nomBin);
    rewrite(celulares); {crea el nuevo archivo binario}
      
    assign(carga,'celulares.txt');
    reset(carga); {abre archivo de texto con datos}
    
    while (not eof(carga)) do begin
      readln(carga, cel.codigo, cel.precio, cel.marca);
      readln(carga, cel.stock, cel.stockMinimo, cel.desc);
      readln(carga, cel.nombre); {lectura del archivo de texto}
      write(celulares, cel); {escribe el archivo binario}
    end;
    writeln('Archivo cargado.');
    close(celulares);
    close(carga);
  end;
  
  procedure informarCel(cel:celular);
  begin
    writeln('Codigo: ',cel.codigo,' Nombre: ',cel.nombre,' Desc: ',cel.desc,' Marca: ',cel.marca,' Precio: ',cel.precio:0:2,' Stock min: ',cel.stockMinimo,' Stock: ', cel.stock);
  end;
  
  procedure listarStockPorDebajo(var celulares:archivo_celulares);
  var
    cel:celular;
  begin
    reset(celulares);
    while not eof(celulares) do begin
      read(celulares, cel);
      if (cel.stock < cel.stockMinimo) then
        informarCel(cel);
    end;
    close(celulares);
  end;
  
  procedure listarCadenaEspecial(var celulares:archivo_celulares);
  var
    cel:celular;
    desc:string;
    posicion:integer;
  begin
    writeln('Ingrese la descripcion que busca');
    read(desc);
    reset(celulares);
    while not eof(celulares) do begin
      read(celulares, cel);
      posicion := Pos(desc, cel.desc);
      if (posicion <> 0) then
        informarCel(cel)
      else
        writeln('No se encuentra esa descripcion');
    end;
    close(celulares);
  end;
  
  procedure exportarArchivo(var celulares:archivo_celulares);
  var
    txt:text;
    regc:celular;
    nomTxt:string;
  begin
    writeln('Ingrese el nombre del archivo de texto');
    readln(nomTxt);
    assign(txt,nomTxt);
    rewrite(txt); {creo el archivo de texto}
    reset(celulares); {abro archivo binario}
    
    while (not eof(celulares)) do begin
      read(celulares, regc); {leo un registro celular del archivo}
      writeln(txt, regc.codigo,' ',regc.precio:0:2,' ',regc.marca);
      writeln(txt, regc.stock,' ',regc.stockMinimo,' ',regc.desc);
      writeln(txt, regc.nombre); {escribe en el archivo de texto los campos en su orden especifico}
    end;
    close(celulares);
    close(txt);
  end;
var
  celulares: archivo_celulares;
  opc: char;
  nomBin:string;
begin
  opc:= 'a';
  while (opc <> '0') do begin
    writeln('0 Terminar el programa');
    writeln('1. Crear un archivo binario de celulares desde un archivo de texto');
    writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
    writeln('3. Listar en pantalla los datos de aquellos celulares con descripcion especial');
    writeln('4. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.');
    readln(opc);
    readln;
    if (opc <> '0') then begin
      writeln('Nombre del archivo binario de celulares'); {nombre del archivo que quiero crear o interactuar}
      readln(nomBin);
      assign(celulares,nomBin); {Hago una sola vez el assign antes del case}
      case opc of
        '1': cargarArchivoBinario(celulares);
        '2': listarStockPorDebajo(celulares);
        '3': listarCadenaEspecial(celulares);
        '4': exportarArchivo(celulares);
        '0': // no hacer nada
        else writeln('Error. Elija una opcion valida.');
      end;
    end;
  end;
end.
