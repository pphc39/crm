package com.xauat.workbench.service.impl;

import com.xauat.workbench.mapper.ContactsMapper;
import com.xauat.workbench.pojo.Contacts;
import com.xauat.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsByNameAndCustomerId(Map<String, Object> map) {
        return contactsMapper.selectContactsByNameAndCustomerId(map);
    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }
}
