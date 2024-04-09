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
  sucursales = 1; // 30
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
  
  vector = array [1..sucursales] of detalle;
  vectorAuxiliar = array [1..sucursales] of infoDet;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    regm:producto;
  begin
    assign(mae,'maestro');
    rewrite(mae);
    writeln('Realizando importacion del archivo maestro.txt');
    assign(txt,'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin
      readln(txt, regm.codigo, regm.precio, regm.stock, regm.stockMinimo, regm.nombre);
      readln(txt, regm.descripcion);
      write(mae, regm);
    end;
    writeln('La importacion del archivo maestro se realizo con exito');
    close(txt);
    close(mae);
  end;
  
  procedure importarDetalle(var det:detalle);
  var
    txt:text;
    regd:infoDet;
    nombre:string;
  begin
    writeln('Ingrese el nombre del archivo binario detalle');
    readln(nombre);
    assign(det,nombre);
    rewrite(det);
    
    writeln('Ingrese el nombre del archivo txt detalle');
    readln(nombre);
    assign(txt,nombre);
    reset(txt);
    
    while (not eof(txt)) do begin
      readln(txt, regd.codigo, regd.cantVendida);
      write(det, regd);
      writeln('aca');
    end;
     writeln('La importacion del archivo detalle se realizo con exito');
    close(det);
    close(txt);
  end;
  
  procedure cargarVectorDetalles(var v:vector);
  var
    i:integer;
  begin
    for i:= 1 to sucursales do 
      importarDetalle(v[i])
  end;
  
  procedure abrirDetalles(var v:vector);
  var
    i:integer;
  begin
    for i:= 1 to sucursales do
      reset(v[i]);
  end;
  
  procedure cerrarDetalles(var v:vector);
  var
    i:integer;
  begin
    for i:= 1 to sucursales do
      close(v[i]);
  end;
  
  procedure leer(var det:detalle; var regd:infoDet);
  begin
    if (not eof(det)) then
      read(det,regd)
    else
      regd.codigo:= valoralto;
  end;
  
  procedure leerDetalles(var v:vector; var va:vectorAuxiliar);
  var
    i:integer;
  begin
    for i:= 1 to sucursales do
      leer(v[i],va[i]);
  end;
  
  procedure minimo(var v:vector; var va:vectorAuxiliar; var min:infoDet);
  var
    i:integer;
  begin
    min.codigo:= valoralto;
    for i:= 1 to sucursales do begin
      if (va[i].codigo < min.codigo) then begin
        min:= va[i];
        leer(v[i],va[i]);
      end;
    end;
    //
    //
  end;
  
  procedure actualizarMaestro(var mae:maestro; var v:vector);
  var
    regm:producto;
    va:vectorAuxiliar;
    min:infoDet;
  begin
    reset(mae);
    abrirDetalles(v);
    leerDetalles(v,va);
    minimo(v,va,min);
    while (min.codigo <> valoralto) do begin
      read(mae,regm);
      while (regm.codigo <> min.codigo) do 
        read(mae,regm);
      while (regm.codigo = min.codigo) and (min.codigo <> valoralto) do begin
        regm.stock := regm.stock - min.cantVendida;
        minimo(v,va,min);
      end;
      seek(mae,filepos(mae)-1);
      write(mae,regm);
    end;
    close(mae);
    cerrarDetalles(v);
    writeln('El maestro fue actualizado.');
  end;
  
  procedure informarMaestro(var mae:maestro);
  var
    regm:producto;
  begin
    reset(mae);
    while (not eof(mae)) do begin
      read(mae,regm);
      writeln('Codigo ', regm.codigo, ' Precio ', regm.precio:0:2, ' Stock ', regm.stock, ' Stock minimo ', regm.stockMinimo, ' Nombre ', regm.nombre, ' Descripcion ', regm.descripcion);
    end;
    close(mae);
  end;
  
  procedure informarStocksBajos(var mae:maestro);
  var
    txt: text;
    regm:producto;
  begin
    writeln('Exportando a informe.txt aquellos productos con stock por debajo del minimo');
    assign(txt,'informe.txt');
    rewrite(txt);
    reset(mae);
    while (not eof(mae)) do begin
      read(mae, regm);
      if (regm.stock < regm.stockMinimo) then
        writeln(txt, regm.precio:0:2,' ', regm.nombre);
        writeln(txt, regm.stock,' ', regm.descripcion);
    end;
    writeln('La exportacion del informe se realizo con exito');
    close(txt);
	close(mae);
  end;
  
var
  mae:maestro;
  v:vector;
begin
  importarMaestro(mae);
  cargarVectorDetalles(v);
  actualizarMaestro(mae,v);
  informarMaestro(mae);
  InformarStocksBajos(mae);
end.
// El informe.txt se informa mal. Consultar.
