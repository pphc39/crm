package com.xauat.workbench.service;

import com.xauat.workbench.pojo.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsByNameAndCustomerId(Map<String, Object> map);

    Contacts queryContactsById(String id);
}
