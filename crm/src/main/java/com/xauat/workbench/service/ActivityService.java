package com.xauat.workbench.service;

import com.xauat.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionsForPage(Map<String, Object> map);

    int queryActivityCountByConditions(Map<String, Object> map);

    int deleteActivityByIds(String[] ids);

    //用于修改活动信息时查询所要修改的活动信息
    Activity queryActivityById(String id);

    int updateEditActivity(Activity activity);

    List<Activity> queryAllActivity();

    List<Activity> queryActivityByConditions(Map<String, Object> map);

    List<Activity> querySomeActivityByIds(String[] ids);

    int saveActivityList(List<Activity> activityList);

    Activity queryActivityDetailById(String id);

    List<Activity> queryActivityByClueId(String clueId);

    List<Activity> queryActivityByNameAndClueId(Map<String, Object> map);

    List<Activity> queryActivityByNameWithClueId(Map<String, Object> map);

    List<Activity> queryActivityByName(String name);
}
