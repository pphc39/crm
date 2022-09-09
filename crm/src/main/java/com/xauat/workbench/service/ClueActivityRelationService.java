package com.xauat.workbench.service;

import com.xauat.workbench.pojo.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationService {
    int saveBundActivityByList(List<ClueActivityRelation> list);

    int dropBundActivityByActivityIdAndClueId(Map<String, Object> map);
}
