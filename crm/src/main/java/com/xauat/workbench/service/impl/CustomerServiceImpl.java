package com.xauat.workbench.service.impl;

import com.xauat.workbench.mapper.CustomerMapper;
import com.xauat.workbench.pojo.Customer;
import com.xauat.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<Customer> queryCustomerByConditionsForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionsForPage(map);
    }

    @Override
    public int queryCustomerCountByConditions(Map<String, Object> map) {
        return customerMapper.selectCustomerCountByConditions(map);
    }

    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    @Override
    public Customer queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }

    @Override
    public List<String> queryCustomerNameByName(String name) {
        return customerMapper.selectCustomerNameByName(name);
    }
}
