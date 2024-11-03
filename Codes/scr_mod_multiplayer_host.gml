function scr_mod_multiplayer_host()
{
    var _port = is_undefined(argument[0]) ? 2418 : argument[0]

    if (!instance_exists(o_webchannel))
        instance_create_layer(0, 0, "Instances", o_webchannel)

    with (o_webchannel)
    {
        host_port = _port

        if (is_client)
        {
            network_destroy(socket_id)
            is_client = false
        }

        network_set_config(network_config_use_non_blocking_socket, true)
        if (socket_id < 0)
            socket_id = network_create_server(network_socket_tcp, host_port, 32);

        if (socket_id < 0)
        {
            is_server = false
            scr_actionsLogUpdate("[Multiplayer]--->Failed_to_create_server")
            return;
        }
        else
        {
            is_server = true
            scr_actionsLogUpdate("[Multiplayer]--->Created_server_at:" + string(host_port))
        }
    }
}