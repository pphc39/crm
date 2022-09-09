package com.xauat.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SettingsIndexController {

    @RequestMapping ("/settings/index")
    public String index(){
        return "settings/index";
    }
}
