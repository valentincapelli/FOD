{15. La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}

program ejercicio15;
const
    dimf = 100;
    valoralto = "ZZZZ";
type
    registroMaestro = record
        fecha:string[20];
        codigo:integer;
        nombre:string[40];
        desc:string;
        precio:real;
        totalEjemplares:integer;
        ejemplaresVendidos:integer;
    end;
    maestro = file of registroMaestro;

    registroDetalle = record
        fecha:string[20];
        codigo:integer;
        ejemplaresVendidos:integer;
    end;
    detalle = file of registroDetalle;

    vectorDetalles = array [1..dimf] of detalle;
    vectorRegistroDetalle = array [1..dimf] of registroDetalle;

    procedure leer(var det:detalle; var regd:registroDetalle);
    begin
        if (not eof(det)) then
            read(det,regd);
        else
            regd.fecha:= valoralto;
    end;

    procedure minimo(var vd:vectorDetalles; var vrd:vectorRegistroDetalle; var min:registroDetalle);
    begin
        min.fecha:= valoralto;
        min.codigo:= 9999;
        for i:= 1 to dimf do begin
            if (vrd[i].fecha < min.fecha) or (vrd[i].fecha = min.fecha) and (vrd[i].codigo < min.codigo) then
                min:= vrd[i];
                pos:= i;
            end;
        end;
        if (min.fecha <> valoralto) then
            leer(vd[pos],vrd[pos]);
    end;

    procedure actualizarMaestro(var mae:maestro; vd:vectorDetalles);
    var
        vrd:vectorRegistroDetalle;
        total,min,maxVentas,codigoActual,i:integer;
        maxFecha,maxNombre,minFecha,minNombre,fechaActual:string;
    begin
        maxVentas:= -1;
        minVentas:= 9999;
        reset(mae);
        for i:= 1 to dimf do begin
            reset(vd[i]);
            leer(vd[i],vrd[i]);
        end;
        read(mae,regm);
        minimo(vd,vrd,min);
        while (min.fecha <> valoralto) do begin
            fechaActual:= min.fecha;
            while (fechaActual == min.fecha) do begin
                codigoActual:= min.codigo;
                total:= 0;
                while (codigoActual == min.codigo) do begin
                    if (regm.totalEjemplares > min.ejemplaresVendidos) then begin
                        regm.totalEjemplares:= regm.totalEjemplares - min.ejemplaresVendidos;
                        regm.ejemplaresVendidos:= regm.ejemplaresVendidos + min.ejemplaresVendidos;
                        total:= total + min.ejemplaresVendidos;
                    end
                    else writeln('No hay ejemplares suficientes para realizar la venta.');
                    if (total > maxVentas) then begin
                        maxVentas:= total;
                        maxFecha:= min.fecha;
                        maxNombre:= min.nombre;
                    end
                    else if (total < minVentas) then begin
                        minVentas:= total;
                        minFecha:= min.fecha;
                        minNombre:= min.nombre;
                    end;
                    minimo(vd,vrd,min);
                end;
                while (fechaActual <> regm.fecha) and (codigoActual <> regm.codigo) do
                    read(mae,regm);
                seek(mae, filepos(mae)-1);
                write(mae,regm);
            end;
        end;
        close(mae);
        writeln('Semanario con más ventas: ', maxNombre, ' Fecha: ', maxFecha, ' Ventas: ', maxVentas);
        writeln('Semanario con menos ventas: ', minNombre, ' Fecha: ', minFecha, ' Ventas: ', minVentas);
    end;

var
begin
    cargarMaestro(mae);  // se dispone
    cargarDetalles(vd); // se dispone
    actualizarMaestro(mae,vd);
end;
