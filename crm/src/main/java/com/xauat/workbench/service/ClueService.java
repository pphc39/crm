package com.xauat.workbench.service;

import com.xauat.workbench.pojo.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionsForPage(Map<String, Object> map);

    int queryClueCountByConditions(Map<String, Object> map);

    Clue queryClueById(String id);

    int saveEditClue(Clue clue);

    int deleteClueByIds(String[] ids);

    Clue queryClueDetailById(String id);

    void saveConvertClue(Map<String, Object> map);
}
