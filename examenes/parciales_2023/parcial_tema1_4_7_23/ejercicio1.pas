{Suponga que tiene un archivo con información de los partidos de los últimos años de los equipos de primera división del fútbol
Argentino. Dicho archivo contiene: código de equipo, nombre de equipo, año, código de tomeo, código de equipo rival, goles a 
favor, goles en contra, puntos obtenidos (0, 1 o 3 dependiendo de si perdió, ganó o empató el partido). El archivo está ordenado
por los siguientes criterios: año, código de torneo y código de equipo.
Se le solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo y genere un informe por
pantalla con el siguiente formato de ejemplo:
Informe resumen por equipo del fútbol Argentino
Año 1
    cod_torneo 1
        cod_equipo 1 nombre equipo 1
            cantidad total de goles a favor equipo 1
            cantidad total de goles en contra equipo 1
            diferencia de gol (resta de goles a favor - goles en contra) equipo 1
            cantidad de partidos ganados equipo 1
            cantidad de partidos perdidos equipo 1.
            cantidad de partidos empatados equipo 1
            cantidad total de puntos en el torneo equipo 1
        cod_equipo n nombre equipo n
            idem anterior para equipo n

    El equipo "nombre equipo fue campeón del torneo codigo de torneo 1 del año 1
    cod_torneo n
        Idem anterior para cada equipo en el torneo n

    El equipo "nombre equipo" fue campeón del torneo código de torneo n del año 1
Año n
    Idem anterior para cada torneo del año n

Nota: se asume que por torneo hay un único equipo campeón con mayor puntaje.}

program parcial_tema1_4_7_2023;
type
    equipo = record
        codigo:integer;
        nombre:string[30];
        anio:integer;
        torneo:integer;
        rival:integer;
        gafavor:integer;
        gencontra:integer;
        puntos:integer;
    end;
    maestro = file of equipo;

    procedure generarInforme(var m:maestro);
    var
    begin
        reset(m);
        
        close(m);
    end;

var
begin
end.