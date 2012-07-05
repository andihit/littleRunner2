@echo off

cmd /c rebar clean compile generate
cmd /c rel\lr2_server\bin\lr2_server console