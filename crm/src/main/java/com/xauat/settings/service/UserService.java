package com.xauat.settings.service;

import com.xauat.settings.pojo.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User selectByLoginActAndPwd(Map<String, Object> map);

    List<User> selectAllUsers();

    int saveEditLoginPwd(User user);
}
