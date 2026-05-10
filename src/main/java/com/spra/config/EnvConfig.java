package com.spra.config;

import io.github.cdimascio.dotenv.Dotenv;

public class EnvConfig {

    private static final Dotenv dotenv = Dotenv.configure()
            .ignoreIfMissing()
            .load();

    private EnvConfig() {}

    public static String get(String key) {
        String value = dotenv.get(key);
        if (value == null) {
            System.err.println("[EnvConfig] WARNING: environment variable '" + key + "' not found!");
        }
        return value;
    }
}