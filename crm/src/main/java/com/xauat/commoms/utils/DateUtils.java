package com.xauat.commoms.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {

    public static String formatDateTime(Date date){
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sf.format(date);
    }

    public static String formatDate(Date date){
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        return sf.format(date);
    }

    public static Date parseDate(String date) throws Exception{
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        return sf.parse(date);
    }
}
