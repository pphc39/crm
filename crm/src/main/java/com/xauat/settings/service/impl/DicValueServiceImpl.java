package com.xauat.settings.service.impl;

import com.xauat.settings.mapper.DicValueMapper;
import com.xauat.settings.pojo.DicValue;
import com.xauat.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }

    @Override
    public String queryDicValueValueById(String id) {
        return dicValueMapper.selectDicValueValueById(id);
    }
}
