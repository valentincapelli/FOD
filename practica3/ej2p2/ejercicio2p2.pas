{2. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.}
program ejercicio2p2practica3;
const
	valoralto = 9999;
type
	registroMaestro = record
		codigo:integer;
		mesa:integer;
		votos:integer;
	end;
	maestro = file of registroMaestro;
	
	localidadesRegistradas = file of integer;
	
	procedure cargarArchivo(var arc: maestro);
var
    txt: text;
    regm: registroMaestro;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    while(not eof(txt)) do begin
        with regm do begin
            readln(txt, codigo, mesa, votos);
            write(arc, regm);
        end;
    end;
    writeln('Archivo maestro generado');
    close(arc);
    close(txt);
end;
	
	function estaRegistrado(var archLoc:localidadesRegistradas; codigo:integer):boolean;
	var
		aux:integer;
	begin
		reset(archLoc);
		aux:= -1;
		while (not eof(archLoc)) and (aux <> codigo) do
			read(archLoc,aux);
		if (aux = codigo) then
			estaRegistrado:= true
		else
			estaRegistrado:= false;
		close(archLoc);
	end;
	
	procedure agregarLocalidad(var archLoc:localidadesRegistradas; codigo:integer);
	begin
		reset(archLoc);
		seek(archLoc,filesize(archLoc)); // me posiciono al final
		write(archLoc,codigo);
		close(archLoc);
	end;
	
	{Creo el procedure leerMaestro por que sino la logica de mi codigo no contabilizaba 
	la ultima posicion del archivo maestro}
	procedure leerMaestro(var mae:maestro; var regm:registroMaestro);
	begin
		if (not eof(mae)) then
			read(mae,regm)
		else
			regm.codigo:= valoralto;
	end;
	
	procedure presentarListado(var mae:maestro; var archLoc:localidadesRegistradas);
	var
		regm:registroMaestro;
		votosTotal,votosLocalidad,codigoActual:integer;
	begin
		assign(archLoc,'archivoLocalidades');
		rewrite(archLoc);
		close(archLoc);
		
		writeln('Codigo de Localidad         Total de Votos');
		reset(mae);
		votosTotal:= 0;
		regm.codigo:= 0;
		while (not eof(mae)) do begin
			leerMaestro(mae,regm);
			if (not estaRegistrado(archLoc,regm.codigo)) then begin
				codigoActual:= regm.codigo;
				votosLocalidad:= 0;
				while (regm.codigo <> valoralto) do begin
					if (regm.codigo = codigoActual) then begin
						votosLocalidad:= votosLocalidad + regm.votos;
						votosTotal:= votosTotal + regm.votos;
					end;
					leerMaestro(mae,regm);
				end;
				writeln(codigoActual,'                              ',votosLocalidad);
				agregarLocalidad(archLoc,codigoActual);
				seek(mae,0);
			end;
		end;
		writeln('Total General de Votos: ', votosTotal);
		close(mae);
	end;
	
var
	mae:maestro;
	archLoc:localidadesRegistradas;
begin
	cargarArchivo(mae);
	presentarListado(mae,archLoc);
end.
