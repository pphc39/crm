package com.xauat.workbench.web.controller;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.pojo.ReturnObject;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.DicValue;
import com.xauat.settings.pojo.User;
import com.xauat.settings.service.DicValueService;
import com.xauat.settings.service.UserService;
import com.xauat.workbench.pojo.Activity;
import com.xauat.workbench.pojo.Clue;
import com.xauat.workbench.pojo.ClueActivityRelation;
import com.xauat.workbench.pojo.ClueRemark;
import com.xauat.workbench.service.ActivityService;
import com.xauat.workbench.service.ClueActivityRelationService;
import com.xauat.workbench.service.ClueRemarkService;
import com.xauat.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index")
    public String index(HttpServletRequest request){
        List<User> userList = userService.selectAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("userList", userList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("clueStateList", clueStateList);
        request.setAttribute("sourceList", sourceList);

        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/saveCreateClue")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clue.setId(UUIDUtils.getUUID32());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(new Date());

        try{
            int insertNum = clueService.saveCreateClue(clue);
            if (insertNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("添加线索失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("添加线索失败，请重新尝试！");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryClueByConditionsForPage")
    @ResponseBody
    public Object queryClueByConditionsForPage(String fullname, String company, String phone, String source, String owner, String mphone, String state, int pageNo, int pageSize){
        HashMap<String, Object> map = new HashMap<>();
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        map.put("startNo", (pageNo-1)*pageSize);
        map.put("pageSize", pageSize);

        List<Clue> clueList = clueService.queryClueByConditionsForPage(map);
        int clueCount = clueService.queryClueCountByConditions(map);

        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("clueList", clueList);
        resultMap.put("clueCount", clueCount);

        return resultMap;
    }

    @RequestMapping("/workbench/clue/queryClueById")
    @ResponseBody
    public Object queryClueById(String id){
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/workbench/clue/saveEditClue")
    @ResponseBody
    public Object saveEditClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clue.setEditBy(user.getId());
        clue.setEditTime(new Date());

        try {
            int updateNum = clueService.saveEditClue(clue);
            if(updateNum>0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("更新线索失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("更新线索失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueByIds")
    @ResponseBody
    public Object deleteClueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteNum = clueService.deleteClueByIds(id);
            if(deleteNum>0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("删除线索失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("删除线索失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/toClueDetail")
    public String toClueDetail(String id, HttpServletRequest request){
        Clue clue = clueService.queryClueDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityByClueId(id);

        request.setAttribute("clue", clue);
        request.setAttribute("clueRemarkList", clueRemarkList);
        request.setAttribute("activityList", activityList);

        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryActivityByNameAndClueId")
    @ResponseBody
    public Object queryActivityByNameAndClueId(String name, String clueId){
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);

        List<Activity> activityList = activityService.queryActivityByNameAndClueId(map);

        return activityList;
    }

    @RequestMapping("/workbench/clue/saveBundActivityByList")
    @ResponseBody
    public Object saveBundActivityByList(String[] activityId, String clueId){
        ReturnObject returnObject = new ReturnObject();
        ClueActivityRelation clueActivityRelation = null;
        List<ClueActivityRelation> list = new ArrayList<>();
        for (String ai : activityId) {
            clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtils.getUUID32());
            clueActivityRelation.setActivityId(ai);
            clueActivityRelation.setClueId(clueId);
            list.add(clueActivityRelation);
        }
        try {
            int insertNum = clueActivityRelationService.saveBundActivityByList(list);
            if(insertNum>0){
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
                List<Activity> activityList = activityService.querySomeActivityByIds(activityId);
                returnObject.setReturnData(activityList);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("关联市场活动失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("关联市场活动失败，请重新尝试！");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/dropBundActivityByActivityIdAndClueId")
    @ResponseBody
    public Object dropBundActivityByActivityIdAndClueId(String activityId, String clueId){
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("activityId", activityId);
        map.put("clueId", clueId);

        try {
            int deleteNum = clueActivityRelationService.dropBundActivityByActivityIdAndClueId(map);
            if (deleteNum>0) {
                returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
            }else {
                returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
                returnObject.setMessage("解除市场活动关联失败，请重新尝试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("解除市场活动关联失败，请重新尝试！");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/toConvertClue")
    public String toConvertClue(String id, HttpServletRequest request){
        Clue clue = clueService.queryClueDetailById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        request.setAttribute("clue", clue);
        request.setAttribute("stageList",stageList);

        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityByNameWithClueId")
    @ResponseBody
    public Object queryActivityByNameWithClueId(String name, String clueId){
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);

        List<Activity> activityList = activityService.queryActivityByNameWithClueId(map);

        return activityList;
    }

    @RequestMapping("/workbench/clue/convertClue")
    @ResponseBody
    public Object convertClue(String clueId, String isCreateTransaction, String money, String name, @DateTimeFormat(pattern = "yyyy-MM-dd") Date expectedDate, String stage, String activityId, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        Map<String, Object> map = new HashMap<>();
        map.put("clueId", clueId);
        map.put("isCreateTransaction", isCreateTransaction);
        map.put("money", money);
        map.put("name", name);
        map.put("expectedDate", expectedDate);
        map.put("stage", stage);
        map.put("activityId", activityId);
        map.put(Constants.SESSION_USER, user);
        try {
            clueService.saveConvertClue(map);
            returnObject.setFlag(Constants.RETURN_FLAG_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setFlag(Constants.RETURN_FLAG_FAIL);
            returnObject.setMessage("转换失败，请重新尝试！");
        }
        return returnObject;
    }
}
