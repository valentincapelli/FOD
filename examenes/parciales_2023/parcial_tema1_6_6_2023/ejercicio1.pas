{Suponga que tiene un archivo con información referente a los productos que se comercializan en un supermercado. 
De cada producto se conoce código de producto (único), nombre del producto, descripción, precio de compra, precio 
de venta y ubicación en depósito.
Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de espacio llamada lista invertida.
Declare las estructuras de datos necesarias e implemente los siguientes módulos:
Agregar producto: recibe el archivo sin abrir y solicita al usuario que ingrese los datos del producto y lo agrega al archivo
sólo si el código ingresado no existe. Suponga que existe una función llamada existe Producto que recibe un código de producto
y un archivo y devuelve verdadero si el código existe en el archivo o falso en caso contrario. La función existeProducto no 
debe implementarla. Si el producto ya existe debe informarlo en pantalla. Quitar producto: recibe el archivo sin abrir y 
solicita al usuario que ingrese un código y lo elimina del archivo solo si este código existe. Puede utilizar la función 
existeProducto. En caso de que el producto no exista debe informarse en pantalla.
Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo cambio que se produzca en el archivo.}

program parcial_6_6_2023;
type
    producto = record
        codigo:integer;
        nombre:string[40];
        desc:string;
        compra:real;
        venta:real;
        ubicacion:string[40];
    end;
    maestro = file of producto;

    procedure agregarProducto(var m:maestro);
    var
        p:producto;
    begin
        ingreseProducto(p);
        if (not existeProducto(m,p.codigo)) then begin
            reset(m);
            read(m,aux); // leo la cabecera
            if (aux.codigo < 0) then begin  // si es menor a 0 recupero espacio
                seek(m,aux.codigo*(-1));  // me posiciono en la pos borrada
                read(m,aux);    // leo el registro para actualizar cabecera
                seek(m,filepos(m)-1);   // me reposicion
                write(m,p);    // recupero el espacio escribiendo el nuevo reg
                seek(m,0);  // me reposiciono al principio
                write(m,aux);   // actualizo cabecera
            end
            else begin
                seek(m,filesize(m));  // sino agrego al final
                write(m,p);
            end;
            close(m);
        end    
        else writeln('El producto ya existe.');
    end;

    procedure quitarProducto(var m:maestro);
    var
        code:integer;
        p:producto;
    begin
        ingreseCodigo(code);
        if (existeProducto(m, p.codigo)) then begin
            reset(m);
            read(m,p); // leo la cabecera
            oldHead:= p.codigo; // me guardo la cabecera vieja
            while (not eof(m)) and (p.codigo <> code) do  // busco el codigo a borrar
                read(m,p);
            if (p.codigo = code) then begin  // si lo encuentro:
                p.codigo:= oldHead; //guardo el valor de la cabecera
                seek(m,filepos(m)-1);  // me reposiciono en la pops a boorar
                newHead:= (-1*filepos(m)) // me guardo la nueva cabecera
                write(m,p); // escribo vieja cabecera
                seek(arch,0);
                p.codigo:= newHead;
                write(m,p);
                writeln('El producto fue borrado.');
            end;
            close(m);
        end
        else writeln('El producto ya existe.');
    end;