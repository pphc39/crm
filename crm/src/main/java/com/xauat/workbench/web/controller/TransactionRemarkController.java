package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.workbench.pojo.TransactionRemark;
import com.xauat.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class TransactionRemarkController {
    @Autowired
    private TransactionRemarkService transactionRemarkService;

    @RequestMapping("/workbench/transaction/saveCreateTransactionRemark")
    @ResponseBody
    public Object saveCreateTransactionRemark(TransactionRemark transactionRemark, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        transactionRemark.setId(UUIDUtils.getUUID32());
        transactionRemark.setCreateBy(user.getId());
        transactionRemark.setCreateTime(new Date());
        transactionRemark.setEditFlag(Constants.EDIT_FLAG_NO);
        try {
            int insertNum = transactionRemarkService.saveCreateTransactionRemark(transactionRemark);
            if (insertNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                returnObject.setReturnData(transactionRemark);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("交易备注添加失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("交易备注添加失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTransactionRemarkById")
    @ResponseBody
    public Object deleteTransactionRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int deleteNum = transactionRemarkService.deleteTransactionRemarkById(id);
            if (deleteNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("删除交易备注失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("删除交易备注失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/saveEditTransactionRemark")
    @ResponseBody
    public Object saveEditTransactionRemark(TransactionRemark transactionRemark, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        transactionRemark.setEditBy(user.getId());
        transactionRemark.setEditTime(new Date());
        transactionRemark.setEditFlag(Constants.EDIT_FLAG_YES);
        try {
            int updateNum = transactionRemarkService.saveEditTransactionRemark(transactionRemark);
            if (updateNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                returnObject.setReturnData(transactionRemark);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("修改交易备注失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("修改交易备注失败，请重新尝试！");
        }

        return returnObject;
    }
}
