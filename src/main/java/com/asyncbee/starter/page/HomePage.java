package com.asyncbee.starter.page;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/")
@Controller
public class HomePage {

    @RequestMapping(value = {"", "/", "index"})
    public String index(Model model) {
        return "index";
    }
}
