{1. El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:
a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:
i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?}

program ejercicio1p2practica3;
type
	registroMaestro = record
		codigo:integer;
		nombre:string[40];
		precio:real;
		stockActual:integer;
		stockMinimo:integer;
	end;
	maestro = file of registroMaestro;
	
	registroDetalle = record
		codigo:integer;
		cantVendida:integer;
	end;
	detalle = file of registroDetalle;
	
	procedure crearMaestro(var mae: maestro; var carga: text);
	var
		nombre: string;
		regM : registroMaestro;
	begin
		reset(carga);
		nombre:= 'ArchivoMaestro';
		assign(mae, nombre);
		rewrite(mae);
		while(not eof(carga)) do begin
			with regM do begin
				readln(carga, codigo, precio, stockActual, stockMinimo, nombre);
				write(mae, regM);
			end;
        end;
		writeln('Archivo binario maestro creado');
		close(mae);
		close(carga);
	end;

	procedure crearDetalle(var det: detalle; var carga: text);
	var
		nombre : string;
		regD : registroDetalle;
	begin
		reset(carga);
		nombre:= 'ArchivoDetalle';
		assign(det, nombre);
		rewrite(det);
		while(not eof(carga)) do begin
            with regD do begin
                readln(carga, codigo, cantVendida);
                write(det, regD);
            end;
        end;
		writeln('Archivo binario detalle creado');
		close(det);
		close(carga);
	end;
	
	procedure actualizarMaestro(var mae:maestro; var det:detalle);
	var
		regd:registroDetalle;
		regm:registroMaestro;
	begin
		reset(mae);
		reset(det);
		while (not eof(det)) do begin
			read(det,regd);
			read(mae,regm);
			while(regd.codigo <> regm.codigo) and (not eof(mae)) do
				read(mae,regm);
			if (regd.codigo = regm.codigo) then begin
				regm.stockActual:= regm.stockActual - regd.cantVendida;
				seek(mae,filepos(mae)-1);
				write(mae,regm);
				seek(mae,0)
			end;
		end;
		close(mae);
		close(det);
	end;
	
	procedure imprimirMaestro(var mae: maestro);
	var
		regM : registroMaestro;
	begin
		reset(mae);
		while(not eof(mae)) do begin
            read(mae, regM);
            with regM do
                writeln('Codigo=', codigo, ' Precio=', precio:0:2, ' StockActual=', stockActual, ' StockMin=', stockMinimo, ' Nombre=', nombre);
        end;
		close(mae);
	end;
	
var
	mae:maestro;
	det:detalle;
	cargaMae, cargaDet: text;
begin
	assign(cargaMae, 'maestro.txt');
    crearMaestro(mae, cargaMae);
    assign(cargaDet, 'detalle.txt');
    crearDetalle(det, cargaDet);
	writeln('Maestro antes de ser actualizado');
	imprimirMaestro(mae);
	crearMaestro(mae,cargaMae); // se dispone
	crearDetalle(det,cargaDet); // se dispone
	actualizarMaestro(mae,det);
	writeln('Maestro despues de ser actualizado');
	imprimirMaestro(mae);
end.
{b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle?
	En el codigo que hice yo no haria ninguna diferencia ese cambio. Ya que yo
voy recorriendo en el maestro hasta que coincida el detalle, y un detalle solo le
corresponde un maestro.}
