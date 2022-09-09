package com.xauat.workbench.service.impl;

import com.xauat.commoms.constants.Constants;
import com.xauat.commoms.utils.UUIDUtils;
import com.xauat.settings.pojo.User;
import com.xauat.workbench.mapper.CustomerMapper;
import com.xauat.workbench.mapper.TransactionHistoryMapper;
import com.xauat.workbench.mapper.TransactionMapper;
import com.xauat.workbench.mapper.TransactionRemarkMapper;
import com.xauat.workbench.pojo.Customer;
import com.xauat.workbench.pojo.Transaction;
import com.xauat.workbench.pojo.TransactionHistory;
import com.xauat.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private TransactionMapper transactionMapper;

    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public void saveCreateTransaction(Map<String, Object> map) {
        User user = (User) map.get(Constants.SESSION_USER);
        String customerName = (String) map.get("customerName");
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer==null){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID32());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(new Date());
            customerMapper.insertCustomer(customer);
        }
       Transaction transaction = new Transaction();
        transaction.setId(UUIDUtils.getUUID32());
        transaction.setOwner((String) map.get("owner"));
        transaction.setMoney((String) map.get("money"));
        transaction.setName((String) map.get("name"));
        transaction.setExpectedDate((Date) map.get("expectedDate"));
        transaction.setCustomerId(customer.getId());
        transaction.setStage((String) map.get("stage"));
        transaction.setType((String) map.get("type"));
        transaction.setSource((String) map.get("source"));
        transaction.setActivityId((String) map.get("activityId"));
        transaction.setContactsId((String) map.get("contactsId"));
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(new Date());
        transaction.setDescription((String) map.get("description"));
        transaction.setContactSummary((String) map.get("contactSummary"));
        transaction.setNextContactTime((Date) map.get("nextContactTime"));
        transactionMapper.insertTransaction(transaction);

        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtils.getUUID32());
        transactionHistory.setStage((String) map.get("stage"));
        transactionHistory.setMoney((String) map.get("money"));
        transactionHistory.setExpectedDate((Date) map.get("expectedDate"));
        transactionHistory.setCreateTime(new Date());
        transactionHistory.setCreateBy(user.getId());
        transactionHistory.setTranId(transaction.getId());
        transactionHistoryMapper.insertTransactionHistory(transactionHistory);
    }

    @Override
    public List<Transaction> queryTransactionByConditionsForPage(Map<String, Object> map) {
        return transactionMapper.selectTransactionByConditionsForPage(map);
    }

    @Override
    public int queryTransactionCountByConditions(Map<String, Object> map) {
        return transactionMapper.selectTransactionCountByConditions(map);
    }

    @Override
    public Transaction queryTransactionDetailById(String id) {
        return transactionMapper.selectTransactionDetailById(id);
    }

    @Override
    public void deleteTransactionByIds(String[] ids) {
        //删除与交易相关的交易备注
        transactionRemarkMapper.deleteTransactionRemarkByTransactionIds(ids);
        //删除与交易相关的交易历史
        transactionHistoryMapper.deleteTransactionHistoryByTransactionIds(ids);
        //删除交易
        transactionMapper.deleteTransactionByIds(ids);
    }

    @Override
    public Transaction queryTransactionForEditById(String id) {
        return transactionMapper.selectTransactionForEditById(id);
    }

    @Override
    public void saveEditTransaction(Map<String, Object> map) {
        User user = (User) map.get(Constants.SESSION_USER);
        String customerName = (String) map.get("customerName");
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if(customer == null){
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID32());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(new Date());
            customerMapper.insertCustomer(customer);
        }

        Transaction transaction = (Transaction) map.get("transaction");
        transaction.setCustomerId(customer.getId());
        transaction.setEditBy(user.getId());
        transaction.setEditTime(new Date());
        transactionMapper.updateTransaction(transaction);

        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtils.getUUID32());
        transactionHistory.setStage(transaction.getStage());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setCreateTime(new Date());
        transactionHistory.setCreateBy(user.getId());
        transactionHistory.setTranId(transaction.getId());
        transactionHistoryMapper.insertTransactionHistory(transactionHistory);
    }
}
