{La empresa de software 'X' posee un servidor web donde se encuentra alojado el sitio de la organización. En dicho
servidor, se almacenan en un archivo todos los accesos que se realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y tiempo de acceso al sitio
de la organización. El archivo se encuentra ordenado por los siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el año calendario sobre 
el cual debe realizar el informe. El mismo debe respetar el formato mostrado a continuación:

Año:- 
    Mes:- 1
        dia:-1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
            idusuario N Tiempo total de acceso en el dia 1 mes 
        Tiempo total acceso dia 1 mes 1
        dia N   
            idUsuario 1 Tiempo Total de acceso en el dia N mes 1
            idusuario N Tiempo total de acceso en el dia N mes 1
        Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
    Mes 12
        dia 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
            idusuario N Tiempo total de acceso en el dia 1 mes 12 
        Tiempo total acceso dia 1 mes 12
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 12
            idUsuario N Tiempo total de acceso en el dia N mes 12 
        Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12
Total tiempo de acceso año

Se deberá tener en cuenta las siguientes aclaraciones:
El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
El año puede no existir en el archivo, en tal caso, debe informarse en pantalla "año no encontrado".
Debe definir las estructuras de datos necesarias.
El recorrido del archivo debe realizarse una única vez procesando sólo la información necesaria.}

program ejercicio1;
type
    mrango = 1..12;
    drango = 1..31;
    registroMaestro = record
        anio:integer; 
        mes:mrango;
        dia:drango;
        id:integer;
        tiempo:real;
    end;
    maestro = file of registroMaestro;

    procedure informe(var mae:maestro);
    var
        year:integer;
        regm:registroMaestro;
    begin
        writeln('Ingrese el año sobre el cual quiere realizar el informe');
        readln(year);
        reset(mae);
        while (not eof(mae)) and (regm.anio <> year) do
            read(mae,regm);
        if (not eof(mae)) and (regm.anio = year) then begin
            writeln('Año: ', year);
            aniototal:= 0;
            while (regm.anio = year) and (not eof(mae)) do begin
                mesAct:= regm.mes;
                mestotal:= 0;
                writeln('Mes: ', mesAct);
                while (regm.mes = mesAct) and(regm.anio = year) and (not eof(mae)) do begin
                    diaAct:= regm.dia;
                    diatotal:= 0;
                    writeln('Dia: ', diaAct);
                    while(regm.dia = diaAct) and (regm.mes = mesAct) and(regm.anio = year) and (not eof(mae)) do begin
                        idAct:= regm.id;
                        idtotal:= 0;
                        while(regm.id = idAct) and (regm.dia = diaAct) and (regm.mes = mesAct) and(regm.anio = year) and (not eof(mae)) do begin
                            idtotal:= idtotal + regm.tiempo;
                            read(mae,regm);
                        end;
                        diatotal:= diatotal + idtotal;
                        writeln('idUsuario:',idAct, ' Tiempo Total de acceso en el dia  ',diaAct ,' mes ',mesAct,' es',idtotal:0:2); 
                    end;
                    mestotal:= mestotal + diatotal;
                    writeln('Tiempo total acceso dia ',diaAct,' mes ',mesAct,' es: ',mestotal:0:2);
                end;
                aniototal:= aniototal + mestotal;
                writeln('Total tiempo de acceso mes ',mesAct,' es ',mestotal:0:2);
            end;
            writeln('Total tiempo de acceso año ',year,' es', aniototal:0:2);
        end;
        else writeln('Año no encontrado.');
        close(mae);
    end;

// Deberia ir acumulando las condiciones por cada while que se va adentrando en el codigo.

var
begin
end;