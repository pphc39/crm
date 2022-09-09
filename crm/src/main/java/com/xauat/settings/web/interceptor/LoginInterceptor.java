package com.xauat.settings.web.interceptor;

import com.xauat.commoms.constants.Constants;
import com.xauat.settings.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //判断是否登录过
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);
        if (user==null) {
            //user为空说明没有登录过，跳转到登录页面
            response.sendRedirect(request.getContextPath());
            return false;
        }
        return true;
    }
}
