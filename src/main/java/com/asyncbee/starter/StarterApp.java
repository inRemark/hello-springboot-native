package com.asyncbee.starter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Date;

@SpringBootApplication
public class StarterApp {

    public static void main(String[] args) {
        SpringApplication.run(StarterApp.class, args);
        System.out.println("Started at: " + new Date());
    }

}
