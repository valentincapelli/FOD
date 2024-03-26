{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.}

program ejercicio5practica1;
type
  celular = record
    cod:integer;
    nom:string;
    desc:string;
    marca:string;
    precio:real;
    stockMin:integer;
    stock:integer;
  end;
  
  archivo_celulares = file of celular;
  
  procedure cargarArchivoBinario(var celulares:archivo_celulares);
  var
    nomBin:string;
    cel:celular;
    carga: Text; {Archivo de texto con datos de los celulares, se lee de el y se genera un archivo binario}
  begin
    writeln('Nombre del archivo binario de celulares'); {nombre del archivo que quiero crear}
    readln(nomBin);
    assign(celulares,nomBin);
    rewrite(celulares); {crea el nuevo archivo binario}
      
    assign(carga,'celulares.txt');
    reset(carga); {abre archivo de texto con datos}
    
    while (not eof(carga)) do begin
      readln(carga, cel.cod, cel.precio, cel.marca);
      readln(carga, cel.stock, cel.stockMin, cel.desc);
      readln(carga, cel.nom); {lectura del archivo de texto}
      write(celulares, cel); {escribe el archivo binario}
    end;
    writeln('Archivo cargado.');
    close(celulares);
    close(carga);
  end;
  
  procedure informarCel(cel:celular);
  begin
    writeln('Codigo: ',cel.cod,' Nombre: ',cel.nom,' Desc: ',cel.desc,' Marca: ',cel.marca,' Precio: ',cel.precio,' Stock min: ',cel.stockMin,' Stock: ', cel.stock);
  end;
  
  procedure listarStockPorDebajo(var celulares:archivo_celulares);
  var
    cel:celular;
    nomBin:string;
  begin
    //write('Ingrese el nombre del archivo binario de celulares: ');
   // read(nomBin);
   /// assign(celulares, nomBin);
    reset(celulares);
    while not eof(celulares) do begin
      read(celulares, cel);
      if (cel.stock < cel.stockMin) then
        informarCel(cel);
    end;
    close(celulares);
  end;
  
  procedure listarCadenaEspecial(var celulares:archivo_celulares);
  var
    cel:celular;
    nomBin, desc:string;
  begin
    write('Ingrese el nombre del archivo binario de celulares: ');
    read(nomBin);
    writeln('Ingrese la descripcion que busca');
    read(desc);
    assign(celulares, nomBin);
    reset(celulares);
    while not eof(celulares) do begin
      read(celulares, cel);
      if (cel.desc = desc) then
        informarCel(cel);
    end;
    close(celulares);
  end;
  
var
  celulares: archivo_celulares;
  opc: Byte;
begin
  repeat
    writeln('0 Terminar el programa');
    writeln('1. Crear un archivo binario de celulares desde un archivo de texto');
    writeln('2. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo');
    writeln('3. Listar en pantalla los datos de aquellos celulares con descripcion especial');
    readln(opc);
    case opc of
      1: cargarArchivoBinario(celulares);
      2: listarStockPorDebajo(celulares);
      3: listarCadenaEspecial(celulares);
      else writeln('Error. Elija una opcion valida.');
    end;
  until opc = 0;
end.
