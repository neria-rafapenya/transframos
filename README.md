# transframos
Asistente presupuestos Transframos

## Usar con Telegram

Pasos para atender el chatbot en Telegram con @Transframos_bot:

Abrir Telegram con su cuenta (cualquier dispositivo).

Buscar el bot: @Transframos_bot

Iniciar chat pulsando Start.

Enviar cualquier mensaje (por ejemplo: “Listo para atender”).

Configurar chats autorizados (backend):

- Para **un solo chat**, usar `TELEGRAM_CHAT_ID`.
- Para **varios usuarios o un grupo**, usar `TELEGRAM_CHAT_IDS` con IDs separados por coma.
  Ejemplo: `TELEGRAM_CHAT_IDS=123456789,-1002233445566`

Esperar una solicitud:
Cuando un usuario pulse “Hablar con un humano”, el bot enviará el mensaje al chat autorizado.

Responder normalmente en Telegram.
El mensaje que escriba se mostrará al usuario en el chat web.
