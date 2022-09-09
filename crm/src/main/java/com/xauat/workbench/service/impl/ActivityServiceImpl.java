package com.xauat.workbench.service.impl;

import com.xauat.workbench.mapper.ActivityMapper;
import com.xauat.workbench.pojo.Activity;
import com.xauat.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int saveCreateActivity(Activity activity) {

        int saveNum = activityMapper.insertCreateActivity(activity);

        return saveNum;
    }

    @Override
    public List<Activity> queryActivityByConditionsForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionsForPage(map);
    }

    @Override
    public int queryActivityCountByConditions(Map<String, Object> map) {
        return activityMapper.selectActivityCountByConditions(map);
    }

    @Override
    public int deleteActivityByIds(String[] ids) {
        return activityMapper.deleteActivityByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int updateEditActivity(Activity activity) {
        return activityMapper.updateEditActivity(activity);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public List<Activity> queryActivityByConditions(Map<String, Object> map) {
        return activityMapper.selectActivityByConditions(map);
    }

    @Override
    public List<Activity> querySomeActivityByIds(String[] ids) {
        return activityMapper.selectSomeActivityByIds(ids);
    }

    @Override
    public int saveActivityList(List<Activity> activityList) {
        return activityMapper.insertActivityList(activityList);
    }

    @Override
    public Activity queryActivityDetailById(String id) {
        return activityMapper.selectActivityDetailById(id);
    }

    @Override
    public List<Activity> queryActivityByClueId(String clueId) {
        return activityMapper.selectActivityByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityByNameAndClueId(Map<String, Object> map) {
        return activityMapper.selectActivityByNameAndClueId(map);
    }

    @Override
    public List<Activity> queryActivityByNameWithClueId(Map<String, Object> map) {
        return activityMapper.selectActivityByNameWithClueId(map);
    }

    @Override
    public List<Activity> queryActivityByName(String name) {
        return activityMapper.selectActivityByName(name);
    }
}
