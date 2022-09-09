package com.xauat.settings.web.controller;


import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.DateUtils;
import com.xauat.settings.pojo.User;
import com.xauat.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/goLogin")
    public String goLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userService.selectByLoginActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();
        if (user == null) {
            //登录失败，用户名或密码错误
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("用户名或密码错误");
        }else {
            if(DateUtils.formatDateTime(new Date()).compareTo(DateUtils.formatDateTime(user.getExpireTime()))>0){
                //用户已过期
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("用户已过期");
            }else if(!"1".equals(user.getLockState())){
                //用户状态被锁定
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("用户状态被锁定");
            } else if(!user.getAllowIps().contains(request.getRemoteAddr())){
                //ip受限
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("ip受限");
            } else {
                //登陆成功
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                session.setAttribute(Constants.SESSION_USER, user);

                //十天内免登录
                if ("true".equals(isRemPwd)) {
                    Cookie cookie1 = new Cookie("loginAct", user.getLoginAct());
                    Cookie cookie2 = new Cookie("loginPwd", user.getLoginPwd());
                    cookie1.setMaxAge(60*60*24*10);
                    cookie2.setMaxAge(60*60*24*10);
                    response.addCookie(cookie1);
                    response.addCookie(cookie2);
                }else {
                    //如果前一次勾选了免登录，但是一下次取消了免登录，要将前一次cookies中的用户名和密码删除
                    Cookie cookie1 = new Cookie("loginAct", user.getLoginAct());
                    Cookie cookie2 = new Cookie("loginPwd", user.getLoginPwd());
                    cookie1.setMaxAge(0);
                    cookie2.setMaxAge(0);
                    response.addCookie(cookie1);
                    response.addCookie(cookie2);
                }
            }
        }
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout")
    public String logout(HttpServletResponse response, HttpSession session){
        //清空cookie中的用户名和密码
        Cookie cookie1 = new Cookie("loginAct", "1");
        Cookie cookie2 = new Cookie("loginPwd", "1");
        cookie1.setMaxAge(0);
        cookie2.setMaxAge(0);
        response.addCookie(cookie1);
        response.addCookie(cookie2);
        //销毁session
        session.invalidate();
        return "redirect:/";
    }

    @RequestMapping("/settings/qx/user/saveEditLoginPwd")
    @ResponseBody
    public Object saveEditLoginPwd(User user){
        ReturnObject returnObject = new ReturnObject();
        try{
            int updateNum = userService.saveEditLoginPwd(user);
            if(updateNum>0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("修改密码失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("修改密码失败，请重新尝试！");
        }
        return returnObject;
    }
}
