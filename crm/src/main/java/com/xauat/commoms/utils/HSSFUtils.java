package com.xauat.commoms.utils;

import com.xauat.workbench.pojo.Activity;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.util.List;

public class HSSFUtils {
    public static HSSFWorkbook createActivityWorkBook(List<Activity> activityList){
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("花费");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        if(activityList != null && activityList.size()>0){
            Activity activity = null;
            for (int i=0; i<activityList.size(); i++ ){
                activity = activityList.get(i);
                 row = sheet.createRow(i + 1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(DateUtils.formatDate(activity.getStartDate()));
                cell = row.createCell(4);
                cell.setCellValue(DateUtils.formatDate(activity.getEndDate()));
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(DateUtils.formatDateTime(activity.getCreateTime()));
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                if (activity.getEditTime() != null) {
                    cell.setCellValue(DateUtils.formatDateTime(activity.getEditTime()));
                }else {
                    cell.setCellValue("");
                }
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        return workbook;
    }

    public static HSSFWorkbook createActivityModule(){
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("市场活动");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("名称");
        cell = row.createCell(1);
        cell.setCellValue("开始日期（格式：yyyy-MM-dd）");
        cell = row.createCell(2);
        cell.setCellValue("结束日期（格式：yyyy-MM-dd）");
        cell = row.createCell(3);
        cell.setCellValue("花费（必须是正整数）");
        cell = row.createCell(4);
        cell.setCellValue("描述");

        return workbook;
    }

    public static String getCellValueToStr(HSSFCell cell){
        String valueToStr = "";
        if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
            valueToStr = cell.getStringCellValue();
        }else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
            valueToStr = cell.getNumericCellValue() + "";
        }else if(cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN){
            valueToStr = cell.getBooleanCellValue() + "";
        }else if(cell.getCellType() == HSSFCell.CELL_TYPE_FORMULA){
            valueToStr = cell.getCellFormula();
        }else{
            valueToStr = "";
        }
        return valueToStr;
    }
}
