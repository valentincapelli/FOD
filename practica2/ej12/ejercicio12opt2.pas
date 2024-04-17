{12. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:
i- Como un procedimiento separado del punto a).
ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido? }
program ejercicio12practica2;
const
  valorAlto = 9999;
type
  registroMaestro = record
    nro_usuario:integer;
    nombreUsuario:string;
    nombre:string;
    apellido:string;
    cantidadMailsEnviados:integer;
  end;
  maestro = file of registroMaestro;
  
  registroDetalle = record
    nro_usuario:integer;
    cuentaDestino:string;
    cuerpoMensaje:string;
  end;
  detalle = file of registroDetalle;
  
  procedure leer(var det:detalle; var regd:registroDetalle);
  begin
    if (not eof(det)) then
      read(det,regd)
    else
      regd.nro_usuario:= valoralto;
  end;
  
  procedure importarDetalle(var det:detalle);
  var
    regd:registroDetalle;
    txt:text;
  begin
    assign(det, 'detalle');
    rewrite(det); {creo el archivo binario}
    writeln('Realizando importacion de archivo detalle.txt');
    assign(txt, 'detalle.txt');
    reset(txt);
    while (not eof(txt)) do begin
      readln(txt, regd.nro_usuario, regd.cuentaDestino);
      readln(txt, regd.cuerpoMensaje);
      write(det, regd);
    end;
    writeln('La importacion se realizo con exito');
    close(det);
    close(txt);
  end;
  
  procedure importarMaestro(var mae:maestro);
   var
    regm:registroMaestro;
    txt:text;
  begin
    assign(mae, 'maestro');
    rewrite(mae); {creo el archivo binario}
    writeln('Realizando importacion de archivo maestro.txt');
    assign(txt, 'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin
      readln(txt, regm.nro_usuario, regm.cantidadMailsEnviados, regm.nombreUsuario);
      readln(txt, regm.nombre);
      readln(txt, regm.apellido);
      write(mae, regm);
    end;
    writeln('La importacion se realizo con exito');
    close(mae);
    close(txt);
  end;
  
  procedure actualizarMaestroEInformar(var mae:maestro; var det:detalle; var txt:text);
  var
    regm:registroMaestro;
    regd:registroDetalle;
    nroActual,cantMails:integer;
  begin
    assign(txt,'informe.txt');
    rewrite(txt);
    
    reset(mae);
    reset(det);
    leer(det,regd);
    read(mae,regm);
    while (regd.nro_usuario <> valoralto) do begin
      nroActual:= regd.nro_usuario;
      cantMails:= 0;
      while (nroActual = regd.nro_usuario) do begin
        cantMails:= cantMails + 1;
        leer(det,regd);
      end;
      while (regm.nro_usuario <> nroActual) do begin
        writeln(txt,'Numero de usuario:',regm.nro_usuario,' Mensajes enviados:',regm.cantidadMailsEnviados);
        read(mae,regm);
      end;
      regm.cantidadMailsEnviados:= regm.cantidadMailsEnviados + cantMails;
      
      writeln(txt,'Numero de usuario:',regm.nro_usuario,' Mensajes enviados:',regm.cantidadMailsEnviados);
      
      seek(mae,filepos(mae)-1);
      write(mae,regm);
    end;
    // recorro hasta el final del archivo y voy exportando a txt los registros que me faltan
    while (not eof(mae)) do begin
      read(mae,regm);
      writeln(txt,'Numero de usuario:',regm.nro_usuario,' Mensajes enviados:',regm.cantidadMailsEnviados);
    end;
    close(det);
    close(mae);
    close(txt);
  end;
var
  mae:maestro;
  det:detalle;
  txt:text;
begin
  importarMaestro(mae);// se dispone
  importarDetalle(det);// se dispone
  actualizarMaestroEInformar(mae,det,txt);
end.
// le pongo el nombre /var/log/logmail.dat directamente.
