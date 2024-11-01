function scr_mod_webchannel_invoke()
{
    var _script = argument[0]
    var _arguments = argument[1]
    var _callback = argument[2]
    var _with = argument[3]
    var _socket = is_undefined(argument[4]) ? socket_id : argument[4]

    var _data = ds_map_create()
    ds_map_add(_data, "MessageType", "InvokeScript")
    ds_map_add(_data, "Script", _script)
    ds_map_add(_data, "Arguments", _arguments)
    ds_map_add(_data, "With", _with)

    if !is_undefined(_callback)
    {
        if (exec_id == MAX_INT)
            exec_id = MIN_INT

        ds_map_add(_data, "ExecId", exec_id)
        ds_map_add(exec_callbacks, exec_id, _callback)

        exec_id++
    }

    var _json_string = json_encode(_data)
    scr_mod_webchannel_send(_json_string, _socket)

    ds_map_destroy(_map)
}
