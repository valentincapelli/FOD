{1. Archivos Secuenciales
Una empresa que comercializa fármacos recibe de cada una de sus 30 sucursales un resumen mensual de las ventas y 
desea analizar la información para la toma de futuras decisiones. El formato de los archivos que recibe la empresa
 es: cod_farmaco, nombre, fecha, cantidad_vendida y forma_pago (campo String indicando contado o tarjeta).
Los archivos de ventas están ordenados por: cod_farmaco y fecha.

Cada sucursal puede vender cero, uno o más veces determinado fármaco el mismo día, y la forma de pago podría variar
en cada venta. Realizar los siguientes procedimientos:
a) Recibe los 30 archivos de ventas e informa por pantalla el fármaco con mayor cantidad_vendida.
b) Recibe los 30 archivos de ventas y guarda en un archivo de texto un resumen de ventas por fecha y fármaco con 
el siguiente formato: cod_farmaco, nombre, fecha, cantidad_total_vendida. (el archivo de texto deberá estar 
organizado de manera tal que al tener que utilizarlo pueda recorrer el archivo realizando la menor cantidad de lecturas posibles). 
Nota: en el archivo de texto por fecha, cada fármaco aparecerá a lo sumo una vez. 
Además de escribir cada procedimiento deberá declarar las estructuras de datos utilizadas.}

program ejercicio1;
const
    valoralto = 9999;
    sucursales = 2;
type
    rango_sucursales = 1..sucursales;
    str30 = string[30];
    str20 = string[20];
    registroDetalle = record
        cod:integer;
        nombre:str30;
        fecha:str20;
        cantidad_vendida:integer;
        forma_pago:str30;
    end;

    detalle = file of registroDetalle;
    vector = array[rango_sucursales] of detalle;
    vectorRegistroDetalle = array[rango_sucursales] of registroDetalle;

    registroMaestro = record
        cod:integer;
        nombre:str30;
        fecha:str20;
        cantidad_vendida:integer;
    end;
    maestro = file of registroMaestro;

    procedure leer(var det:detalle; var regd:registroDetalle);
    begin
        if (not eof(det)) then
            read(det,regd)
        else
            regd.cod:= valoralto;
    end;

    procedure importarDetalle(var det:detalle);
    var
        txt:text;
        regd:registroDetalle;
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
            readln(txt, regd.cod, regd.cantidad_vendida, regd.nombre);
            readln(txt, regd.fecha);
            readln(txt, regd.forma_pago);
            write(det, regd);
        end;
        writeln('La importacion del archivo detalle se realizo con exito');
        close(det);
        close(txt);
    end;

    procedure cargarDetalles(var v:vector);
    var
        i:integer;
    begin
        for i:= 1 to sucursales do
            importarDetalle(v[i]);
    end;

    procedure minimo(var v:vector; var vrd:vectorRegistroDetalle;  var min:registroDetalle);
    var
        i,pos:integer;
    begin
        min.cod:= valoralto;
        min.fecha:= 'ZZZZ';
        for i:= 1 to sucursales do begin
            if (vrd[i].cod < min.cod) or ((vrd[i].cod = min.cod) and (vrd[i].fecha < min.fecha)) then begin
                min:= vrd[i];
                pos:= i;
            end;
        end;
        if (min.cod <> valoralto) then
            leer(v[pos],vrd[pos]);
    end;

    procedure crearMaestro(var mae:maestro; v:vector);
    var
        vrd:vectorRegistroDetalle;
        min:registroDetalle;
        actual:registroMaestro;
        i:integer;
    begin
        assign(mae,'Maestro');
        rewrite(mae);
        for i:= 1 to sucursales do begin
            reset(v[i]);
            leer(v[i],vrd[i]);
        end;
        minimo(v,vrd,min);
        while (min.cod <> valoralto) do begin
            actual.nombre:= min.nombre; // me guardo el campo nombre en actual, para despues poder escribir en el maestro
            actual.cod:= min.cod;
            while (actual.cod = min.cod) do begin
                actual.cantidad_vendida:= 0;
                actual.fecha:= min.fecha;
                while (actual.cod = min.cod) and (actual.fecha = min.fecha) do begin
                    actual.cantidad_vendida:= actual.cantidad_vendida + min.cantidad_vendida;
                    minimo(v,vrd,min);
                end;
                write(mae,actual);
                writeln('Escribi');
            end;
        end;
        writeln('Se creo el maestro');
        close(mae);
    end;

    procedure maximoFarmaco(v:vector;  var mae:maestro);
    var
		max,maxFarmaco:integer;
		regm:registroMaestro;
    begin
        crearMaestro(mae,v); // mergea los 30 detalles en un maestro
        reset(mae);
        max:= -1;
        read(mae,regm);
        while (not eof(mae)) do begin
            if (regm.cantidad_vendida > max) then begin
                max:= regm.cantidad_vendida;
                maxFarmaco:= regm.cod;
            end;
            read(mae,regm);
        end;
        close(mae);
        writeln('El codigo del farmaco mas vendido es ', maxFarmaco);
    end;

    procedure listarArchivo(var mae:maestro; v:vector);
    var
        txt:text;
        regm:registroMaestro;
    begin
        // crearMaestro(mae,v);
        assign(txt,'maestro.txt');
        rewrite(txt);
        reset(mae);
        while (not eof(mae)) do begin
			read(mae,regm);
            writeln(txt, regm.cod,' ', regm.cantidad_vendida,' ', regm.nombre);
            writeln(txt, regm.fecha);
        end;
        close(mae);
        close(txt);
    end;

var
    v:vector;
    mae:maestro;
begin
    cargarDetalles(v);
    maximoFarmaco(v,mae);
    listarArchivo(mae,v);
end.
