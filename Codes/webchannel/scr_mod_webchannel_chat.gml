function scr_mod_webchannel_chat()
{
    var _text = argument[0]
    var _socket = is_undefined(argument[1]) ? socket_id : argument[1]

    var _map = ds_map_create()
    ds_map_add(_map, "MessageType", "TextMessage")
    ds_map_add(_map, "Data", _text)
    var _json_string = json_encode(_map)
    scr_mod_webchannel_send(_json_string, _socket)

    ds_map_destroy(_map)
}