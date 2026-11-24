<!-- Enlace a la calculadora de precios -->

AMAZON EC2
https://calculator.aws/#/estimate?id=5c16f8c5bbd1c449131c173ccb555f27d82a5ca5

Región: us-east-1.
Tenencia (Instancias compartidas), Sistema operativo (Linux), Carga de trabajo (Consistent, Cantidad de instancias: 1), Instancia EC2 por adelantado (t3.micro), Pricing strategy (On-Demand Utilization: 100 %Utilized/Month), Habilitar la monitorización (desactivado), DT Entrada: Not selected (0 TB al mes), DT Salida: Not selected (0 TB al mes), DT Intra-región: (0 TB al mes).

<!-- Enlace a la calculadora de precios actualizada-->

AMAZON EC2 (x2) + Amazon Route 53
https://calculator.aws/#/estimate?id=bbc8cf35574df36d4fead4a99f09dc29557a9b63

Configuración de los dos EC2 exactamente iguales que en la primera calculadora.
Configuración de Amazon Route 53: zona alojada privada con sus consultas DNS asociadas.

Para hacer menos costoso este servicio se podría cambiar el plan a Compute Savings Plans por ejemplo.

Uso de Inteligencia Artificial:
Gémini Hydrogen.

1. Cuando la instancia esté en ejecución, espera uno o dos minutos y abre en tu navegador http://<IP pública>. Fíjate en que es http, no https.
   Me dice esto, pero intento entrar y no me funciona xd.

Respuesta: Cuando la web no carga en AWS al principio, el 99% de las veces se debe a que el navegador fuerza https:// automáticamente o a que falta un enlace en la red/firewall. Sigue estas comprobaciones en orden para localizar y solucionar el bloqueo: 1. Comprobar que el navegador no fuerce HTTPS. 2. Verificar el Grupo de Seguridad (Puerto 80). 3. Revisar la tabla de rutas y la asociación de subred. En la consola de EC2, ve a la pestaña Redes de tu instancia, haz clic en el enlace de tu Subred (libreria-publica) y abre su pestaña Tabla de enrutamiento. Comprueba que el nombre de la tabla es libreria-rt-publica y que tiene una ruta con destino 0.0.0.0/0 apuntando a tu igw-... 4. Si la red y el firewall están bien pero sigue dando error de conexión rechazada, es posible que el script de Datos de usuario tuviera algún fallo al ejecutarse. En la consola de EC2, selecciona libreria-web y pulsa Conectar (arriba a la derecha) → pestaña EC2 Instance Connect → Conectar.

2. ¡Ahí está el fallo exacto! Mira la parte inferior de tu captura: Tu subred libreria-publica está asociada ahora mismo a la tabla de enrutamiento por defecto (rtb-0ea203aa099fc17f9), que solo tiene la ruta 10.0.0.0/16 -> local, en lugar de tu tabla libreria-rt-publica (rtb-01edf8216e3304721).

3. Pero no hace faltar hacer nada, no? solamente abrir el enlace.
   Respuesta: Sí, no hace falta tocar nada dentro del servidor, en teoría basta con abrir http://TUIP en el navegador y debería cargar sola.

PROPUESTA INCORRECTA DE LA IA:
Cuando le decía que no me cargaba la página web de la instancia e insistía todo el rato en que tenía errores seguramente en Gateway, Grupos de Seguridad e incluso me ha hecho borrar una instancia para crear otra.

Respuesta: Como tu instancia arrancó antes de que arreglaras la tabla de rutas, la máquina intentó conectarse a internet en el primer segundo para descargar nginx y no pudo porque aún no tenía salida. Por eso ahora, aunque ya hayas arreglado la red, nginx no se llegó a instalar.
La solución más rápida sin tocar comandos es:
Ve a EC2 → Instancias, selecciona libreria-web y dale a Estado de la instancia → Terminar instancia (borrarla).
Dale a Lanzar instancias de nuevo con exactamente los mismos datos (ahora que la red ya está arreglada, a la primera tendrá salida a internet y se instalará sola en 1 minuto).

¿ Por qué la subred es pública y de por qué el SSH solo se abre a tu IP ?
La subred es pública porque está asociada a una tabla de rutas que redirige todo el tráfico externo (0.0.0.0/0) hacia un Internet Gateway y tiene activada la asignación automática de direcciones IPv4 públicas, permitiendo la comunicación directa con Internet. Por otro lado, el puerto SSH (22) se restringe exclusivamente a mi IP por seguridad (principio de mínimo privilegio), evitando que cualquier usuario o bot de Internet pueda intentar conectarse y administrar el servidor de forma no autorizada.
