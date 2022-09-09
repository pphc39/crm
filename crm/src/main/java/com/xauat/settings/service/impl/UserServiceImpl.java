package com.xauat.settings.service.impl;

import com.xauat.settings.mapper.UserMapper;
import com.xauat.settings.pojo.User;
import com.xauat.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User selectByLoginActAndPwd(Map<String, Object> map) {
        return userMapper.selectByLoginActAndPwd(map);
    }

    @Override
    public List<User> selectAllUsers() {
        return userMapper.selectAllUsers();
    }

    @Override
    public int saveEditLoginPwd(User user) {
        return userMapper.updateLoginPwd(user);
    }
}
