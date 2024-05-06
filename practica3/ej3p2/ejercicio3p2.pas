{3. Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un
procedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.
Notas:
● Los archivos detalle no están ordenados por ningún criterio.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
o inclusive, en diferentes máquinas.}
program ejercicio3p2practica3;
const
	dimf = 3;
type
	registro = record
		codigo:integer;
		fecha:string[20];
		tiempo:real;
	end;
	detalle = file of registro;
	
	vectorDetalles = array[1..dimf] of detalle;
	vectorRegistroDetalle = array[1..dimf] of registro;
	
	maestro = file of registro;
	
	procedure importarDetalle(var det :detalle);
	var
		ruta : string;
		txt : text;
		regD : registro;
	begin
		writeln('Ingrese la ruta del archivo detalle binario');
		readln(ruta);
		assign(det, ruta);
		rewrite(det);
		writeln('Ingrese la ruta del archivo detalle.txt');
		readln(ruta);
		assign(txt, ruta);
		reset(txt);
		while(not eof(txt)) do begin
			readln(txt, regD.codigo, regD.tiempo, regD.fecha); 
			write(det, regD);
		end;
		writeln('Archivo detalle creado');
		close(det);
		close(txt);
	end;

	procedure cargarVectorDetalles(var vd : vectorDetalles);
	var
		i : integer;
	begin
		for i := 1 to dimf do
			importarDetalle(vd[i]);
	end;
	
	function buscarRegistro(var mae:maestro; regd:registro):registro;
	var
		regm:registro;
	begin
		while (not eof(mae)) do begin
			read(mae,regm);
			if (regm.codigo = regd.codigo) and (regm.fecha = regd.fecha) then
				buscarRegistro:= regm;
		end;
		regm.codigo:= -1;
		buscarRegistro:= regm;
	end;
	
	procedure generarMaestro(var mae:maestro; var v:vectorDetalles);
	var
		vrd:vectorRegistroDetalle;
		regm:registro;
		i:integer;
	begin
		assign(mae,'maestro');
		rewrite(mae);
		for i:= 1 to dimf do begin
			reset(v[i]);
			repeat
				read(v[i],vrd[i]); // leo del vector de detalles
				seek(mae,0); // dejo el puntero siempre al principio
				regm := buscarRegistro(mae,vrd[i]); // chequea si ese codigo y esa fecha ya esta en el maestro
				if (regm.codigo < 0) then begin  // si es menor a 0 es por que es un nuevo codigo u otra fecha de un mismo codigo
					seek(mae,filesize(mae)); // me paro a lo ultimo para poder escribir uno nuevo
					write(mae,vrd[i]);
				end
				else begin
					regm.tiempo:= regm.tiempo + vrd[i].tiempo; //actualizo
					seek(mae,filepos(mae)-1);
					write(mae,regm);
				end;
			until (eof(v[i])); // hasta que llegue al final del archivo detalle
			close(v[i]);
		end;
		close(mae);
		writeln('Archivo maestro creado');
	end;
	
	procedure imprimirMaestro(var mae:maestro);
	var
		regM : registro;
	begin
		reset(mae);
		while(not eof(mae))do begin
			read(mae, regM);
			writeln('Codigo de usuario = ', regM.codigo, ' Fecha = ', regM.fecha, ' Tiempo total = ', regM.tiempo:0:2);
		end;
		close(mae);
	end;
	
var
	mae:maestro;
	v:vectorDetalles;
begin
	cargarVectorDetalles(v);
	generarMaestro(mae,v);
	imprimirMaestro(mae);
end.
// Consultar. No se acumulan los que tienen mismo codigo y misma fecha.
