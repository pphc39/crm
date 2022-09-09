package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.DateUtils;
import com.xauat.commoms.utils.HSSFUtils;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.settings.service.UserService;
import com.xauat.workbench.pojo.Activity;
import com.xauat.workbench.pojo.ActivityRemark;
import com.xauat.workbench.service.ActivityRemarkService;
import com.xauat.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
    @InitBinder
    public void dateBinder(WebDataBinder dataBinder){
        dataBinder.registerCustomEditor(Date.class, new CustomDateEditor(sf, true));
    }

    @RequestMapping("/workbench/activity/index")
    public String index(HttpServletRequest request){
        List<User> userList = userService.selectAllUsers();
        request.setAttribute("userList", userList);
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        activity.setId(UUIDUtils.getUUID32());
        activity.setCreateTime(new Date());
        activity.setCreateBy(user.getId());

        try {
            int saveNum = activityService.saveCreateActivity(activity);
            if (saveNum>0) {
                //保存活动成功
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                //保存活动失败
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("存活动失败，请重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            //保存活动失败
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("存活动失败，请重试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionsForPage")
    @ResponseBody
    public Object queryActivityByConditionsForPage(String owner, String name, Date startDate, Date endDate, int pageNo, int pageSize){
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("startNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);

        List<Activity> activityList = activityService.queryActivityByConditionsForPage(map);
        int activityCount = activityService.queryActivityCountByConditions(map);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("activityList", activityList);
        returnMap.put("activityCount", activityCount);

        return returnMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int deleteNum = activityService.deleteActivityByIds(id);
            if(deleteNum>0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("活动删除失败，请重试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("活动删除失败，请重试！");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityById")
    @ResponseBody
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/updateEditActivity")
    @ResponseBody
    public Object updateEditActivity(Activity activity, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(new Date());
        ReturnObject returnObject = new ReturnObject();
        try {
            int updateNum = activityService.updateEditActivity(activity);
            if (updateNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("修改失败，请重新尝试！");
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("修改失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/exportAllActivity")
    public void exportAllActivity(HttpServletResponse response) throws Exception{
        List<Activity> activityList = activityService.queryAllActivity();

        HSSFWorkbook workbook = HSSFUtils.createActivityWorkBook(activityList);

        response.setContentType("application/octet-stream; charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment; filename=AllActivityList.xls");
        OutputStream out = response.getOutputStream();
        workbook.write(out);

        workbook.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportAllQueryActivity")
    public void exportAllQueryActivity(String owner, String name, Date startDate, Date endDate, HttpServletResponse response) throws Exception{
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("startDate", startDate);
        map.put("endDate", endDate);

        List<Activity> activityList = activityService.queryActivityByConditions(map);

        HSSFWorkbook workbook = HSSFUtils.createActivityWorkBook(activityList);

        response.setContentType("application/octet-stream; charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment; filename=AllQueryActivityList.xls");
        OutputStream out = response.getOutputStream();
        workbook.write(out);

        workbook.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportSomeActivity")
    public void exportSomeActivity(String[] id, HttpServletResponse response) throws Exception{
        List<Activity> activityList = activityService.querySomeActivityByIds(id);

        HSSFWorkbook workbook = HSSFUtils.createActivityWorkBook(activityList);

        response.setContentType("application/octet-stream; charset=UTF-8");
        response.addHeader("Content-Disposition", "attachment; filename=SomeActivityList.xls");
        OutputStream out = response.getOutputStream();
        workbook.write(out);

        workbook.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/downloadActivityModule")
    public void downloadActivityModule(HttpServletResponse response) throws Exception{
        HSSFWorkbook workbook = HSSFUtils.createActivityModule();

        response.setContentType("application/octet-stream; charset=utf-8");
        response.addHeader("Content-Disposition", "attachment; filename=ActivityModule.xls");
        OutputStream out = response.getOutputStream();
        workbook.write(out);

        workbook.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/importActivityFile")
    @ResponseBody
    public Object importActivityFile(MultipartFile activityFile, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
            InputStream inputStream = activityFile.getInputStream();
            HSSFWorkbook workbook = new HSSFWorkbook(inputStream);
            HSSFSheet sheet = workbook.getSheetAt(0);
            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            List<Activity> activityList = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID32());
                activity.setOwner(user.getId());
                activity.setCreateTime(new Date());
                activity.setCreateBy(user.getId());
                row = sheet.getRow(i);
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    cell = row.getCell(j);
                    String valueToStr = HSSFUtils.getCellValueToStr(cell);
                    if (j == 0) {
                        activity.setName(valueToStr);
                    }else if(j == 1){
                        activity.setStartDate(DateUtils.parseDate(valueToStr));
                    }else if(j == 2){
                        activity.setEndDate(DateUtils.parseDate(valueToStr));
                    }
                    else if(j == 3){
                        //cost设置的只能为正整数
                        activity.setCost(valueToStr.substring(0, valueToStr.indexOf(".")));
                    }
                    else if(j == 4){
                        activity.setDescription(valueToStr);
                    }
                }
                activityList.add(activity);
            }
            int insertNum = activityService.saveActivityList(activityList);
            returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            returnObject.setMessage("成功导入"+insertNum+"条活动！");
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("导入活动失败，请重试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/toActivityDetail")
    public String toActivityDetail(String id, HttpServletRequest request){
        Activity activity = activityService.queryActivityDetailById(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkByActivityId(id);

        request.setAttribute("activity", activity);
        request.setAttribute("activityRemarkList", activityRemarkList);

        return "workbench/activity/detail";
    }
}
