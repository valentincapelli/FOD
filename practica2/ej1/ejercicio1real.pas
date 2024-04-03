{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}
program ejercicio1practica2;
const
  valoralto = 9999;
type
  ingresos = record
    codigo:integer;
    nombre:string;
    monto:real;
  end;
  archivo = file of ingresos;
  
  procedure importarTxt(var det:archivo);
  var
    txt:text;
    i:ingresos;
  begin
    rewrite(det);
    writeln('Realizando importacion del archivo detalle a detalle.txt');
    assign(txt, 'detalle.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, i.codigo, i.monto, i.nombre);
      write(det,i);
    end;
    writeln('La importacion se realizo con exito');
    close(txt);
    close(det);
  end;
  
  procedure leer(var det:archivo; var i:ingresos);
  begin
    if (not eof(det)) then
      read(det, i)
    else
      i.codigo:= valoralto;
  end;
  
  procedure compactar(var det,mae:archivo);
  var
    i:ingresos;
    codigoActual:integer;
    total:real;
  begin
    reset(det);
    rewrite(mae);
    leer(det,i);
    while (i.codigo <> valoralto) do begin
      codigoActual:= i.codigo;
      total:= 0;
      while (i.codigo <> valoralto) and (codigoActual = i.codigo) do begin
        total:= total + i.monto;
        leer(det, i);
      end;
      i.monto:= total;
      write(mae, i);
    end;
    close(det);
    close(mae);
  end;
  
  procedure informar(var mae:archivo);
  var
    i:ingresos;
  begin
    writeln('Empleados de la empresa: ');
    reset(mae);
    while (not eof(mae)) do begin
      read(mae, i);
      writeln('Codigo ',i.codigo,' Monto',i.monto:0:2,' Nombre ',i.nombre);
    end;
    close(mae);
  end;
  
var
  detalle:archivo;
  maestro:archivo;
begin
  assign(detalle,'detalle');
  assign(maestro,'maestro');
  importarTxt(detalle);
  compactar(detalle,maestro);
  informar(maestro);
end.
// me informa mal los datos nose por que, consultar
