package com.xauat.workbench.service.impl;

import com.xauat.workbench.mapper.ClueActivityRelationMapper;
import com.xauat.workbench.pojo.ClueActivityRelation;
import com.xauat.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int saveBundActivityByList(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertCARByList(list);
    }

    @Override
    public int dropBundActivityByActivityIdAndClueId(Map<String, Object> map) {
        return clueActivityRelationMapper.deleteCARByActivityIdAndClueId(map);
    }
}
