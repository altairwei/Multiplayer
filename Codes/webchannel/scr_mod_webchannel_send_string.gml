function scr_mod_webchannel_send_string()
{
    var _socket = argument[0]
    var _text = argument[1]

    var send_buffer = buffer_create(256, buffer_grow, 1)
    buffer_seek(send_buffer, buffer_seek_start, 0)
    buffer_write(send_buffer, buffer_string, _text)
    network_send_packet(_socket, send_buffer, buffer_tell(send_buffer))
    buffer_delete(send_buffer)
}