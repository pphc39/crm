package com.xauat.commoms.utils;

import java.util.UUID;

public class UUIDUtils {

    public static String getUUID32(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
