{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}
program ejercicio6practica3;
type
	registroMaestro = record
		cod_prenda:integer;
		descripcion:string;
		colores:string;
		tipo_prenda:string;
		stock:integer;
		precio_unitario:real;
	end;
	maestro = file of registroMaestro;
	
	registroDetalle = record
		cod_prenda:integer;
	end;
	detalle = file of regsitroDetalle;
	
	procedure bajaLogica(var mae:maestro; var det:detalle);	
	var
		regm:registroMaestro;
		regd:registroDetalle;
	begin
		reset(mae)
		reset(det);
		while (not eof(det)) do begin
			seek(det,0);
			read(det,regd);
		    read(mae,regm);
			while (regd.codigo <> regm.codigo) and (not eof(det)) do
				read(det,regd);
			if (regd.codigo = regm.codigo) then begin
				regm.stock := regm.stock*(-1);
				write(mae,regm);
				read(mae,regm);
			end;
		end;
		close(mae)
		close(det);
	end;
	
	procedure compactarArchivo(var mae:maestro; var nuevoMae:maestro);
	var
		regm:registroMaestro;
	begin
		assign(nuevoMae,'Nuevo maestro');
		rewrite(nuevoMae);
		reset(mae);
		while (not eof(mae)) do begin
			read(mae,regm);
			if (regm.stock >= 0) then
				write(nuevoMae,regm);
		end;
		close(mae);
		close(nuevoMae);
		erase(mae);
		rename(nuevoMae,'maestro');
	end;
	
var
	mae,nuevoMae:maestro;
	det:detalle;
begin
	importarMaestro();
	importarDetalle(det);
	bajaLogica(mae,det);
	compactarArchivo(mae,nuevoMae);
end.
