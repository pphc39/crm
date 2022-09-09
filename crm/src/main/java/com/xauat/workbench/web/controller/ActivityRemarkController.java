package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.workbench.pojo.ActivityRemark;
import com.xauat.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setId(UUIDUtils.getUUID32());
        activityRemark.setCreateTime(new Date());
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag(Constants.EDIT_FLAG_NO);

        ReturnObject returnObject = new ReturnObject();
        try {
            int insertNum = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if (insertNum > 0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                returnObject.setReturnData(activityRemark);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("添加备注失败，请重新添加！");
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("添加备注失败，请重新添加！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkById")
    @ResponseBody
    public Object deleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int deleteNum = activityRemarkService.deleteActivityRemarkById(id);
            if(deleteNum > 0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("删除备注失败，请重新尝试！");
            }
        } catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("删除备注失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/activity/saveEditActivityRemark")
    @ResponseBody
    public Object saveEditActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        activityRemark.setEditTime(new Date());
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag(Constants.EDIT_FLAG_YES);

        try {
            int updateNum = activityRemarkService.saveEditActivityRemark(activityRemark);
            if(updateNum > 0 ){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                returnObject.setReturnData(activityRemark);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("修改备注失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("修改备注失败，请重新尝试！");
        }

        return returnObject;
    }
}
