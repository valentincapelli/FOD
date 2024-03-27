
{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular. }

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
  
{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.}
  
  procedure leerCelular(var c:celular);
  begin
    writeln('Ingrese el codigo');
    readln(c.codigo);
    writeln('Ingrese el nombre');
    readln(c.nombre);
    writeln('Ingrese la descripcion');
    readln(c.desc);
    writeln('Ingrese la marca');
    readln(c.marca);
    writeln('Ingrese el precio');
    readln(c.precio);
    writeln('Ingrese el stock minimo');
    readln(c.stockMinimo);
    writeln('Ingrese el stock disponible');
    readln(c.stock);
  end;
  
  procedure agregarCelular(var celulares:archivo_celulares);
  var
    cel:celular;
  begin
    reset(celulares);
    leerCelular(cel);
    seek(celulares, filesize(celulares));
    write(celulares, cel);
    writeln('Se agrego el nuevo celular al archivo');
    close(celulares);
  end;
  
  procedure modificarStock(var celulares:archivo_celulares);
  var
    newStock:integer;
    cel:celular;
    encontre:boolean;
    nombre:string;
  begin
    writeln('Ingrese el nombre del celular que quiere modificarle el stock');
    readln(nombre);
    writeln('Ingrese el nuevo stock');
    readln(newStock);
    reset(celulares);
    encontre:= false;
    while (not eof(celulares)) and (encontre = false) do begin
      read(celulares, cel);
      if (cel.nombre = nombre) then begin
        cel.stock:= newStock;
        seek(celulares, filepos(celulares)-1);
        write(celulares,cel);
        encontre:= true;
        writeln('Archivo modificado');
      end;
    end;
    if (encontre = false) then
      writeln('Ese nombre de celular no se encuentra en nuestro archivo de celulares');
    close(celulares);
  end;
  
  procedure exportarSinStock(var celulares:archivo_celulares);
  var
    nomTxt:string;
    txt:text;
    regc:celular;
  begin
    //writeln('Ingrese el nombre del archivo de texto');
    //readln(nomTxt);
    nomTxt:= 'SinStock.txt';
    assign(txt,nomTxt);
    rewrite(txt); {creo el archivo de texto}
    reset(celulares); {abro archivo binario}
    
    while (not eof(celulares)) do begin
      read(celulares, regc); {leo un registro celular del archivo}
      if (regc.stock = 0) then begin
        writeln(txt, regc.codigo,' ',regc.precio:0:2,' ',regc.marca);
        writeln(txt, regc.stock,' ',regc.stockMinimo,' ',regc.desc);
        writeln(txt, regc.nombre); {escribe en el archivo de texto los campos en su orden especifico}
      end;
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
    writeln('5. Aniadir uno o mas celulares al final del archivo con sus datos ingresados por teclado.');
    writeln('6. Modificar el stock de un celula');
    writeln('7. Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0.');
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
        '5': agregarCelular(celulares);
        '6': modificarStock(celulares);
        '7': exportarSinStock(celulares);
        '0': // no hacer nada
        else writeln('Error. Elija una opcion valida.');
      end;
    end;
  end;
end.
