{La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
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
    valorAlto := 'ZZZZ';
type
    semanario = record
        fecha : string;
        codigo : integer;
        nombre : string;
        descripcion : string;
        precio : real;
        total : integer;
        totalVendidos : integer;
    end;

    venta = record
        fecha : string;
        codigo : integer;
        totalVendidos : integer;
    end;

    maestro = file of semanario;
    detalle = file of venta;
    vectorDetalles = array [1..dimf] of detalle;
    vectorRegistros = array [1..dimf] of venta;

procedure leer(var  det : detalle; var v : venta);
begin
    if (not eof (det)) then
        read(det, v)
    else
        v.fecha := valorAlto;
end;

procedure minimo(var vd : vectorDetalles; var vr : vectorRegistros; var min : venta);
var
    i, pos : integer;
begin
    min.fecha := valorAlto;
    min.codigo := 9999;
    for i := 1 to dimf do begin
        if (vr[i].fecha < min.fecha) or (vr[i].codigo < min.codigo and vr[i].fecha = min.fecha) then begin
            min := vr[i];
            pos := i;  
        end;
    end;
    if(min.fecha <> valorAlto) then
        leer(vd[pos], vr[pos]);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vectorDetalles);
var
    vr : vectorRegistros;
    regM : emision;
    fechaMax, fechaMin : string;
    i, maxVentas, minVentas, codigoMax, codigoMin : integer;
    min : venta;
begin
    reset(mae);
    read(mae, regM);
    for i := 1 to dimf do begin
        reset(vd[i]);
        leer(vd[i], vr[i]);
    end;
    minimo(vd, vr, min);
    while(min.fecha <> valorAlto)do begin
        fecha := min.fecha;
        while(min.fecha = fecha) do begin
            codigo := min.codigo;
            cantVentas := 0;
            while(min.fecha = fecha) and (min.codigo = codigo)do begin
                cantVentas := cantVentas + min.totalVendidos;
                minimo(vd, vr, min);
            end;
            if (maxVentas > cantVentas) then begin
                maxVentas := cantVentas;
                fechaMax := fecha;
                codigoMax := codigo;
            end
            else if (minVentas < cantVentas) then begin
                minVentas := cantVentas;
                fechaMin := fecha;
                codigoMin := codigo;
            end
            while(fecha <> regM.fecha) and (codigo <> regM.codigo) do 
                read(mae, regM);
            seek(mae, filepos(mae)-1);
            regM.total := regM.total - cantVentas;
            regM.totalVendidos := regM.totalVendidos + cantVentas;
            write(mae, regM)
        end;
    end;
    writeln('Semanario con mas ventas: Fecha=', fechaMax, ' Codigo=', codigoMax);
    writeln('Semanario con menos ventas: Fecha=', fechaMin, ' Codigo=', codigoMin);
    for i := 1 to dimf do 
        close(vd[i]);
    close(mae);
end;