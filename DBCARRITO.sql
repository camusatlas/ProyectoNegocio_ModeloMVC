create database DBCARRITO
--
use DBCARRITO
--
create table CATEGORIA
(
IdCategoria int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
);
--
create table MARCA
(
IdMarca int primary key identity,
Descripcion varchar(100),
Activo bit default 1,
FechaRegistro datetime default getdate()
);
--
create table PRODUCTO
(
IdProducto int primary key identity,
Nombre varchar(500),
Descripcion varchar(1000),
IdMarca int references MARCA(IdMarca),
IdCategoria int references CATEGORIA(IdCategoria),
Precio decimal(10,2) default 0,
stock int,
RutaImagen varchar(100),
NombreImagen varchar(100),
Activo bit default  1,
FechaRegistro datetime default getdate()
);
--
create table CLIENTE
(
IdCliente int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Restablecer bit default 0,
FechaRegistro datetime default getdate()
);
/*Crear Carrito*/
create table CARRITO
(
IdCarrito int primary key identity,
IdCliente int references CLIENTE(IdCliente),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int
);
/*Crear la tabla Venta*/
ALTER TABLE VENTA
ADD IdTransaccion VARCHAR(50);

create table VENTA
(
IdVenta int primary key identity,
IdCliente int references CLIENTE(IdCliente),
TotalProducto int,
MontoTotal decimal(10,2),
Contacto varchar(50),
IdDistrito varchar(10),
Telefono varchar(50),
Direccion varchar(500),
IdTransaccion varchar(50),
FechaVenta datetime default getdate()
);
/*Crear la tabla Detalle de Venta*/
create table DETALLE_VENTA
(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int,
Total decimal(10,2)
);
/*Crear la tabla de Usuario*/
Create table USUARIO
(
IdUsuario int primary key identity,
Nombres varchar(100),
Apellidos varchar(100),
Correo varchar(100),
Clave varchar(150),
Restablecer bit default 1,
Activo bit default 1,
FechaRegistro datetime default getdate()
);
/*Crear la tabla DEPARTAMENTO*/
create table DEPARTAMENTO
(
IdDepartamento varchar(2) NOT NULL,
Descripcion varchar(45) NOT NULL
);
/*Crear la tabla Provincia*/
create table PROVINCIA
(
IdProvincia varchar(4) NOT NULL,
Descripcion varchar(45) NOT NULL,
IdDepartamento varchar(2)
);
/*Tabla Distrito*/
Create table DISTRITO
(
IdDistrito varchar(6) NOT NULL,
Descripcion varchar(45) NOT NULL,
IdProvincia varchar(4) NOT NULL,
IdDepartamento varchar(2) NOT NULL
);
---
/*insetado de datos*/
insert into USUARIO(Nombres,Apellidos,Correo,Clave) values ('test nombre','test apellido','test@example.com','ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')

 go

 insert into CATEGORIA(Descripcion) values 
 ('Tecnologia'),
 ('Muebles'),
 ('Dormitorio'),
  ('Deportes')


go

  insert into MARCA(Descripcion) values
('SONYTE'),
('HPTE'),
('LGTE'),
('HYUNDAITE'),
('CANONTE'),
('ROBERTA ALLENTE')


go


insert into DEPARTAMENTO(IdDepartamento,Descripcion)
values 
('01','Arequipa'),
('02','Ica'),
('03','Lima')


go

insert into PROVINCIA(IdProvincia,Descripcion,IdDepartamento)
values
('0101','Arequipa','01'),
('0102','Camaná','01'),

--ICA - PROVINCIAS
('0201', 'Ica ', '02'),
('0202', 'Chincha ', '02'),

--LIMA - PROVINCIAS
('0301', 'Lima ', '03'),
('0302', 'Barranca ', '03')


go

insert into DISTRITO(IdDistrito,Descripcion,IdProvincia,IdDepartamento) values 
('010101','Nieva','0101','01'),
('010102', 'El Cenepa', '0101', '01'),

('010201', 'Camaná', '0102', '01'),
('010202', 'José María Quimper', '0102', '01'),

--ICA - DISTRITO
('020101', 'Ica', '0201', '02'),
('020102', 'La Tinguiña', '0201', '02'),
('020201', 'Chincha Alta', '0202', '02'),
('020202', 'Alto Laran', '0202', '02'),


--LIMA - DISTRITO
('030101', 'Lima', '0301', '03'),
('030102', 'Ancón', '0301', '03'),
('030201', 'Barranca', '0302', '03'),
('030202', 'Paramonga', '0302', '03')
---
create procedure LisatUsuario
as
begin
	select*from USUARIO
end;
---
select*from CATEGORIA
--
create procedure ListarCategoria
as
begin
	select*from CATEGORIA
END;
--
create proc sp_RegistrarUsuario
(
@Nombre varchar(100),
@Apellido varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mesnaje varchar(500) out,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if NOT EXISTS (select*from USUARIO where Correo = @Correo)
	begin
		insert into USUARIO(Nombres, Apellidos, Correo, Clave, Activo) values
		(@Nombre, @Apellido, @Correo, @Clave, @Activo)

		SET @Resultado = SCOPE_IDENTITY()
	end
	else
	set @Mesnaje = 'El correo del usuario ya exite'
end
--Editar Usuario
create proc sp_EditarUsuario
(
@IdUsuario int,
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Activo bit,
@Mesnaje varchar(500) out,
@Resultado int output
)
as
begin
	set @Resultado = 0
	if NOT EXISTS (select*from USUARIO where Correo = @Correo and IdUsuario != @IdUsuario)
	begin
		Update top (1) USUARIO set
		Nombres = @Nombres,
		Apellidos = @Apellidos,
		Correo = @Correo,
		Activo = @Activo
		where IdUsuario = @IdUsuario
		set @Resultado = 1
	end
	else
	 set @Mesnaje = 'El correo del usuario ya existe'
end;
SELECT*FROM USUARIO
--
create proc sp_RegistrarCategoria
(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0

	if NOT EXISTS (select*from CATEGORIA Where Descripcion = @Descripcion)
	begin
		insert into CATEGORIA(Descripcion, Activo) values
		(@Descripcion,@Activo)

		SET @Resultado = SCOPE_IDENTITY()
	end
	else
	 set @Mensaje = 'La categoria ya existe'
end
--
create proc sp_EditarCategoria
(
@IdCategoria int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	if not exists (select*from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
	begin
		update top (1) CATEGORIA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdCategoria = @IdCategoria
		SET @Resultado = 1
	END
	else
		set @Mensaje = 'La categoria ya existe'
end
--
create proc sp_EliminarCategoria
(
@IdCategoria int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	IF not exists (select * from PRODUCTO p
	inner join CATEGORIA c on c.IdCategoria = p.IdCategoria
	where p.IdCategoria = @IdCategoria)
	begin
		delete top (1) from CATEGORIA WHERE IdCategoria = @IdCategoria
		set @Resultado = 1
		end
		else 
			set @Mensaje = 'La categoria se encuentra relacionada a un producto'
end
/*Registrar MArca*/
create proc sp_RegistrarMarca
(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
	set @Resultado = 0

	if NOT EXISTS (select*from MARCA Where Descripcion = @Descripcion)
	begin
		insert into MARCA(Descripcion, Activo) values
		(@Descripcion,@Activo)

		SET @Resultado = SCOPE_IDENTITY()
	end
	else
	 set @Mensaje = 'La categoria ya existe'
end
--
create proc sp_EditarMarca
(
@IdMarca int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	if not exists (select*from MARCA where Descripcion = @Descripcion and IdMarca != @IdMarca)
	begin
		update top (1) MARCA set
		Descripcion = @Descripcion,
		Activo = @Activo
		where IdMarca = @IdMarca
		SET @Resultado = 1
	END
	else
		set @Mensaje = 'La categoria ya existe'
end
--
create proc sp_EliminarMarca
(
@IdMarca int,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	set @Resultado = 0
	IF not exists (select * from PRODUCTO p
	inner join MARCA c on c.IdMarca = p.IdMarca
	where p.IdMarca = @IdMarca)
	begin
		delete top (1) from MARCA WHERE IdMarca = @IdMarca
		set @Resultado = 1
		end
		else 
			set @Mensaje = 'La marca se encuentra relacionada a un producto'
end
--
CREATE PROCEDURE ListarMarca
AS
BEGIN
    SELECT * FROM MARCA
END
/*Producto*/
select*from PRODUCTO
CREATE PROCEDURE ListarProducto
AS
BEGIN
    SELECT 
        p.IdProducto,
        p.Nombre,
        p.Descripcion,
        m.IdMarca,
        m.Descripcion AS DesMarca,
        c.IdCategoria,
        c.Descripcion AS DesCategoria,
        p.Precio,
        p.Stock,
        p.RutaImagen,
        p.NombreImagen,
        p.Activo
    FROM PRODUCTO p
    INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
    INNER JOIN CATEGORIA c ON c.IdCategoria = p.IdCategoria
END

CREATE PROCEDURE sp_RegistrarProducto
(
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(100),
    @IdMarca VARCHAR(100),
    @IdCategoria VARCHAR(100),
    @Precio DECIMAL(10, 2),
    @Stock INT,
    @Activo BIT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0

    IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre)
    BEGIN
        INSERT INTO PRODUCTO (Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, Activo)
        VALUES (@Nombre, @Descripcion, @IdMarca, @IdCategoria, @Precio, @Stock, @Activo)

        SET @Resultado = SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El producto ya existe'
    END
END
--
CREATE PROCEDURE sp_EditarProducto
(
    @IdProducto INT,
    @Nombre VARCHAR(100),
    @Descripcion VARCHAR(100),
    @IdMarca VARCHAR(100),
    @IdCategoria VARCHAR(100),
    @Precio DECIMAL(10, 2),
    @Stock INT,
    @Activo BIT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0

    IF NOT EXISTS (SELECT * FROM PRODUCTO WHERE Nombre = @Nombre AND IdProducto != @IdProducto)
    BEGIN
        UPDATE PRODUCTO
        SET 
            Nombre = @Nombre,
            Descripcion = @Descripcion,
            IdMarca = @IdMarca,
            IdCategoria = @IdCategoria,
            Precio = @Precio,
            Stock = @Stock,
            Activo = @Activo
        WHERE IdProducto = @IdProducto

        SET @Resultado = 1
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El producto ya existe'
    END
END
--
CREATE PROCEDURE sp_EliminarProducto
(
    @IdProducto INT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0

    IF NOT EXISTS (
        SELECT * FROM DETALLE_VENTA dv
        INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto
        WHERE p.IdProducto = @IdProducto
    )
    BEGIN
        DELETE TOP (1) FROM PRODUCTO WHERE IdProducto = @IdProducto
        SET @Resultado = 1
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El producto se encuentra relacionado a una venta'
    END
END
--
CREATE PROCEDURE sp_GuardarDatosImagen
(
    @IdProducto INT,
    @RutaImagen varchar(100),
    @NombreImagen varchar(100)
)
AS
BEGIN
    UPDATE PRODUCTO
    SET 
        RutaImagen = @RutaImagen,
        NombreImagen = @NombreImagen
    WHERE 
        IdProducto = @IdProducto;
END
/*Dasboard*/
CREATE PROCEDURE sp_ReporteVentas
(
    @fechainicio VARCHAR(10),
    @fechafin VARCHAR(10),
    @idtransaccion VARCHAR(50)
)
AS
BEGIN
    SET DATEFORMAT dmy;

    SELECT 
        CONVERT(CHAR(10), v.FechaVenta, 103) [FechaVenta],
        CONCAT(c.Nombres, ' ', c.Apellidos) [Cliente],
        p.Nombre [Producto],
        p.Precio,
        dv.Cantidad,
        dv.Total,
        v.IdTransaccion
    FROM DETALLE_VENTA dv
    INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto
    INNER JOIN VENTA v ON v.IdVenta = dv.IdVenta
    INNER JOIN CLIENTE c ON c.IdCliente = v.IdCliente
    WHERE CONVERT(DATE, v.FechaVenta) BETWEEN @fechainicio AND @fechafin
    AND v.IdTransaccion = IIF(@idtransaccion = '', v.IdTransaccion, @idtransaccion)
END

--
/*Registrar Cliente*/
CREATE PROCEDURE sp_RegistrarCliente
(
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @Correo VARCHAR(100),
    @Clave VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0

    IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
    BEGIN
        INSERT INTO CLIENTE (Nombres, Apellidos, Correo, Clave, Restablecer)
        VALUES (@Nombres, @Apellidos, @Correo, @Clave, 0)

        SET @Resultado = SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El correo del usuario ya existe'
    END
END
--
CREATE PROCEDURE ListarMarcaPorCategoria
(
    @IdCategoria INT
)
AS
BEGIN
    SELECT DISTINCT 
        m.IdMarca,
        m.Descripcion 
    FROM PRODUCTO p
    INNER JOIN CATEGORIA c ON c.IdCategoria = p.IdCategoria
    INNER JOIN MARCA m ON m.IdMarca = p.IdMarca AND m.Activo = 1
    WHERE c.IdCategoria = IIF(@IdCategoria = 0, c.IdCategoria, @IdCategoria);
END
--
select*from CLIENTE
CREATE PROCEDURE ListarCliente
AS
BEGIN
    select*from CLIENTE
END
--
CREATE PROCEDURE sp_RegistrarCliente
(
    @Nombres VARCHAR(100),
    @Apellidos VARCHAR(100),
    @Correo VARCHAR(100),
    @Clave VARCHAR(100),
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado INT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0

    IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
    BEGIN
        INSERT INTO CLIENTE (Nombres, Apellidos, Correo, Clave, Restablecer)
        VALUES (@Nombres, @Apellidos, @Correo, @Clave, 0)

        SET @Resultado = SCOPE_IDENTITY()
    END
    ELSE
    BEGIN
        SET @Mensaje = 'El correo del usuario ya existe'
    END
END
--
CREATE PROCEDURE sp_ExisteCarrito
(
    @IdCliente INT,
    @IdProducto INT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    IF EXISTS (SELECT * FROM carrito WHERE idcliente = @IdCliente AND idproducto = @IdProducto)
    BEGIN
        SET @Resultado = 1
    END
    ELSE
    BEGIN
        SET @Resultado = 0
    END
END
--
/*Operacion Carrito*/
CREATE PROCEDURE sp_OperacionCarrito
(
    @IdCliente INT,
    @IdProducto INT,
    @Sumar BIT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 1
    SET @Mensaje = ''

    DECLARE @existecarrito BIT = IIF(EXISTS(SELECT * FROM carrito WHERE idcliente = @IdCliente AND idproducto = @IdProducto), 1, 0)
    DECLARE @stockproducto INT = (SELECT stock FROM PRODUCTO WHERE IdProducto = @IdProducto)

    BEGIN TRY
        BEGIN TRANSACTION OPERACION

        IF (@Sumar = 1)
        BEGIN
            IF (@stockproducto > 0)
            BEGIN
                IF (@existecarrito = 1)
                BEGIN
                    UPDATE CARRITO 
                    SET Cantidad = Cantidad + 1 
                    WHERE idcliente = @IdCliente AND idproducto = @IdProducto
                END
                ELSE
                BEGIN
                    INSERT INTO CARRITO(IdCliente, IdProducto, Cantidad) 
                    VALUES (@IdCliente, @IdProducto, 1)
                END

                UPDATE PRODUCTO 
                SET Stock = Stock - 1 
                WHERE IdProducto = @IdProducto
            END
            ELSE
            BEGIN
                SET @Resultado = 0
                SET @Mensaje = 'El producto no cuenta con stock disponible'
            END
        END
        ELSE
        BEGIN
            UPDATE CARRITO 
            SET Cantidad = Cantidad - 1 
            WHERE idcliente = @IdCliente AND idproducto = @IdProducto

            UPDATE PRODUCTO 
            SET Stock = Stock + 1 
            WHERE IdProducto = @IdProducto
        END

        COMMIT TRANSACTION OPERACION
    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        SET @Mensaje = ERROR_MESSAGE()
        ROLLBACK TRANSACTION OPERACION
    END CATCH
END
--
select COUNT(*) from CARRITO where IdCliente = 2
--
CREATE FUNCTION fn_obtenerCarritoCliente
(
    @idcliente INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.IdProducto,
        m.Descripcion [DesMarca],
        p.Nombre,
        p.Precio,
        c.Cantidad,
        p.RutaImagen,
        p.NombreImagen
    FROM CARRITO c
    INNER JOIN PRODUCTO p ON p.IdProducto = c.IdProducto
    INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
    WHERE c.IdCliente = @idcliente
)
--
select*from fn_obtenerCarritoCliente(2)
--
CREATE PROCEDURE ListarDepartamento
AS
BEGIN
    select*from DEPARTAMENTO
END
--
CREATE PROCEDURE sp_OptenerProvincia
(
    @IdDepartamento INT
)
AS
BEGIN
    SELECT *
    FROM PROVINCIA
    WHERE IdDepartamento = @IdDepartamento;
END
select*from DISTRITO
--Disctrito
CREATE PROCEDURE sp_ObtenerDistrito
(
    @IdProvincia INT,
    @IdDepartamento INT
)
AS
BEGIN
    SELECT *
    FROM DISTRITO
    WHERE IdProvincia = @IdProvincia
    AND IdDepartamento = @IdDepartamento;
END
--
CREATE TYPE [dbo].[EDetalle_Venta] AS TABLE
(
    [IdProducto] INT NULL,
    [Cantidad] INT NULL,
    [Total] DECIMAL(18,2) NULL
)
--
CREATE PROCEDURE usp_RegistrarVenta
(
    @IdCliente INT,
    @TotalProducto INT,
    @MontoTotal DECIMAL(18,2),
    @Contacto VARCHAR(100),
    @IdDistrito VARCHAR(6),
    @Telefono VARCHAR(10),
    @Direccion VARCHAR(100),
    @IdTransaccion VARCHAR(50),
    @DetalleVenta [EDetalle_Venta] READONLY,
    @Resultado BIT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
)
AS
BEGIN
    BEGIN TRY
        DECLARE @idventa INT = 0
        SET @Resultado = 1
        SET @Mensaje = ''

        BEGIN TRANSACTION registro

        INSERT INTO VENTA(IdCliente, TotalProducto, MontoTotal, Contacto, IdDistrito, Telefono, Direccion, IdTransaccion)
        VALUES(@IdCliente, @TotalProducto, @MontoTotal, @Contacto, @IdDistrito, @Telefono, @Direccion, @IdTransaccion)

        SET @idventa = SCOPE_IDENTITY()

        INSERT INTO DETALLE_VENTA(IdVenta, IdProducto, Cantidad, Total)
        SELECT @idventa, IdProducto, Cantidad, Total FROM @DetalleVenta

        DELETE FROM CARRITO WHERE IdCliente = @IdCliente

        COMMIT TRANSACTION registro
    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        SET @Mensaje = ERROR_MESSAGE()
        ROLLBACK TRANSACTION registro
    END CATCH
END
