package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.workbench.pojo.ClueRemark;
import com.xauat.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/workbench/clue/saveCreateClueRemark")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        clueRemark.setId(UUIDUtils.getUUID32());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(new Date());
        clueRemark.setEditFlag(Constants.EDIT_FLAG_NO);
        try {
            int saveNum = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (saveNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                returnObject.setReturnData(clueRemark);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("添加备注失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("添加备注失败，请重新尝试！");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueRemarkById")
    @ResponseBody
    public Object deleteClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int deleteNum = clueRemarkService.deleteClueRemarkById(id);
            if (deleteNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("备注删除失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("备注删除失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/saveEditClueRemark")
    @ResponseBody
    public  Object saveEditClueRemark(ClueRemark clueRemark, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(new Date());
        clueRemark.setEditFlag(Constants.EDIT_FLAG_YES);

        try {
            int updateNum = clueRemarkService.saveEditClueRemark(clueRemark);
            if (updateNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                returnObject.setReturnData(clueRemark);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("备注修改失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("备注修改失败，请重新尝试！");
        }

        return returnObject;
    }
}

