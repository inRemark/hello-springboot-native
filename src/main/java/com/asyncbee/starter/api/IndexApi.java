package com.asyncbee.starter.api;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api")
public class IndexApi {

    @RequestMapping(value = {"", "/", "index"})
    public String index() {
        return "Hello Spring Boot Native Starter!";
    }

    @RequestMapping("hello")
    public String hello() {
        return "Hello Api!";
    }
}
