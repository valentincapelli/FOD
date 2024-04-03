{3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program ejericio3practica2;
const
  valoralto = 9999;
type
  str20 = string[20];
  producto = record
    codigo:integer;
    nombre:str20;
    precio:real;
    stockActual:integer;
    stockMinimo:integer;
  end;
  maestro = file of producto;
  
  venta = record
    codigo:integer;
    cantVendida:integer;
  end;
  detalle = file of venta;
  
  procedure importarDetalle(var det:detalle);
  var
    txt:text;
    v:venta;
  begin
    assign(det,'detalle');
    rewrite(det);
    writeln('Realizando importacion del archivo detalle.txt');
    assign(txt,'detalle.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, v.codigo, v.cantVendida);
      write(det,v);
    end;
    writeln('La importacion se realizo con exito');
    close(txt);
    close(det);
  end;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    p:producto;
  begin
    assign(mae,'maestro');
    rewrite(mae);
    writeln('Realizando importacion del archivo maestro.txt');
    assign(txt,'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, p.codigo, p.precio, p.stockActual, p.stockMinimo, p.nombre);
      write(mae,p);
    end;
    writeln('La importacion se realizo con exito');
    close(txt);
    close(mae);
  end;
  
  procedure leer(var det:detalle; var dato:venta);
  begin
    if (not eof(det)) then
      read(det,dato)
    else
      dato.codigo:= valoralto;
  end;
  
  procedure actualizarMaestro(var mae:maestro; var det:detalle);
  var
    regm:producto;
    regd:venta;
    codigoActual,totalVendido:integer;
  begin
    reset(det);
    reset(mae);
    leer(det,regd);
    read(mae, regm);
    while (regd.codigo <> valoralto) do begin
      codigoActual:= regd.codigo;
      totalVendido:= 0;
      while (codigoActual = regd.codigo) do begin
        totalVendido:= totalVendido + regd.cantVendida;
        leer(det,regd);
      end;
      while (regm.codigo <> codigoActual) do 
        read(mae,regm);
      regm.stockActual:= regm.stockActual - totalVendido;
      seek(mae,filepos(mae)-1);
      write(mae,regm);
      if (not eof(mae))then
        read(mae,regm);
    end;
    close(det);
    close(mae);
  end;
  
  procedure listarStockMinimo(var mae:maestro);
  var
    p:producto;
    txt:text;
  begin
    writeln('Realizando una exportacion al archivo stock_minimo.txt');
    assign(txt,'stock_minimo.txt');
    rewrite(txt);
    reset(mae);
    while (not eof(mae)) do begin
      read(mae,p);
      if (p.stockActual < p.stockMinimo) then
        write(txt, p.codigo,' ',p.precio:0:2,' ',p.stockActual,' ',p.stockMinimo,' ',p.nombre);
    end;
    writeln('La exportacion se realizo con exito.');
    close(txt);
    close(mae);
  end;
  
var
  det:detalle;
  mae:maestro;
  opt:char;
begin
  importarDetalle(det);
  importarMaestro(mae);
  writeln('Menu de opciones');
  writeln('1. Actualizar el archivo maestro con el archivo detalle.');
  writeln('2. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.');
  readln(opt);
  assign(det,'detalle');
  assign(mae,'maestro');
  case opt of
    '1': begin
       actualizarMaestro(mae,det);
    end;
    '2': listarStockMinimo(mae);
    else 
      writeln('Ingrese una opcion valida.');
  end;
end.
// Cuando actualizo el maestro con un detalle y el stock actual queda por debajo del minimo,
// al ejecutar la opcion 2 no me los lista. Solo los lista cuando los inicializo por debajo
// del stock minimo desde el maestro.
