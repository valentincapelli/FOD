{14. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}
program ejercicio14practica2.pas;
const
    dimf = 2;
    valoralto = 9999;
type
    subRango = 1.. dimf;
    registroMaestro = record
        codigoProv:integer;
        nombreProv:string;
        codigoLoc:integer;
        nombreLoc:string;
        viviendasSinLuz:integer;
        viviendasSinGas:integer;
        viviendasDeChapa:integer;
        viviendasSinAgua:integer;
        viviendasSinSanitarios:integer;
    end;
    maestro = file of registroMaestro;
  
    registroDetalle = record
	    codigoProv:integer;
        codigoLoc:integer;
        viviendasConLuz:integer;
        viviendasConstruidas:integer;
        viviendasConAgua:integer;
        viviendasConGas:integer;
        entregaSanitarios:integer;
    end;
    detalle = file of registroDetalle;
  
    vectorDetalle = array [subRango] of detalle;
    vectorRegistroDetalle = array [subRango] of registroDetalle;
  
  procedure importarMaestro(var mae : maestro);
  var
	txt : text;
	regm : registroMaestro;
  begin
	assign(mae, 'maestro');
	rewrite(mae);
	assign(txt, 'maestro.txt');
	reset(txt);
	writeln('hola');
	while(not eof(txt))do begin
		readln(txt, regm.codigoProv, regm.nombreProv);
		readln(txt, regm.codigoLoc, regm.viviendasSinLuz, regm.viviendasSinGas, regm.viviendasDeChapa, regm.viviendasSinAgua, regm.viviendasSinSanitarios, regm.nombreLoc);
		write(mae, regm);
		writeln('hola');
	end;
	writeln('Archivo maestro creado');
	close(mae);
	close(txt);
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
      readln(txt, regd.codigoProv, regd.codigoLoc, regd.viviendasConLuz, regd.viviendasConstruidas, regd.viviendasConAgua, regd.viviendasConGas, regd.entregaSanitarios);
      write(det, regd);
      writeln('Escribi');
    end;
    writeln('La importacion del archivo detalle se realizo con exito');
    close(det);
    close(txt);
  end;
  
  procedure importarVectorDetalle(var vd:vectorDetalle);
  var
      i:integer;
  begin
	  for i:= 1 to dimf do
	      importarDetalle(vd[i]);
  end;
  
  procedure leer(var det:detalle ; var regd:registroDetalle);
  begin
      if (not eof(det)) then
	      read(det,regd)
	  else begin
	      regd.codigoProv:= valoralto;
	      regd.codigoLoc:= valoralto;
	  end;
  end;

  procedure leerMae(var mae:maestro ; var regm:registroMaestro);
  begin
      if (not eof(mae)) then
	      read(mae,regm)
	  else
	      regm.codigoProv:= valoralto;
  end;
  
  procedure minimo(var vd:vectorDetalle; var vrd:vectorRegistroDetalle; var min:registroDetalle);
  var
      i,pos:subRango;
  begin
	  min.codigoProv:= valoralto;
	  min.codigoLoc:= valoralto;
	  
	  for i:= 1 to dimf do begin
		  if (vrd[i].codigoProv < min.codigoProv) and (vrd[i].codigoLoc < min.codigoLoc)then begin
			  min:= vrd[i];
			  pos:= i;
			  writeln(i);
		  end;
	  end;
	  if (min.codigoProv <> valoralto) then leer(vd[pos],vrd[pos]);
  end;
  
  procedure actualizarMaestro(var mae:maestro; var vd:vectorDetalle);
  var
      cantLocalidades,i:integer;
      regm:registroMaestro;
      min:registroDetalle;
      vrd:vectorRegistroDetalle;
  begin
      cantLocalidades:= 0;
      reset(mae);
      min.codigoProv:= 0;
      for i:= 1 to dimf do begin
          reset(vd[i]);
		  leer(vd[i],vrd[i]);
      end;
      minimo(vd,vrd,min);
      
      while (min.codigoProv <> valoralto) do begin
	      leerMae(mae,regm);
	      while ((regm.codigoProv <> valoralto) and (min.codigoProv <> regm.codigoProv) and (min.codigoLoc <> regm.codigoLoc)) do leerMae(mae,regm);
	      
			while (min.codigoProv = regm.codigoProv) and (min.codigoLoc = regm.codigoLoc) do begin
				regm.viviendasSinLuz:= regm.viviendasSinLuz - min.viviendasConLuz;
				regm.viviendasSinAgua:= regm.viviendasSinAgua - min.viviendasConAgua;
				regm.viviendasSinGas:= regm.viviendasSinGas - min.viviendasConGas;
				writeln('AQUI');
				regm.viviendasSinSanitarios:= regm.viviendasSinSanitarios - min.entregaSanitarios;
				regm.viviendasDeChapa:= regm.viviendasDeChapa - min.viviendasConstruidas;
				minimo(vd, vrd, min);
			end;
			if (regm.viviendasDeChapa = 0) then cantLocalidades:= cantLocalidades + 1;
			seek(mae,filepos(mae)-1);
			write(mae,regm);
	    end;
      writeln('La cantidad de localidades sin viviendas de chapa es: ',cantLocalidades);
      close(mae);
      for i:= 1 to dimf do
          close(vd[i]);
  end;
  
  procedure imprimirMaestro(var mae:maestro);
  var
      regm:registroMaestro;
  begin
      reset(mae);
      while (not eof(mae)) do begin
          read(mae,regm);
          writeln('CodProv=', regm.codigoProv, ' CodLocalidad=', regm.codigoLoc, ' SinLuz=', regm.viviendasSinLuz, ' SinGas=', regm.viviendasSinGas, ' CantChapas=', regm.viviendasDeChapa, ' SinAgua=', regm.viviendasSinAgua, ' SinSanatorios=', regm.viviendasSinSanitarios);
      end;
      close(mae);
  end;
  
var
    mae:maestro;
    vd:vectorDetalle;
begin
    importarMaestro(mae); // se dispone
    importarVectorDetalle(vd); // se dispone
    actualizarMaestro(mae,vd);
end.
