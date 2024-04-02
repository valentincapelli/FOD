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
type
  str20 = string[20];
  producto = record
    codigo:integer;
    nombre:str20;
    precio:real;
    stockAnual:integer;
    stockMinimo:integer;
  end;
  maestro = file of producto;
  
  venta = record
    codigo:integer;
    cantVendida:integer;
  end;
  detalle = file of venta;
  
var
  det:detalle;
  mae:maestro;
begin
  importarDetalle(det);
  importarMaestro(mae);
  actualizarMaestro(mae,det);
  listarStockMinimo(mae);
end.

