function scr_mod_multiplayer_join()
{
    var _ip = is_undefined(argument[0]) ? "127.0.0.1" : argument[0]
    var _port = is_undefined(argument[1]) ? 2418 : argument[1]

    if (!instance_exists(o_webchannel))
        instance_create_layer(0, 0, "Instances", o_webchannel)

    with (o_webchannel)
    {
        host_ip = _ip
        host_port = _port

        if (is_server)
        {
            network_destroy(socket_id)
            is_server = false
        }

        network_set_config(network_config_use_non_blocking_socket, false)
        if (socket_id < 0)
        {
            socket_id = network_create_socket(network_socket_tcp)
        }

        if (socket_id < 0 || network_connect(socket_id, host_ip, host_port) < 0)
        {
            is_client = false
            scr_actionsLogUpdate("[Multiplayer]--->Failed_to_connect_server")
            return;
        }
        else
        {
            is_client = true
            scr_actionsLogUpdate("[Multiplayer]--->Connected_server_at:" + string(host_ip) + ":" + string(host_port))
        }
    }
}