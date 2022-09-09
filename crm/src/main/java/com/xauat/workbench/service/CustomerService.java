package com.xauat.workbench.service;

import com.xauat.workbench.pojo.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    List<Customer> queryCustomerByConditionsForPage(Map<String, Object> map);

    int queryCustomerCountByConditions(Map<String, Object> map);

    int saveCreateCustomer(Customer customer);

    Customer queryCustomerById(String id);

    int saveEditCustomer(Customer customer);

    Customer queryCustomerByName(String name);

    List<String> queryCustomerNameByName(String name);
}
