{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.}
program ejercicio10practica2;
const
  valorAlto = 9999;
  categorias = 15;
type
  crango = 1..categorias;
  registroMaestro = record
    departamento:integer;
    division:integer;
    codigoEmpleado:integer;
    categoria:crango;
    cantHorasExtras:integer;
  end;
  maestro = file of registroMaestro;
  
  vector = array [crango] of real;
  
  procedure leer(var mae:maestro; var regm:registroMaestro);
  begin
    if (not eof(mae))then
      read(mae,regm)
    else
      regm.departamento:= valorAlto;
  end;
  
  procedure importarMaestro(var mae:maestro);
  var
    txt:text;
    regm:registroMaestro;
    //nombre:string;
  begin
    //writeln('Ingrese el nombre del archivo binario maestro');
    //readln(nombre);
    //assign(mae,nombre);
    assign(mae,'maestro');
    rewrite(mae);
    
    //writeln('Ingrese el nombre del archivo txt maestro');
    //readln(nombre);
    //assign(txt,nombre);
    assign(txt,'maestro.txt');
    reset(txt);
    
    while (not eof(txt)) do begin
      readln(txt, regm.departamento, regm.division, regm.codigoEmpleado, regm.categoria, regm.cantHorasExtras);
      write(mae, regm);
    end;
    writeln('La importacion del archivo maestro se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure importarVector(var v:vector);
  var
    valor,pos:integer;
    txt:text;
  begin
    assign(txt,'vector.txt');
    reset(txt);
    while (not eof(txt)) do begin
      readln(txt,pos,valor);
      v[pos]:= valor;
      writeln(v[pos]:0:2);
    end;
    close(txt);
  end;
  
  procedure informarMaestro(var mae:maestro; v:vector);
  var
    regm,actual:registroMaestro;
    horasDepartamento,horasDivision,horasEmpleado:integer;
    montoDepartamento,montoDivision,montoEmpleado:real;
  begin
    reset(mae);
    leer(mae,regm);
    while (regm.departamento <> valorAlto) do begin
      actual.departamento:= regm.departamento;
      horasDepartamento:= 0;
      montoDepartamento:= 0;
      writeln('Departamento:',actual.departamento);
      while (regm.departamento = actual.departamento) do begin
        actual.division:= regm.division;
        horasDivision:= 0;
        montoDivision:= 0;
        writeln('Division:',actual.division);
        while (regm.division = actual.division) and (regm.departamento = actual.departamento) do begin
          actual.codigoEmpleado:= regm.codigoEmpleado;
          actual.categoria:= regm.categoria;
          horasEmpleado:= 0;
          montoEmpleado:= 0;
          writeln('Numero de Empleado   Total de Hs   Importe a cobrar');
          while (regm.codigoEmpleado = actual.codigoEmpleado) and (regm.division = actual.division) and (regm.departamento = actual.departamento) do begin
            horasEmpleado:= horasEmpleado + regm.cantHorasExtras;
            leer(mae,regm);
          end;
          montoEmpleado:= (horasEmpleado * v[actual.categoria]);
          writeln(actual.codigoEmpleado,'                    ',horasEmpleado,'                  ',montoEmpleado:0:2);
          montoDivision:= montoDivision + montoEmpleado;
          horasDivision:= horasDivision + horasEmpleado;
        end;
        writeln('Total de horas division:',horasDivision);
        writeln('Monto total division:',montoDivision:0:2); 
        horasDepartamento:= horasDepartamento + horasDivision;
        montoDepartamento:= montoDepartamento + montoDivision;
      end;
      writeln('Total de horas departamento:',horasDepartamento);
      writeln('Monto total departamento:',montoDepartamento:0:2); 
    end;
    close(mae);
  end;
  
var
  mae:maestro;
  v:vector;
begin
  importarMaestro(mae);
  importarVector(v);
  informarMaestro(mae,v);
end.
