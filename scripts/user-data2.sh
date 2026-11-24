#!/bin/bash
dnf install -y nginx
systemctl enable --now nginx

cat > /usr/share/nginx/html/index.html <<EOF
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <title>Librería Tinta</title>
</head>
<body>
  <h1>Librería Tinta - VERSIÓN 2</h1>
  <p>Tu librería de barrio.</p>
  <p><strong>Horario:</strong> Lunes a Viernes de 10:00 a 14:00 y de 17:00 a 20:30</p>
  <p><strong>Dirección:</strong> Calle de los Libros, 12</p>
  <p><strong>Recomendación del mes:</strong> <em>La sombra del viento</em>, de Carlos Ruiz Zafón</p>
  <hr>
  <small>Desplegado por Lucia Navarro en el servidor $(hostname) el $(date '+%d/%m/%Y %H:%M')</small>
</body>
</html>
EOF