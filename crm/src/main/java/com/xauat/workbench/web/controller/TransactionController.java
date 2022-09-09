package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.settings.pojo.DicValue;
import com.xauat.settings.pojo.User;
import com.xauat.settings.service.DicValueService;
import com.xauat.settings.service.UserService;
import com.xauat.workbench.pojo.*;
import com.xauat.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TransactionController {

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private TransactionRemarkService transactionRemarkService;

    @Autowired
    private TransactionHistoryService transactionHistoryService;

    @RequestMapping("/workbench/transaction/index")
    public String index(HttpServletRequest request){
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("stageList", stageList);
        request.setAttribute("transactionTypeList", transactionTypeList);
        request.setAttribute("sourceList", sourceList);

        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/queryTransactionByConditionsForPage")
    @ResponseBody
    public Object queryTransactionByConditionsForPage(String owner, String name, String customerName, String stage, String type, String source, String contactsName, Integer pageNo, Integer pageSize){
        Map<String, Object> map = new HashMap<>();
        map.put("owner", owner);
        map.put("name", name);
        map.put("customerName", customerName);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contactsName", contactsName);
        map.put("startNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);

        List<Transaction> transactionList = transactionService.queryTransactionByConditionsForPage(map);
        int transactionCount = transactionService.queryTransactionCountByConditions(map);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("transactionList", transactionList);
        returnMap.put("transactionCount", transactionCount);

        return returnMap;
    }

    @RequestMapping("/workbench/transaction/toSave")
    public String toSave(HttpServletRequest request){
        List<User> userList = userService.selectAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("transactionTypeList", transactionTypeList);
        request.setAttribute("sourceList", sourceList);

        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/queryActivityByName")
    @ResponseBody
    public Object queryActivityByName(String name){
        List<Activity> activityList = activityService.queryActivityByName(name);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryCustomerIdByName")
    @ResponseBody
    public Object queryCustomerIdByName(String name){
        ReturnObject returnObject = new ReturnObject();
        Customer customer = customerService.queryCustomerByName(name);
        if(customer==null){
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
        }else {
            returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            returnObject.setReturnData(customer);
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/queryContactsByNameAndCustomerId")
    @ResponseBody
    public Object queryContactsByNameAndCustomerId(@RequestParam Map<String, Object> map){
        List<Contacts> contactsList = contactsService.queryContactsByNameAndCustomerId(map);
        return contactsList;
    }

    @RequestMapping("/workbench/transaction/queryPossibilityByStage")
    @ResponseBody
    public Object queryPossibilityByStage(String stageValue){
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);
        return possibility;
    }

    @RequestMapping("/workbench/transaction/queryCustomerNameByName")
    @ResponseBody
    public Object queryCustomerNameByName(String name){
        List<String> nameList = customerService.queryCustomerNameByName(name);
        return nameList;
    }

    @RequestMapping("/workbench/transaction/saveCreateTransaction")
    @ResponseBody
    public Object saveCreateTransaction(@RequestParam Map<String, Object> map, @DateTimeFormat(pattern = "yyyy-MM-dd") Date expectedDate, @DateTimeFormat(pattern = "yyyy-MM-dd") Date nextContactTime, HttpSession session){
        map.put("expectedDate", expectedDate);
        map.put("nextContactTime", nextContactTime);
        map.put(Constants.SESSION_USER, session.getAttribute(Constants.SESSION_USER));
        ReturnObject returnObject = new ReturnObject();
        try {
            transactionService.saveCreateTransaction(map);
            returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("添加交易失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/toTransactionDetail")
    public String toTransactionDetail(String id, HttpServletRequest request){
        Transaction transaction = transactionService.queryTransactionDetailById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(transaction.getStage());
        transaction.setPossibility(possibility);
        List<TransactionRemark> transactionRemarkList = transactionRemarkService.queryTransactionRemarkByTransactionId(id);
        List<TransactionHistory> transactionHistoryList = transactionHistoryService.queryTransactionHistoryByTransactionId(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        request.setAttribute("transaction", transaction);
        request.setAttribute("transactionRemarkList", transactionRemarkList);
        request.setAttribute("transactionHistoryList", transactionHistoryList);
        request.setAttribute("stageList", stageList);

        return "workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/deleteTransactionByIds")
    @ResponseBody
    public Object deleteTransactionByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            transactionService.deleteTransactionByIds(id);
            returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("删除交易失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/toTransactionEdit")
    public String toTransactionEdit(String id, HttpServletRequest request){
        List<User> userList = userService.selectAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        Transaction transaction = transactionService.queryTransactionForEditById(id);

        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("transactionTypeList", transactionTypeList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("transaction", transaction);
        return "workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/queryTransactionForEditById")
    @ResponseBody
    public Object queryTransactionForEditById(String id){
        Transaction transaction = transactionService.queryTransactionForEditById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(dicValueService.queryDicValueValueById(transaction.getStage()));
        transaction.setPossibility(possibility);

        Customer customer = customerService.queryCustomerById(transaction.getCustomerId());
        Activity activity = activityService.queryActivityById(transaction.getActivityId());
        Contacts contacts = contactsService.queryContactsById(transaction.getContactsId());

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("transaction", transaction);
        returnMap.put("customer", customer);
        returnMap.put("activity", activity);
        returnMap.put("contacts", contacts);

        return returnMap;
    }

    @RequestMapping("/workbench/transaction/saveEditTransaction")
    @ResponseBody
    public Object saveEditTransaction(Transaction transaction, String customerName, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("transaction", transaction);
        map.put("customerName", customerName);
        map.put(Constants.SESSION_USER, user);
        try {
            transactionService.saveEditTransaction(map);
            returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("交易信息修改失败，请重新尝试！");
        }
        return returnObject;
    }
}
