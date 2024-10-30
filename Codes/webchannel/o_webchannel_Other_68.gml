var _socket_id = ds_map_find_value(async_load, "id")
if (_socket_id == socket_id || ds_list_find_index(socket_list, _socket_id) != -1)
{
    switch ds_map_find_value(async_load, "type")
    {
        case network_type_connect:
            var _client_socket = ds_map_find_value(async_load, "socket")
            ds_list_add(socket_list, _client_socket)
            scr_actionsLogUpdate("[Multiplayer]-->Player_" + string(_client_socket) + "_joined_your_game")
        break;

        case network_type_disconnect:
            var _client_socket = ds_map_find_value(async_load, "socket")
            ds_list_delete(socket_list, _client_socket)
            scr_actionsLogUpdate("[Multiplayer]-->Player_" + string(_client_socket) + "_left_your_game")
        break;

        case network_type_data:
            var packet_buffer = ds_map_find_value(async_load, "buffer")
            if (!is_undefined(packet_buffer))
            {
                var buffer_data = buffer_read(packet_buffer, buffer_string)
                scr_actionsLogUpdate("[Multiplayer]-->" + buffer_data)
            }
        break;
    }
}
