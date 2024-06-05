{17. Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:
Nombre: Localidad 1
    Nombre: Municipio 1
        Nombre Hospital 1.................Cantidad de casos Hospital 1
        ..........................
        Nombre Hospital N................Cantidad de casos Hospital N
    Cantidad de casos Municipio 1
    ...............................................................................
    Nombre Municipio N
        Nombre Hospital 1.................Cantidad de casos Hospital 1
        ..........................
        NombreHospital N................Cantidad de casos Hospital N
    Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
    Nombre Municipio 1
        Nombre Hospital 1.................Cantidad de casos Hospital 1
        ..........................
        Nombre Hospital N................Cantidad de casos Hospital N
    Cantidad de casos Municipio 1
    ...............................................................................
    Nombre Municipio N
        Nombre Hospital 1.................Cantidad de casos Hospital 1
        ..........................
        Nombre Hospital N................Cantidad de casos Hospital N
    Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia

Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.
NOTA: El archivo debe recorrerse solo una vez.}

program ejercicio17;
const
	valoralto = 9999;
type
    registroMaestro = record
        codigoLoc:integer;
        nombreLoc:string[40];
        codigoMun:integer;
        nombreMun:string[40];
        codigoHos:integer;
        nombreHos:string[40];
        fecha:string[30];
        cantCasos:integer;
    end;
    maestro = file of registroMaestro;

	procedure importarCasos(var mae: maestro);
	var
		txt: text;
		hos: registroMaestro;
		nombre: string;
	begin
		assign(txt, 'casos_covid.txt');
		reset(txt);
		writeln('Ingrese un nombre para el archivo maestro');
		readln(nombre);
		assign(mae, nombre);
		rewrite(mae);
		while(not eof(txt)) do
			begin
				with hos do
					begin
						readln(txt, codigoLoc, codigoMun, codigoHos, nombreLoc);
						readln(txt, nombreMun);
						readln(txt, fecha);
						readln(txt, cantcasos, nombreHos);
						write(mae, hos);
					end;
			end;
		writeln('Archivo binario maestro creado');
		close(txt);
		close(mae);
	end;


    procedure leer(var mae:maestro; var regm:registroMaestro);
    begin
        if (not eof(mae)) then
            read(mae,regm)
        else
            regm.codigoLoc := valoralto;
    end;

    procedure importarTxt(var txt:text; nombreLoc,nombreMun:string; cantMun:integer);
    begin
        writeln(txt, nombreLoc);
        writeln(txt, cantMun ,' ', nombreMun);
    end;

    procedure listarMaestro(var mae:maestro);
    var
        txt:text;
        regm:registroMaestro;
        locActual, munActual, hosActual, cantProv, cantLoc, cantMun, cantHos:integer;
        nombreLocActual,nombreMunActual:string;
    begin
        assign(txt,'listado.txt');
        rewrite(txt);

        reset(mae);
        leer(mae,regm);
        cantProv:= 0;
        while (regm.codigoLoc <> valoralto) do begin
            locActual:= regm.codigoLoc;
            nombreLocActual:= regm.nombreLoc;
            cantLoc:= 0;
            writeln('Localidad: ', regm.nombreLoc, ' ', regm.codigoLoc);
            while (locActual = regm.codigoLoc) do begin
                munActual:= regm.codigoMun;
                nombreMunActual:= regm.nombreMun;
                cantMun:= 0;
                writeln('    Municipio: ' , regm.nombreMun,' ',regm.codigoMun);
                while (munActual = regm.codigoMun) and (locActual = regm.codigoLoc) do begin
                    hosActual:= regm.codigoHos;
                    cantHos:= 0;
                    write('        Hospital: ' ,regm.nombreHos,' ',regm.codigoHos);
                    while (hosActual = regm.codigoHos) do begin
                        cantHos:= cantHos + regm.cantCasos;
                        leer(mae,regm);
                    end;
                    writeln('................. cantidad de casos: ',cantHos);
                    cantMun:= cantMun + cantHos;
                end;
                writeln('    Cantidad de casos Municipio ', munActual, ': ', cantMun);
                cantLoc:= cantLoc + cantMun;
                if (cantMun > 1500) then
                    importarTxt(txt,nombreLocActual,nombreMunActual,cantMun);
            end;
            cantProv:= cantProv + cantLoc;
            writeln('Cantidad de casos Localidad ', locActual,': ', cantLoc);
        end;
        writeln('Cantidad de casos Totales en la Provincia', cantProv);
        close(mae);
        close(txt);
    end;

var
    mae:maestro;
begin
    importarCasos(mae);
    listarMaestro(mae);
end.
