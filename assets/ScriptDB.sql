CREATE TABLE Usuarios (
  cedula INT PRIMARY KEY,
  id_rol INT,
  nombreUsuario VARCHAR(30) NOT NULL,
  correoElectronico VARCHAR(50) NOT NULL UNIQUE,
  codPais INT NOT NULL DEFAULT 57,
  numeroCelular INT NOT NULL,
  photo BLOB NOT NULL
);

CREATE TABLE Auth (
  id_auth INT PRIMARY KEY AUTO_INCREMENT,
  cedula INT,
  userPassword VARCHAR(100) NOT NULL
);

CREATE TABLE Roles (
  id_rol INT PRIMARY KEY AUTO_INCREMENT,
  nombreRol VARCHAR(30) NOT NULL
);

CREATE TABLE Noticias (
  id_noticia INT PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(30) NOT NULL,
  descripcion VARCHAR(600) NOT NULL,
  fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  cc_administrador INT NOT NULL
);

CREATE TABLE Imagenes (
  id_imagen INT PRIMARY KEY AUTO_INCREMENT,
  detalle VARCHAR(300),
  imagen BLOB NOT NULL,
  id_noticia INT NOT NULL
);

CREATE TABLE Respuestas (
  id_respuesta INT PRIMARY KEY AUTO_INCREMENT,
  id_peticion INT NOT NULL,
  titulo VARCHAR(30) NOT NULL,
  respuesta VARCHAR(300) NOT NULL,
  cc_administrador INT NOT NULL
);

CREATE TABLE Peticiones (
  id_peticion INT PRIMARY KEY AUTO_INCREMENT,
  detalle VARCHAR(300) NOT NULL,
  id_tipo_peticion INT NOT NULL,
  cc_ciudadano INT NOT NULL
);

CREATE TABLE TiposPeticion (
  id_tipo_peticion INT PRIMARY KEY AUTO_INCREMENT,
  nombreTipoPeticion VARCHAR(30) NOT NULL,
  descripcion VARCHAR(100)
);

CREATE TABLE Buses (
  placa_bus VARCHAR(6) PRIMARY KEY,
  modelo VARCHAR(30),
  observaciones VARCHAR(100),
  cc_administrador INT NOT NULL,
  id_ruta INT NOT NULL
);

CREATE TABLE Conductores (
  cc_conductor INT PRIMARY KEY,
  nombre_conductor VARCHAR(30),
  apellido_conductor VARCHAR(30),
  placa_bus VARCHAR(6) NOT NULL UNIQUE,
  cc_administrador INT NOT NULL
);

CREATE TABLE CalificarConductores (
  id_calificacion_conductor INT PRIMARY KEY AUTO_INCREMENT,
  valor_calificacion INT NOT NULL,
  fecha_calificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  cc_conductor INT NOT NULL,
  cc_ciudadano INT NOT NULL
);

CREATE TABLE CalificacionesServicio (
  id_calificacion_servicio INT PRIMARY KEY AUTO_INCREMENT,
  valor_calificacion INT NOT NULL,
  fecha_calificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  cc_ciudadano INT NOT NULL
);

CREATE TABLE Paraderos (
  id_paradero INT PRIMARY KEY AUTO_INCREMENT,
  nombre_paradero VARCHAR(30),
  latitud FLOAT,
  longitud FLOAT,
  cc_administrador INT NOT NULL
);

CREATE TABLE Rutas (
  id_ruta INT PRIMARY KEY AUTO_INCREMENT,
  nombre_ruta VARCHAR(60),
  precio INT,
  horario_apertura TIME NOT NULL,
  horario_cierre TIME NOT NULL,
  cc_administrador INT NOT NULL
);

CREATE TABLE ParadasRutas (
  id_parada_ruta INT PRIMARY KEY AUTO_INCREMENT,
  id_tipo_parada_ruta INT NOT NULL,
  id_paradero INT NOT NULL,
  id_ruta INT NOT NULL,
  cc_administrador INT NOT NULL
);

CREATE TABLE TiposParadasRutas (
  id_tipo_parada_ruta INT PRIMARY KEY AUTO_INCREMENT,
  descripcion VARCHAR(30)
);

CREATE TABLE Viajes (
  id_viaje INT PRIMARY KEY AUTO_INCREMENT,
  origen INT NOT NULL,
  destino INT NOT NULL,
  cc_ciudadano INT NOT NULL,
  fecha_planificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Usuarios ADD FOREIGN KEY (id_rol) REFERENCES Roles (id_rol);
ALTER TABLE Auth ADD FOREIGN KEY (cedula) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Noticias ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Imagenes ADD FOREIGN KEY (id_noticia) REFERENCES Noticias (id_noticia) ON DELETE CASCADE;
ALTER TABLE Respuestas ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
CREATE INDEX idx_id_peticion_respuestas ON Respuestas (id_peticion);
-- ALTER TABLE Peticiones DROP FOREIGN KEY Peticiones_ibfk_1;
ALTER TABLE Peticiones ADD FOREIGN KEY (id_peticion) REFERENCES Respuestas (id_peticion) ON DELETE CASCADE;
ALTER TABLE Peticiones ADD FOREIGN KEY (id_tipo_peticion) REFERENCES TiposPeticion (id_tipo_peticion);
ALTER TABLE Peticiones ADD FOREIGN KEY (cc_ciudadano) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Buses ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Buses ADD FOREIGN KEY (id_ruta) REFERENCES Rutas (id_ruta);
ALTER TABLE Conductores ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Conductores ADD FOREIGN KEY (placa_bus) REFERENCES Buses (placa_bus);
ALTER TABLE CalificarConductores ADD FOREIGN KEY (cc_conductor) REFERENCES Conductores (cc_conductor) ON DELETE CASCADE;
ALTER TABLE CalificarConductores ADD FOREIGN KEY (cc_ciudadano) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE CalificacionesServicio ADD FOREIGN KEY (cc_ciudadano) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Paraderos ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula);
ALTER TABLE Rutas ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula);
ALTER TABLE ParadasRutas ADD FOREIGN KEY (id_tipo_parada_ruta) REFERENCES TiposParadasRutas (id_tipo_parada_ruta);
ALTER TABLE ParadasRutas ADD FOREIGN KEY (id_paradero) REFERENCES Paraderos (id_paradero) ON DELETE CASCADE;
ALTER TABLE ParadasRutas ADD FOREIGN KEY (id_ruta) REFERENCES Rutas (id_ruta) ON DELETE CASCADE;
ALTER TABLE ParadasRutas ADD FOREIGN KEY (cc_administrador) REFERENCES Usuarios (cedula) ON DELETE CASCADE;
ALTER TABLE Viajes ADD FOREIGN KEY (origen) REFERENCES ParadasRutas (id_parada_ruta) ON DELETE CASCADE;
ALTER TABLE Viajes ADD FOREIGN KEY (destino) REFERENCES ParadasRutas (id_parada_ruta) ON DELETE CASCADE;
ALTER TABLE Viajes ADD FOREIGN KEY (cc_ciudadano) REFERENCES Usuarios (cedula) ON DELETE CASCADE;

-- Cambios de las tablas
ALTER TABLE Usuarios MODIFY numeroCelular VARCHAR(15);
ALTER TABLE Usuarios MODIFY photo BLOB NULL;
ALTER TABLE Auth ADD pin INT DEFAULT null;
ALTER TABLE Auth ADD pinIntents INT DEFAULT 0;
ALTER TABLE Rutas MODIFY horario_apertura TIME NOT NULL;
ALTER TABLE Rutas MODIFY horario_cierre TIME NOT NULL;
ALTER TABLE Rutas MODIFY nombre_ruta VARCHAR(60) NOT NULL;
ALTER TABLE Conductores MODIFY placa_bus VARCHAR(6) NOT NULL UNIQUE;
ALTER TABLE Respuestas  MODIFY titulo VARCHAR(90) NOT NULL;
ALTER TABLE Noticias  MODIFY titulo VARCHAR(90) NOT NULL;

-- Información por deafult
INSERT INTO Roles (id_rol, nombreRol) VALUES(null, "Ciudadano");
INSERT INTO Roles (id_rol, nombreRol) VALUES(null, "Administrador");

INSERT INTO TiposPeticion (id_tipo_peticion, nombreTipoPeticion, descripcion) VALUES(null, "Reclamo", "El ciudadano tiene un inconformidad clara con el servicio");
INSERT INTO TiposPeticion (id_tipo_peticion, nombreTipoPeticion, descripcion) VALUES(null, "Solicitud", "El ciudadano tiene una necesidad con respecto a el servicio");
INSERT INTO TiposPeticion (id_tipo_peticion, nombreTipoPeticion, descripcion) VALUES(null, "Sugerencia", "El ciudadano considera un cambio para el servicio");

INSERT INTO TiposParadasRutas  (id_tipo_parada_ruta, descripcion) VALUES(null, "Origen");
INSERT INTO TiposParadasRutas  (id_tipo_parada_ruta, descripcion) VALUES(null, "Destino");
INSERT INTO TiposParadasRutas  (id_tipo_parada_ruta, descripcion) VALUES(null, "Parada");


-- Otros:
-- ALTER TABLE Usuarios ADD CONSTRAINT unique_correo UNIQUE (correoElectronico);
ALTER TABLE Peticiones DROP FOREIGN KEY Peticiones_ibfk_1;

ALTER TABLE Paraderos
ADD CONSTRAINT nombre_paradero_unico UNIQUE (nombre_paradero);
ALTER TABLE Rutas
ADD CONSTRAINT nombre_ruta_unico UNIQUE (nombre_ruta);