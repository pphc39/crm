package com.xauat.settings.service;

import com.xauat.settings.pojo.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);

    String queryDicValueValueById(String id);
}
