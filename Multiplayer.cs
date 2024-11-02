// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace Multiplayer;
public class Multiplayer : Mod
{
    public override string Author => "Altair & Pong";
    public override string Name => "Multiplayer";
    public override string Description => "Allows multiple players to fight in the same arena.";
    public override string Version => "1.0.0";
    public override string TargetVersion => "0.8.2.10";

    public override void PatchMod()
    {
        Msl.AddFunction(ModFiles.GetCode("webchannel/scr_mod_webchannel_send.gml"), "scr_mod_webchannel_send");
        Msl.AddFunction(ModFiles.GetCode("webchannel/scr_mod_webchannel_on_message.gml"), "scr_mod_webchannel_on_message");
        Msl.AddFunction(ModFiles.GetCode("webchannel/scr_mod_webchannel_chat.gml"), "scr_mod_webchannel_chat");
        Msl.AddFunction(ModFiles.GetCode("webchannel/scr_mod_webchannel_invoke.gml"), "scr_mod_webchannel_invoke");

        UndertaleGameObject o_webchannel = Msl.AddObject(
            name: "o_webchannel",
            isVisible: false,
            isPersistent: true,
            isAwake: true
        );

        o_webchannel.ApplyEvent(ModFiles,
            new MslEvent("webchannel/o_webchannel_Create_0.gml", EventType.Create, 0),
            new MslEvent("webchannel/o_webchannel_Destroy_0.gml", EventType.Destroy, 0),
            // Async Event: Networking
            new MslEvent("webchannel/o_webchannel_Other_68.gml", EventType.Other, 68)
        );

        Msl.AddFunction(ModFiles.GetCode("webchannel/scr_mod_webchannel_host.gml"), "scr_mod_webchannel_host");
        Msl.AddFunction(ModFiles.GetCode("webchannel/scr_mod_webchannel_join.gml"), "scr_mod_webchannel_join");

        Msl.LoadGML("gml_Object_o_player_KeyPress_117") // F6
            .MatchAll()
            .InsertBelow(@"
                scr_mod_webchannel_host(8181)
                var _FuneralCave = scr_glmap_getLocation(""FuneralCave"")
                global.playerGridX = _FuneralCave.x
                global.playerGridY = _FuneralCave.y
                scr_smoothRoomChange(r_ManticoreCave, [4])
            ")
            .Save();

        Msl.LoadGML("gml_Object_o_player_KeyPress_119") // F8
            .MatchAll()
            .InsertBelow(@"
                scr_mod_webchannel_join(""127.0.0.1"", 8181)
                var _FuneralCave = scr_glmap_getLocation(""FuneralCave"")
                global.playerGridX = _FuneralCave.x
                global.playerGridY = _FuneralCave.y
                scr_smoothRoomChange(r_ManticoreCave, [4])
            ")
            .Save();

        // Key "Y"
        Msl.AddNewEvent(
            objectName: "o_player",
            eventType: EventType.KeyPress, subtype: 89,
            eventCode: @"
                with (o_webchannel)
                {
                    var _text =  get_string(""Send?"", ""Hello World"")
                    if (is_client)
                    {
                        scr_mod_webchannel_chat(_text)
                        scr_mod_webchannel_invoke(gml_Script_scr_npc_check_gold, [100], function() {
                            scr_actionsLogUpdate(""[Multiplayer]-->scr_npc_check_gold-->"" + string(argument[0]))
                        })
                    }
                    else if (is_server)
                    {
                        for (var i = 0; i < ds_list_size(socket_list); i++) {
                            var _client_socket = ds_list_find_value(socket_list, i)
                            scr_mod_webchannel_chat(_text, _client_socket)
                        }
                    }
                }
            "
        );
    }
}
