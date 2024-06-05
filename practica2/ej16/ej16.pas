{Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.}

program ejercicio16;
const 
    valorAlto = 9999;
    dimf = 3; // = 10;
type
    moto = record 
        codigo : integer;
        nombre : string;
        descripcion : string;
        modelo : string;
        marca : string;
        stock : integer;
    end;

    venta = record
        codigo : integer;
        precio : real;
        fecha : string;
    end;

    maestro = file of moto;
    detalle = file of venta;
    vectorDetalles = array [1..dimf] of detalle;
    vectorRegistros = array[1..dimf] of venta;

procedure leer(var det : detalle; var v : venta);
begin
    if (not eof(det))then
        read(det, v)
    else
        v.codigo := valorAlto;
end;

procedure minimo(var vd : vectorDetalles; var vr : vectorRegistros; var min : venta);
var
    i, pos : integer;
begin
    min.codigo := valorAlto;
    for i := 1 to dimf do begin
        if (vr[i].codigo <= min.codigo) then begin
            min := vr[i];
            pos := i;
        end;
    end;
    if(min.codigo <> valorAlto)then
        leer(vd[pos], vr[pos]);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vectorDetalles);
var
    min : venta;
    regM : moto;
    vr : vectorRegistros;
    i, cantVentas, maxMoto, codigo, maxCodigo : integer;
begin
    maxMoto := -1;
    reset(mae);
    read(mae, regM);
    for i := 1 to dimf do begin
        reset(vd[i]);
        leer(vd[i], vr[i]);
    end;
    minimo(vd, vr, min);
    while(min.codigo <> valorAlto)do begin
        codigo := min.codigo;
        cantVentas := 0;
        while(codigo = min.codigo)do begin
            cantVentas := cantVentas + 1; 
            minimo(vd, vr, min);
        end;
        if (cantVentas > maxMoto) then
            maxMoto := cantVentas;
            maxCodigo := codigo;
        while(codigo <> regM.codigo)do
            read(mae, regM);
        regM.stock := regM.stock - cantVentas;
        seek(mae, filePos(mae)-1);
        write(mae, regM);
    end;
    for i := 1 to dimf do
        close(vd[i]);
    writeln('El codigo de la moto mas vendida es ', maxCodigo);
    close(mae);
end;    

var
    mae : maestro;
    vd : vectorDetalles;
begin
    assign(vd[1], 'detalle1');
    assign(vd[2], 'detalle2');
    assign(vd[3], 'detalle3');
    assign(mae, 'maestro.dat');
    actualizarMaestro(mae, vd);
end.