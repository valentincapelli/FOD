{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}
program ejercicio8practica2;
const
  valorAlto = 9999;
type
  client = record
    codigo:integer;
    nomYape:string;
  end;
  registroMaestro = record
    cliente: client;
    anio:integer;
    mes:integer;
    dia:integer;
    montoVenta:real;
  end;
  maestro = file of registroMaestro;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    regm:registroMaestro;
    nombre:string;
  begin
    writeln('Ingrese el nombre del archivo binario maestro');
    readln(nombre);
    assign(mae,nombre);
    rewrite(mae);
    
    writeln('Ingrese el nombre del archivo txt maestro');
    readln(nombre);
    assign(txt,nombre);
    reset(txt);
    
    while (not eof(txt)) do begin
      readln(txt, regm.montoVenta, regm.anio, regm.mes, regm.dia, regm.cliente.codigo, regm.cliente.nomYape);
      write(mae, regm);
    end;
    writeln('La importacion del archivo maestro se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure leer(var mae:maestro; var regm:registroMaestro);
  begin
    if (not eof(mae)) then
      read(mae,regm)
    else
      regm.cliente.codigo := valorAlto;
  end;
  
  procedure informarMaestro(var mae:maestro);
  var
    regm,actual:registroMaestro;
    montoEmpresa:real;
    montoAnual:real;
    montoMensual:real;
  begin
    assign(mae,'maestro');
    reset(mae);
    leer(mae,regm);
    montoEmpresa:= 0;
    while (regm.cliente.codigo <> valorAlto) do begin
      actual.cliente.codigo := regm.cliente.codigo;
      while (regm.cliente.codigo = actual.cliente.codigo) do begin
        writeln('Cliente: ',regm.cliente.nomYape,' Codigo: ',actual.cliente.codigo);
        montoAnual:= 0;
        actual.anio:= regm.anio;
        while (regm.anio = actual.anio) and (regm.cliente.codigo = actual.cliente.codigo) do begin
          montoMensual:= 0;
          actual.mes:= regm.mes;
          while (regm.mes = actual.mes) and (regm.anio = actual.anio) and (regm.cliente.codigo = actual.cliente.codigo) do begin
            montoEmpresa:= montoEmpresa + regm.montoVenta;
            montoAnual:= montoAnual + regm.montoVenta;
            montoMensual:= montoMensual + regm.montoVenta;
            leer(mae,regm);
          end;
          writeln('El monto del mes ',actual.mes,' es de ', montoMensual:0:2);
        end;
        writeln('El monto anual es de ', montoAnual:0:2);
      end;
    end;
    writeln('El monto de la empresa es de ', montoEmpresa:0:2);
    close(mae);
  end;
var
  mae:maestro;
begin
  importarMaestro(mae);
  informarMaestro(mae);
end.
