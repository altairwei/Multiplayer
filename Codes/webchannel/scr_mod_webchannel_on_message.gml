function scr_mod_webchannel_on_message()
{
    var _json_string = argument[0]
    var _socket_from = argument[1]
    var _data = json_decode(_json_string)

    switch (ds_map_find_value(_data, "MessageType"))
    {
        case "TextMessage":
            scr_actionsLogUpdate("[Multiplayer]-" + ds_map_find_value(_data, "Data"))
        break;

        case "InvokeScript":
            // Invoke script
            var _script = ds_map_find_value(_data, "Script")
            var _arguments = ds_map_find_value(_data, "Arguments")
            var _with = ds_map_find_value(_data, "With")

            if is_undefined(_with)
                _with = self

            with (_with)
                var _value = script_execute_ext(_script, _arguments)

            // Send response back
            var _exec_id = ds_map_find_value(_data, "ExecId")
            if !is_undefined(_exec_id)
            {
                var _resp = ds_map_create()
                ds_map_add(_resp, "MessageType", "Response")
                ds_map_add(_resp, "ExecId", _exec_id)
                ds_map_add(_resp, "Value", _value)
                scr_mod_webchannel_send(json_encode(_resp), _socket_from)
                ds_map_destroy(_resp)
            }
        break;

        case "Response":
            var _exec_id = ds_map_find_value(_data, "ExecId")
            var _value = ds_map_find_value(_data, "Value")
            var _callback = ds_map_find_value(exec_callbacks, _exec_id)
            script_execute(_callback, _value)
            ds_map_delete(exec_callbacks, _exec_id)
        break;
    }

    ds_map_destroy(_data)
}