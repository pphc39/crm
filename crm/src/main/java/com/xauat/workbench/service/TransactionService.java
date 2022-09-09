package com.xauat.workbench.service;

import com.xauat.workbench.pojo.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    void saveCreateTransaction(Map<String, Object> map);

    List<Transaction> queryTransactionByConditionsForPage(Map<String, Object> map);

    int queryTransactionCountByConditions(Map<String, Object> map);

    Transaction queryTransactionDetailById(String id);

    void deleteTransactionByIds(String[] ids);

    Transaction queryTransactionForEditById(String id);

    void saveEditTransaction(Map<String, Object> map);
}
