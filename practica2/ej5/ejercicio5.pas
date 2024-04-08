{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualizar el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}
program ejercicio5practica2;
const
  valoralto = 9999;
  sucursales = 30;
type
  producto = record
    codigo:integer;
    nombre:string[40];
    descripcion:string;
    stock:integer;
    stockMinimo:integer;
    precio:real;
  end;
  maestro = file of producto;
  
  infoDet = record
    codigo:integer;
    cantVendida:integer;
  end;
  detalle = file of infoDet;
  
  vector = array [sucursales] of detalle;
var
  mae:maestro;
  det:detalle;
  v:vector;
begin
  // se dispone cargarVector(v);
  abrirArchivos(mae,v);
  actualizarMaestro(mae,v);
  InformarStocksBajos(mae);
  cerrarArchivos(mae,v);
end.
