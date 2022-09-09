package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.settings.service.UserService;
import com.xauat.workbench.pojo.Customer;
import com.xauat.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.spec.ECField;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class CustomerController {

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @RequestMapping("/workbench/customer/index")
    public String index(HttpServletRequest request){
        List<User> userList = userService.selectAllUsers();

        request.setAttribute("userList", userList);

        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/queryCustomerByConditionsForPage")
    @ResponseBody
    public Object queryCustomerByConditionsForPage(String name, String owner, String phone, String website, int pageNo, int pageSize){
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        map.put("startNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);

        List<Customer> customerList = customerService.queryCustomerByConditionsForPage(map);
        int customerCount = customerService.queryCustomerCountByConditions(map);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("customerList", customerList);
        returnMap.put("customerCount", customerCount);

        return returnMap;
    }

    @RequestMapping("/workbench/customer/judgeCustomerExist")
    @ResponseBody
    public Object judgeCustomerExist(String name){
        ReturnObject returnObject = new ReturnObject();
        Customer customer = customerService.queryCustomerByName(name);
        if(customer == null){
            returnObject.setFlag("no");
        }else {
            returnObject.setFlag("yes");
            returnObject.setMessage("此客户已经存在，无法再次创建！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        customer.setId(UUIDUtils.getUUID32());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(new Date());

        try {
            int insertNum = customerService.saveCreateCustomer(customer);
            if (insertNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("添加客户失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("添加客户失败，请重新尝试！");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerById")
    @ResponseBody
    public Object queryCustomerById(String id){
        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }

    @RequestMapping("/workbench/customer/saveEditCustomer")
    @ResponseBody
    public Object saveEditCustomer(Customer customer, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        customer.setEditBy(user.getId());
        customer.setEditTime(new Date());

        try {
            int updateNum = customerService.saveEditCustomer(customer);
            if(updateNum>0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("修改客户信息失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("修改客户信息失败，请重新尝试！");
        }
        return returnObject;
    }
}
