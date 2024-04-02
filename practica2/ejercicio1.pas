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
  highvalue = 9999;
type
  incomes = record
    code:integer;
    name:string[20];
    amount:real;
  end;
  archivo = file of incomes;
  
  procedure importarTxt(var comissions:archivo);
  var
    inc:incomes;
    txt:text;
  begin
    assign(comissions, 'comisiones.dat');
    rewrite(comissions); {creo el archivo binario}
    writeln('Realizando importacion de archivo comisiones.txt');
    assign(txt, 'comisiones.txt');
    reset(txt);
    while (not eof(txt)) do begin
      read(txt, inc.code, inc.amount, inc.name);
      write(comissions, inc);
    end;
    writeln('La importacion se realizo con exito');
    close(comissions);
    close(txt);
  end;
  
  procedure leer(var comissions:archivo; var inc:incomes);
  begin
    if (not eof(comissions)) then
      read(comissions,inc)
    else
      inc.code:= highvalue;
  end;
  
  procedure asignar(var compactComissions:archivo);
  var
    nameFile:string[20];
  begin
    writeln('Ingrese el nombre del archivo donde quiere compactar el archivo de comisiones');
    readln(nameFile);
    assign(compactComissions,nameFile);
  end;
  
  procedure compactar(var compactComissions,comissions: archivo);
  var
    inc:incomes;
    actCode:integer;
    totalAmount:real;
  begin
    asignar(compactComissions);
    rewrite(compactComissions); {creo el nuevo archivo binario}
    assign(comissions, 'comisiones.dat');
    reset(comissions); {abro el archivo binario sin compactar}
    leer(comissions, inc);
    while (inc.code <> highvalue) do begin {se procesan registros del archivo detalle(sin compactar)}
      actCode := inc.code;
      totalAmount:= 0;
      while (actCode = inc.code) do begin
        totalAmount:= totalAmount + inc.amount;
        leer(comissions,inc);
      end;
      inc.amount:= totalAmount;
      write(compactComissions, inc);
    end;
    close(comissions);
    close(compactComissions);
  end;
  
  procedure informar(var compactComissions:archivo);
  var
    inc:incomes;
  begin
    writeln('Informacion sobre los ingresos: ');
    reset(compactComissions);
    while (not eof(compactComissions)) do begin
      read(compactComissions,inc);
      writeln('Codigo:',inc.code,' Monto ',inc.amount:0:2,' Nombre ',inc.name);
    end;
  end;
  
var
  comissions, compactComissions: archivo;
begin
  importarTxt(comissions);
  compactar(comissions,compactComissions);
  informar(compactComissions);
end.
// se me informan por separados los que tienen el mismo nombre
